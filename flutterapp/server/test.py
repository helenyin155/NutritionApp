from flask import Flask, request
from bs4 import BeautifulSoup
import requests
import asyncio
from pyppeteer import launch
from pyppeteer_stealth import stealth

async def getPage(url):
    browser = await launch()
    page = await browser.newPage()

    await stealth(page)

    await page.goto(url)
    await page.waitFor(5000)

    ## Get HTML
    html = await page.content()
    await browser.close()
    return html


async def getIngredients(upc):
    url = 'https://go-upc.com/search?q=%s' % upc
    # headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}

    # html = getPage(url)
    # htmlDoc = requests.get(url, headers=headers).text

    # html_response = asyncio.get_event_loop().run_until_complete(getPage(url))

    html_response = await getPage(url)
    
    soup = BeautifulSoup(html_response, 'html.parser')

    for listItem in soup.find_all('li'):
        label = str(listItem.find('span').text)
        if label == 'Ingredients:':
            return listItem.text
    
    return 'Could not find ingredients'


if __name__ == '__main__':
    print(asyncio.run(getIngredients('0722252217950')))
    # print(asyncio.run(getIngredients('0888849011278')))
    # print(asyncio.run(getIngredients('0067002310865')))
    