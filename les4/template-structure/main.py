from fasthtml.common import *;

app, *_ = fast_app(
    hdrs=(Title('FUH Web Template'))
);

def MainLayout(*children):  
    return Html(
        Head(    
            Style("* { box-sizing: border-box; };"),
        ),
        Body(
            CustomHeader(),
            Div(*children, id="page", style="width: 100%; padding: 3rem 4.17%;"),
            Footer(),
            style="""
                width: 100%;
                margin: 0;
            """
        ),
    )

def CustomHeader():
    return Header(
        PageLink('FUH Test', style='font-size: 1.25rem', path="/"),
        Div(
            PageLink("SIYO", style='font-style: italic;', path="/siyo"),
            PageLink("Notifications", style='font-style: italic;', path='/notifications'),
            PageLink("Billing", style='font-style: italic;', path="/billing"),
            PageLink("Admin", style='font-style: italic;', path="/admin"),
            style="display: flex; flex-direction: row; gap: 1rem"
        ),
        Button('Sign Out'),
        style=""" 
            width: 100%;
            background-color: #cacfd2; 
            padding: 1rem 2rem;
            display: flex;
            flex-direction: row;
            justify-content: space-between;
        """
    );
def PageLink(*children, path, **attrs):
    return Div(*children, hx_get=path, **attrs);

def Footer():
    return Div('FUH Web',
            style="width: 100%; background-color: #cacfd2; position: absolute; bottom: 0; text-align: center; padding: .25rem 1rem;");

@app.get('/')
def _():
    return MainLayout(Div('The content'));

@app.get('/siyo')
def _():
    return MainLayout(Div('SIYO'));
@app.get('/notifications')
def _():
    return MainLayout(Div('Notifications'));
@app.get('/billing')
def _():
    return MainLayout(Div('Billing'));
@app.get('/admin')
def _():
    return MainLayout(Div('Admin'));

serve(host='localhost', reload=True);