import requests as r
from django.core.mail import EmailMessage
from invoice.utils import stringToBase64


def getAllitems(restaurant):
    apiUrl = str(restaurant.api)+'items/all'
    print(apiUrl)
    all_items = r.get(apiUrl).json()
    return all_items


def send_info(user, pedido):
    encoded_user_id=stringToBase64(str(user.id))
    encoded_ped_transacao=stringToBase64(str(pedido.numero_transacao))
    email = EmailMessage(
                f'Pedido nº{pedido.numero_transacao}', 
                f'Olá {pedido.cliente.nome},\nObrigado pela confiança.\n\n'+
                'Clique no link em baixo para consultar a sua fatura.\n\n'+
                f'http://127.0.0.1:8000/invoice/{encoded_user_id}/'+
                f'{encoded_ped_transacao}',
                'mallsafemeals@gmail.com', 
                [user.email]
                )
    email.send()



