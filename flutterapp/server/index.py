from flask import Flask, request, jsonify
from bs4 import BeautifulSoup
import requests
import asyncio
from pyppeteer import launch
from pyppeteer_stealth import stealth
from multiprocessing import Pool

app = Flask(__name__)

async def getPage(url):
    browser = await launch({
        'Headless' : False,
        'args': [
        '--disable-infobars',
        '--window-size=1920,1080',
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-blink-features=AutomationControlled',
    ]
    })
    page = await browser.newPage()

    await stealth(page)

    await page.goto(url)

    html = await page.content()
    await browser.close()
    return html


async def getIngredients(upc):
    url = 'https://go-upc.com/search?q=%s' % upc
    html_response = await getPage(url)

    soup = BeautifulSoup(html_response, 'html.parser')

    for listItem in soup.find_all('li'):
        label = str(listItem.find('span').text)
        if label == 'Ingredients:':
            return listItem.text
    
    return 'Could not find ingredients'

def getIngredientsWrapper(upc):
    return asyncio.run(getIngredients(upc))

@app.route('/get-ingredients/<upc>')
def returnIngredients(upc):
    with Pool(1) as p:
        result = p.apply(getIngredientsWrapper, (upc,))
    
    print({'ingredients': result})
    return jsonify({'ingredients': result})

# @app.route('/get-ingredients/<upc>')
# def returnIngredients(upc):
#      with Pool(1) as p:
#         result = p.apply(getIngredientsWrapper, (upc,))
#     return jsonify({'ingredients': result})
#     # ingredients = asyncio.run(getIngredients('0722252217950'))
#     # print(ingredients)
#     # return 'Worked'
#     # return asyncio.run(getIngredients(upc)).split(', ')

@app.route('/test')
def getTest():
    return "working"

@app.route('/test-post', methods=['POST'])
def postTest():
    data = request.json
    return data



if __name__ == "__main__":
    app.run(debug=True)