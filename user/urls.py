from user import views
from django.contrib import admin
from django.urls import  path

urlpatterns = [
    path('login/', views.login, name='login_or_register')
    
]
