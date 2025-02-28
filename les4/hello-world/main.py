from contextlib import asynccontextmanager;
from fasthtml.common import *;
import json;

data = None;
@asynccontextmanager
async def lifespan(app):
    global data;
    with open("people.json") as data_file:
        data = json.load(data_file);
    yield;

app, *_ = fast_app(lifespan=lifespan);

@app.get('/')
def _():
    return Div(
        Div(A('Get user by email', href='/query-email')),
        Div(A('Get users by name', href='/query-name')),
        Div(A('Get users by state', href='/query-state')),
    );

@app.get('/query-email')
def _():
    return Form(
        Label('Enter email:'), 
        Input(type="email", name="email"), 
        Div(id="results"), 
        Button('Query'),
        hx_post='/query', hx_target="#results"
    );

@app.get('/query-name')
def _():
    return Form(
        Label('Enter name:'), 
        Input(type="name", name="name"), 
        Div(id="results"), 
        Button('Query'),
        hx_post='/query', hx_target="#results"
    );

@app.get('/query-state')
def _():
    return Form(
        Label('Enter state:'), 
        Input(type="state", name="state"), 
        Div(id="results"), 
        Button('Query'),
        hx_post='/query', hx_target="#results"
    );


@app.post('/query')
def _(email: str | None = None, name: str | None = None, state: str | None = None):
    if len(list(filter(lambda value: value, [email, name, state]))) != 1:
        raise HTTPException(status_code=400, detail="must include exactly one of the following query parameters: email, name, state");
    if email:
        filteredPeople = [person for person in data if person["email"] == email];
    elif name:
        filteredPeople = [person for person in data if person["name"] == name];
    elif state:
        filteredPeople = [person for person in data if person["address"]["state"] == state];
    
    if not filteredPeople:
        return "No results";
    return tuple(map(lambda person: (PersonView(person), Br()), filteredPeople));

def PersonView(person):
    return Div(
        Div("Email: ", person["email"]),
        Div("Name: ", person["name"]),
        Div(
            "Address: ",
            Div(
                Div("First line: ", person["address"]["firstLine"]),
                Div("City: ", person["address"]["city"]),
                Div("State: ", person["address"]["state"]),
                Div("Zip: ", person["address"]["zip"]),
                style="margin-left: 2rem"
            )
        )
    );

serve(host='localhost');