from flask import Flask, request

app = Flask(__name__)

@app.route('/test')
def getTest():
    return "working"

@app.route('/test-post', methods=['POST'])
def postTest():
    data = request.json
    return data



if __name__ == "__main__":
    app.run(debug=True)