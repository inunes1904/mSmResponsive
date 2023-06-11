from django.contrib import admin
from .models import Api, Restaurante, Item, Pedido, ItemPedido

# Register your models here.
admin.site.register(Api)
admin.site.register(Restaurante)
admin.site.register(Item)
admin.site.register(Pedido)
admin.site.register(ItemPedido)