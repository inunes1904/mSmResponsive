import requests as r


def getAllitems(restaurant):
    apiUrl = str(restaurant.api)+'items/all'
    print(apiUrl)
    all_items = r.get(apiUrl).json()
    return all_items


