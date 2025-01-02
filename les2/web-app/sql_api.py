from flask import Blueprint, request;
from typing import *;
import sqlite3;
import atexit;

api_bp = Blueprint("api", __name__, url_prefix="/api");

def dict_row_factory(cursor, row):
    fields = [column[0] for column in cursor.description];
    return {key: value for key, value in zip(fields, row)};

#SQLite connectiosn can't be accessed by default in different threads
db = sqlite3.connect('../les2db', check_same_thread=False);
db.row_factory = dict_row_factory;

def cleanup():
    db.close();

atexit.register(cleanup);

@api_bp.route("/billing-code/<string:full_code>")
def get_billing_code(full_code: str):
    res_cur = db.cursor().execute('''
               SELECT 
                billing_codes.code, 
                description,
                cost, 
                medical_branch, 
                content as comment 
               FROM billing_codes LEFT JOIN comments ON billing_codes.code = comments.code
               WHERE billing_codes.code = ?;
               ''', (full_code,));
    billing_code = res_cur.fetchone();
    if not billing_code:
        return f'Error, billing code not found: ${full_code}', 404;
    return {**billing_code, "comment": billing_code["comment"] if billing_code["comment"] else ""}, 200;

# I decided to put the partial_code in the search params, as it does not identify 
# a unique resource but rather is used to filter the billing codes.
@api_bp.route("/billing-code/search")
def search_billing_code():
    partial_code = request.args.get('partial_code');
    if not partial_code or len(partial_code) > 5 or not partial_code.isdigit():
        return f'Error, invalid input. URL must include partial_code search param that contains a sequence of five or less digits (representing the first part of the ICD code)', 400;
    res_cur = db.cursor().execute('''
               SELECT 
                billing_codes.code, 
                description,
                cost, 
                medical_branch, 
                content as comment 
               FROM billing_codes LEFT JOIN comments ON billing_codes.code = comments.code
               WHERE billing_codes.code LIKE ?
               ORDER BY billing_codes.code;
               ''', (partial_code + '%',));
    results = res_cur.fetchall();
    return list(map(lambda billing_code: {**billing_code, "comment": billing_code["comment"] if billing_code["comment"] else ""}, results)), 200;

@api_bp.route("/billing-code/<string:full_code>/comment", methods=('PUT',))
def update_comment(full_code: str):
    try:
        db.cursor().execute('''
                    INSERT INTO comments (code, content) VALUES (?, ?)
                        ON CONFLICT(code) DO UPDATE SET content=excluded.content;
                    ''', (full_code, request.json["content"]));
    except sqlite3.IntegrityError:
        return f'Error, billing code not found: ${full_code}', 404;
    return 'Success', 200;
    
