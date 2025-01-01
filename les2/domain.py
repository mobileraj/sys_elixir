# See https://fastapi.tiangolo.com/tutorial/extra-models/#reduce-duplication
class _BillingCodeBase:
    code: str;
    cost: str;
    description: str;
    medical_branch: str;

class BillingCodeDB(_BillingCodeBase):
    pass;

class BillingCode(_BillingCodeBase):
    comment: str;
