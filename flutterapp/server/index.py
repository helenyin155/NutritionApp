from flask import Flask, request
from bs4 import BeautifulSoup
import requests

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

# Example response for upc #0888849010455
# [
#   "Ingredients: Protein Blend (milk Protein Isolate",
#   "Whey Protein Isolate)",
#   "High Oleic Sunflower Oil",
#   "Calcium Caseinate",
#   "Corn Starch",
#   "Natural Flavors",
#   "Psyllium Husk",
#   "Salt. Contains Less Than 2% Of The Following: Onion Powder",
#   "Paprika",
#   "Spice",
#   "Chia Seed",
#   "Vinegar Powder",
#   "Lime Juice Powder",
#   "Sugar",
#   "Yeast",
#   "Citric Acid",
#   "Turmeric Oleoresin (color)",
#   "Paprika Extract (color) Sunflower Lecithin",
#   "Calcium Carbonate",
#   "Yeast Extract",
#   "Stevia Sweetener.contains: Milk Processed In A Facility That Also Processes Soy And Wheat."
# ]

@app.route('/get-ingredients/<upc>')
def returnIngredients(upc):
    print(getIngredients(upc).split(', '))
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