from flask import Flask, request, session, _app_ctx_stack, make_response, Response, abort
from sqlite3 import dbapi2 as sqlite3
import hashlib
import random
import time

#Configuration options
DATABASE = '/tmp/torus.db'
DEBUG = True 
SECRET_KEY = 'very very secret'
tokens = {}

app = Flask (__name__)
app.config.from_object(__name__)
#Util functions
def init_db():
	"""Initialise the database"""
	with app.app_context():
		db = get_db()
		with app.open_resource('schema.sql') as f:
			db.cursor().executescript(f.read())
		db.commit()

def get_db():
	""" Opens a new db connection"""
	top = _app_ctx_stack.top
	if not hasattr(top, 'sqlite_db'):
		top.sqlite_db = sqlite3.connect(app.config['DATABASE'])
	return top.sqlite_db


def query_db(query, args=(), one=False):
         """Queries the database and returns a list of dictionaries."""
	 cur = get_db().execute(query, args)
	 rv = cur.fetchall()
	 return (rv[0] if rv else None) if one else rv

def generate_token(username):
	""" Generate 'random' token and store it """
	#This is a bad way to get randomness!
	token = hashlib.sha1(username + str(int(time.time()))).hexdigest()
	tokens[token] = username
	print tokens
	return token

def check_auth(username, password):
	db = get_db()
	pwhash = hashlib.sha1(password).hexdigest()  
	#Bad idea, this allows for SQL injection!
	cur = db.execute("select * from authdetails where username  = \"%s\"" %  username)
	result =  cur.fetchone()
	if result is not None:
		#Timing attack: never compare hashes like this, this should be done in constant
		#time
		if pwhash == result[3]:
			return generate_token(username)
	else:
		#User doesn't exist
		return None

#Handlers
@app.route('/')
def default_handle():
	return "Everything works"

@app.route("/login", methods=['GET', 'POST'])
def login():
	username = None
	password = None
	if request.method == 'POST':
		username = request.form['username']
		password = request.form['password']
	token = check_auth(username, password)
	if token is not None:
		response = make_response()
		response.headers['X-token'] = token
		return response
	else:
		return "Fail!"
	
@app.route("/logout", methods=['GET', 'POST'])
def logout():
	#Destroy session
	if request.method == 'POST':
		token = request.form['token']
	if token in tokens:
		del tokens[token]
	return "Logged out"

@app.errorhandler(401)
def custom_401(error):
	    return Response('You need to be logged in', 401)

@app.route("/accounts", methods=['GET', 'POST'])
def account_summary():
	if request.method == 'POST':
		token = request.form['token']
	if token not in tokens:
		abort(401)
	
		

if __name__ == "__main__":
	app.run(host='0.0.0.0', port=5000)

