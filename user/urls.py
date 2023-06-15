from user import views
from django.contrib import admin
from django.urls import  path

urlpatterns = [
    path('login/', views.userlogin, name='login_or_register'),
    path('logout/', views.logout_user, name='logout_user')
]
