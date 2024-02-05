from flask import Flask, request

app = Flask(__name__)

@app.route('/test')
def getTest():
    return "working"


if __name__ == "__main__":
    app.run(debug=True)