from flask import Flask, request
from bs4 import BeautifulSoup
import requests
import datetime

app = Flask(__name__)


def getIngredients(upc):
    url = 'https://go-upc.com/search?q=%s' % upc
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}

    htmlDoc = requests.get(url, headers=headers).text
    
    soup = BeautifulSoup(htmlDoc, 'html.parser')

    for listItem in soup.find_all('li'):
        label = str(listItem.find('span').text)
        if label == 'Ingredients:':
            return listItem.text
    
    return 'Could not find ingredients'

# current upc data base is just a placeholder, current db limits requests

@app.route('/get-ingredients/<upc>')
def returnIngredients(upc):
    
    return getIngredients(upc).split(', ')

@app.route('/test')
def getTest():
    return "working"

@app.route('/test-post', methods=['POST'])
def postTest():
    data = request.json
    return data



if __name__ == "__main__":
    app.run(debug=True)