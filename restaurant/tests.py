from django.test import TestCase
from restaurant.models import Item, Restaurante, ItemPedido, Pedido

# Create your tests here.
class ItemTestCase(TestCase):
    def setUp(self):
        rest = Restaurante.objects.create(nome="RestTest", tipo='FastFood', 
                                          descricao='Descricao Test', rating=5,
                                   )
        Item.objects.create(nome='teste', preco=5.55, 
                            tempo=5, item_tipo='comida', restaurante=rest)  

    def test_nome(self):
        teste = Item.objects.get(nome="teste")
        self.assertEqual(teste.nome, "teste")
        
    def test_preco(self):
        teste = Item.objects.get(nome="teste") 
        preco = float(teste.preco)
        self.assertEqual( preco, float(5.55))

    def test_nome_not(self):
        teste = Item.objects.get(nome="teste")
        self.assertNotEqual(teste.nome, "noteste")
        
    def test_preco_not(self):
        teste = Item.objects.get(nome="teste") 
        preco = float(teste.preco)
        self.assertNotEqual( preco, 6.55)

    def test_tempo(self):
        teste = Item.objects.get(nome="teste") 
        self.assertNotEqual( teste.tempo, 5.5)

    def test_tempo_true(self):
        teste = Item.objects.get(nome="teste") 
        self.assertEqual( teste.tempo, 5)

    def test_tempo_string(self):
        teste = Item.objects.get(nome="teste") 
        self.assertNotEqual( teste.tempo, '5')

    def test_restaurante(self):
        teste = Item.objects.get(nome="teste") 
        self.assertNotEqual( teste.restaurante, "Not Equal")

    

class PedidoTestCase(TestCase):
    def setUp(self):
        rest = Restaurante.objects.create(nome="RestTest", tipo='FastFood', 
                                          descricao='Descricao Test', rating=5,
                                   )
        item1 = Item.objects.create(nome='teste', preco=5.00, 
                            tempo=5, item_tipo='comida', restaurante=rest)  
        item2 = Item.objects.create(nome='teste', preco=10.00, 
                            tempo=5, item_tipo='comida', restaurante=rest)
        
        pedido = Pedido.objects.create(mesa=5)
        item_pedido = ItemPedido.objects.create(item=item1, pedido=pedido, quantidade=2)
        item_pedido2 = ItemPedido.objects.create(item=item2, pedido=pedido, quantidade=2)

    def test_get_total(self):
        pedido = Pedido.objects.get(mesa=5)
        self.assertEqual(pedido.get_total, 30.00)
        
    def test_get_total_false(self):
        pedido = Pedido.objects.get(mesa=5)
        self.assertNotEqual(pedido.get_total, 38.00)

    def test_get_numero_item(self):
        pedido = Pedido.objects.get(mesa=5)
        self.assertEqual(pedido.get_numero_items, 4)

    def test_get_numero_item_false(self):
        pedido = Pedido.objects.get(mesa=5)
        self.assertNotEqual(pedido.get_numero_items, "4")

    def test_end_pedido(self):
        pedido = Pedido.objects.get(mesa=5)
        pedido.pedido_pago = True
        pedido.end_pedido
        self.assertEqual(pedido.finalizado, False)

    def test_end_pedido_true(self):
        pedido = Pedido.objects.get(mesa=5)
        pedido.pedido_pago = True
        pedido.pedido_entregue = True
        pedido.end_pedido
        self.assertNotEqual(pedido.finalizado, False)


class ItemPedidoTestCase(TestCase):
    
    def setUp(self):
        rest2 = Restaurante.objects.create(nome="RestTest", tipo='FastFood', 
                                          descricao='Descricao Test', rating=5,
                                   )
        item3 = Item.objects.create(nome='testtt', preco=5.00, 
                            tempo=5, item_tipo='comida', restaurante=rest2)  
        item4 = Item.objects.create(nome='teteste', preco=10.00, 
                            tempo=5, item_tipo='comida', restaurante=rest2)
        
        pedido2 = Pedido.objects.create(mesa=5)
        item_pedido3 = ItemPedido.objects.create(item=item3, pedido=pedido2, quantidade=2)
        item_pedido4 = ItemPedido.objects.create(item=item4, pedido=pedido2, quantidade=2)

    def test_get_sub_total(self):
        item_test = Item.objects.get(nome='testtt')
        pedido_test = Pedido.objects.get(mesa=5)
        item_pedido_test = ItemPedido.objects.get(item=item_test, pedido=pedido_test)
        self.assertEqual( item_pedido_test.get_sub_total, 10.00)

    def test_get_sub_total_false(self):
        item_test = Item.objects.get(nome='teteste')
        pedido_test = Pedido.objects.get(mesa=5)
        item_pedido_test = ItemPedido.objects.get(item=item_test, pedido=pedido_test)
        self.assertNotEqual( item_pedido_test.get_sub_total, 10.00)