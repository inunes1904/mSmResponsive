from restaurant import views
from django.contrib import admin
from django.urls import  path

urlpatterns = [
    path('<int:nmesa>/', views.home, name='home'),
    path('restaurant/<int:rest_id>', views.restaurant, name='restaurant'),
    path('cart/', views.cart, name='cart'),
    path('update_item/', views.update_item, name="update_item"),
    path('checkout/', views.checkout, name="checkout"),
    path('process_order/', views.process_order, name="process_order"),
    path('client-delivery/', views.delivery, name="delivery"),
   
]
