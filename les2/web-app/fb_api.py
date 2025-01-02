import firebase_admin.firestore
from flask import Blueprint, request;
from typing import *;
import firebase_admin;

api_bp = Blueprint("api", __name__, url_prefix="/api");

cred = firebase_admin.credentials.Certificate('../firebase_cert.json');
app = firebase_admin.initialize_app(cred);
fs = firebase_admin.firestore.client();

collection_billing_codes = fs.collection('billing_codes');
collection_comments = fs.collection('comments');

def comment_for_code(full_code: str):
    comment_doc = collection_comments.document(full_code).get();
    return comment_doc.to_dict()["content"] if comment_doc.exists else "";


@api_bp.route("/billing-code/<string:full_code>")
def get_billing_code(full_code: str): 
    doc = collection_billing_codes.document(full_code).get();
    if not doc.exists:
        return f'Error, billing code not found: ${full_code}', 404;
    return {**doc.to_dict(), "comment": comment_for_code(full_code)}, 200;

# I decided to put the partial_code in the search params, as it does not identify 
# a unique resource but rather is used to filter the billing codes.
@api_bp.route("/billing-code/search")
def search_billing_code():
    partial_code = request.args.get('partial_code');
    if not partial_code or len(partial_code) > 5 or not partial_code.isdigit():
        return f'Error, invalid input. URL must include partial_code search param that contains a sequence of five or less digits (representing the first part of the ICD code)', 400;
    # simulate startsWith: see https://stackoverflow.com/questions/46573804/firestore-query-documents-startswith-a-string
    code_upper_bound = partial_code[:-1] + chr(ord(partial_code[-1])+1);
    results = collection_billing_codes \
        .where('code', '>=', partial_code) \
        .where('code', '<', code_upper_bound).stream();
    return list(map(lambda result: {
            **result.to_dict(),
            "comment": comment_for_code(result.id)}, results));
    
@api_bp.route("/billing-code/<string:full_code>/comment", methods=('PUT',))
def update_comment(full_code: str):
    doc = collection_billing_codes.document(full_code).get();
    if not doc.exists:
        return f'Error, billing code not found: ${full_code}', 404;

    collection_comments.document(full_code).set({
        "content": request.json["content"],
    }, merge=True);
    return 'Success', 200;

