from django.contrib.auth import authenticate, login


def make_authentication(req, username, pwd):
    user = authenticate(req, username=username, password=pwd)
    if user is not None:
        login(req, user)
        return True
    else:
        return False