import requests as r


def getAllitems():
    
    test = r.get('http://localhost:8080/api/v1/items/all').json()

    print(test)

    