from django.db import models
from user.models import Profile

# Create your models here.


class Api(models.Model):
    url = models.CharField(max_length=500)

    def __str__(self):
        return f"{self.url}"
    

class Restaurante(models.Model):
    nome = models.CharField(max_length=50)
    tipo = models.CharField(max_length=50)
    descricao = models.TextField(null=True, blank=True)
    imagem = models.ImageField(null=True, blank=True, upload_to="restaurantes/", default="restaurantes/rest-default.jpg")
    destaque = models.CharField(max_length=50)
    api = models.OneToOneField(Api, on_delete=models.CASCADE, null=True, blank=True)
    rating = models.DecimalField(max_digits=2, decimal_places=1, null=True, blank=True)
    tempo_medio = models.IntegerField(default=7)
    
    def __str__(self):
        return f"{self.nome}"
    
class Item(models.Model):
    nome = models.CharField(max_length=50)
    imagem = models.ImageField(null=True, blank=True, default="default.jpg")
    preco = models.DecimalField(max_digits=10, decimal_places=2)
    tempo = models.IntegerField()
    item_tipo = models.CharField(max_length=50)
    restaurante = models.ForeignKey(Restaurante, null=True, blank=True, on_delete=models.SET_NULL)
    
    def __str__(self):
        return f"{self.nome}"
    
class Pedido(models.Model):
    cliente = models.ForeignKey(Profile, null=True, blank=True, on_delete=models.SET_NULL)
    data_inicio = models.DateTimeField(auto_now_add=True)
    data_conclusao = models.DateTimeField(null=True, blank=True)
    mesa = models.IntegerField()
    finalizado = models.BooleanField(default=False)
    pedido_pago = models.BooleanField(default=False)
    pedido_entregue = models.BooleanField(default=False)
    numero_transacao = models.CharField(max_length=100, null=True, default=0000000)
    restaurante = models.ManyToManyField(Restaurante, blank=True)

    def __str__(self):
        return f"{self.id}"
    
    @property
    def get_numero_items(self):
        numero_items = self.itempedido_set.all()
        total = sum([item.quantidade for item in numero_items])
        return total

    @property
    def get_total(self):
        numero_items = self.itempedido_set.all()
        total = sum([item.quantidade * item.item.preco for item in numero_items])
        return total
    
    @property
    def end_pedido(self):
        if not self.finalizado and self.pedido_pago and self.pedido_entregue:
            self.finalizado = True
            
        
        
    
class ItemPedido(models.Model):
    item = models.ForeignKey(Item, null=True, blank=True, on_delete=models.SET_NULL)
    pedido = models.ForeignKey(Pedido, null=True, blank=True, on_delete=models.SET_NULL)
    quantidade = models.IntegerField(default=0)

    def __str__(self):
        return f"{self.id}"
    
    @property
    def get_sub_total(self):
        total = self.item.preco * self.quantidade
        return total