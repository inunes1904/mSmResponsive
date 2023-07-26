from invoice import views
from django.contrib import admin
from django.urls import  path

urlpatterns = [
    path('<str:user_id>/<str:invoice_id>/', views.invoice, name='invoice'),

]
