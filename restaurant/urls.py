from restaurant import views
from django.contrib import admin
from django.urls import  path

urlpatterns = [
    
    path('<int:nmesa>/', views.home, name='home'),
    path('restaurant/<int:rest_id>', views.restaurant, name='restaurant'),
    path('cart/', views.cart, name='cart')
]
