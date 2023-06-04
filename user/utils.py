from django.contrib.auth import authenticate


def make_authentication(user, pwd):
    user = authenticate(username=user, password=pwd)
    if user is not None:
        return True
    else:
        return False