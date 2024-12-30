import pickle;
import firebase_admin
import firebase_admin.firestore;
import firebase_admin.auth;
import sqlite3;

cred = firebase_admin.credentials.Certificate("firebase_cert.json");
app = firebase_admin.initialize_app(cred, options={"projectId": "les2firestore"});

columns = ["code", "description", "number", "cost", "medical_field"];
obj = pickle.load(open("BillingCodes-29Oct2024.pik", "rb"));

fs = firebase_admin.firestore.client(app);
billing_codes = fs.collection("billing_codes");

writer = fs.bulk_writer()
def extractData(entry):
    code = entry[0];
    entry = entry[1:];

    cost = next((column for column in entry if column[0] == '$'), 'unknown');
    number = next((int(column) for column in entry if column.isdigit()), 0);
    description = next((column for column in entry if column[0].isupper()), 'Unknown');
    medical_field = next((column for column in entry if column[0].islower()), 'unknown');
    return {
        "code": code,
        "cost": cost,
        "description": description,
        "number": number,
        "medical_field": medical_field,
    }

data = list(map(extractData, obj.values()));

print('doing fb');
for datum in data:
    writer.set(billing_codes.document(f"{datum['code']}.{datum['number']}"), datum);
writer.close();
print('fb done!');

print('doing sqlite3')


with sqlite3.connect('les2db') as sqldb:
    cur = sqldb.cursor();
    cur.execute('''
                CREATE TABLE IF NOT EXISTS billing_codes (
                    code text, 
                    cost text, 
                    description text,
                    number integer,
                    medical_field text, 
                    PRIMARY KEY (code, number)
                );
                ''');
    print(list(map(lambda datum: (datum["code"], datum["cost"], datum["description"], datum["number"], datum["medical_field"]), data))[0:10]);
    cur.executemany('''
                INSERT INTO billing_codes (code, cost, description, number, medical_field) VALUES (?, ?, ?, ?, ?)
                ''', 
                list(map(lambda datum: (datum["code"], datum["cost"], datum["description"], datum["number"], datum["medical_field"]), data)));

    sqldb.commit();

print('done did the sql part of stuff!');





