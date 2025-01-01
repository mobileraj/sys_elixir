from flask import Blueprint, request;
from domain import *;
from typing import *;

api_bp = Blueprint("api", __name__, url_prefix="/api")

'''
Unlike the practice flask project, I decided to setup the api a little differently.
In that project, I had a distinct separation between api and pages. Api routes responded with 
json, page routes respond with html. However, it looks like the "flaskesque" way of proceeding is 
to redirect to the proper page in the api. 
'''

@api_bp.route("/billing-code/{full_code}")
def get_billing_code(full_code: str) -> BillingCode:
    pass;

# I decided to put the partial_code in the search params, as it does not identify 
# a unique resource but rather is used to filter the billing codes.
@api_bp.route("/billing-code/search")
def search_billing_code() -> BillingCode:
    partial_code = request.args.get('partial_code');
    pass;

@api_bp.route("/billing-code/{full_code}/comment", methods=('PUT',))
def update_comment():
    
