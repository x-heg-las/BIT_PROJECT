from flask import Flask, render_template, request, render_template_string

app = Flask(__name__)
app.SECRET_KEY = '12345678901234567890123456789012'

@app.route("/", methods = ['GET'])
def home():
    return render_template('form.html', mail=request.form.get('email', ''))

@app.route("/recap", methods= ["POST"])
def info():
    return render_template_string("Issue has been reported from: " + \
request.form.get('email') )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)
