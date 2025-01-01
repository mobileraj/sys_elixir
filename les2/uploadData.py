import pickle;
import firebase_admin
import firebase_admin.firestore;
import firebase_admin.auth;
import sqlite3;
from domain import *;

cred = firebase_admin.credentials.Certificate("firebase_cert.json");
app = firebase_admin.initialize_app(cred, options={"projectId": "les2firestore"});

columns = ["code", "description", "cost", "medical_branch"];
obj = pickle.load(open("BillingCodes-29Oct2024.pik", "rb"));

fs = firebase_admin.firestore.client(app);
billing_codes = fs.collection("billing_codes");

writer = fs.bulk_writer();
def extractData(entry):
    partial_code = entry[0];
    entry = entry[1:];

    cost = next((column for column in entry if column[0] == '$'), 'unknown');
    number = next((int(column) for column in entry if column.isdigit()), 0);
    description = next((column for column in entry if column[0].isupper()), 'Unknown');
    medical_branch = next((column for column in entry if column[0].islower()), 'unknown');
    return BillingCodeDB.model_validate({
        "code": f"{partial_code}.{number}",
        "cost": cost,
        "description": description,
        "medical_branch": medical_branch,
    });

data = list(map(extractData, obj.values()));

print('doing fb');
for datum in data:
    writer.set(billing_codes.document(datum['code']), datum);
writer.close();
print('fb done!');

print('doing sqlite3')


with sqlite3.connect('les2db') as sqldb:
    cur = sqldb.cursor();
    cur.execute('''
                DROP TABLE billing_codes;
                ''');
    cur.execute('''
                CREATE TABLE billing_codes (
                    code text, 
                    cost text, 
                    description text,
                    medical_branch text, 
                    PRIMARY KEY (code)
                );
                ''');
    print(list(map(lambda datum: (datum["code"], datum["cost"], datum["description"], datum["medical_branch"]), data))[0:10]);
    cur.executemany('''
                INSERT INTO billing_codes (code, cost, description, medical_branch) VALUES (?, ?, ?, ?)
                ''', 
                list(map(lambda datum: (datum["code"], datum["cost"], datum["description"], datum["medical_branch"]), data)));

    sqldb.commit();

print('done did the sql part of stuff!');





