import os
from flask import Flask, render_template;
from pages import pages_bp
import dotenv;

app = Flask(__name__);
app.register_blueprint(pages_bp);

dotenv.load_dotenv();
DATA_SOURCE = os.getenv("DATA_SOURCE");
if DATA_SOURCE == "firebase":
    from fb_api import api_bp;
    app.register_blueprint(api_bp);
elif DATA_SOURCE == "sqlite":
    from sql_api import api_bp;
    app.register_blueprint(api_bp);
else:
    raise Exception("Error: need to set DATA_SOURCE variable (in .env) with either firebase or sqlite");

if __name__ == '__main__':
    app.run(port=int(os.environ.get("PORT", 8080)));