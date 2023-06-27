from restaurant import views
from django.contrib import admin
from django.urls import  path
from . import views

urlpatterns = [
    path('', views.home_delivery_crew, name="home_delivery_crew"),
    path('make_delivery/', views.make_delivery, name="make_delivery") 
]