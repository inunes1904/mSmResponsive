import requests as r


def getAllitems():
    apiUrl = 'http://localhost:8080/api/v1/items/all'
    all_items = r.get(apiUrl).json()

    return all_items



    