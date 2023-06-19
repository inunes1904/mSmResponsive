
var updateButtons = document.getElementsByClassName('update-cart')


for (var i=0; i < updateButtons.length; i++){
    updateButtons[i].addEventListener('click', function(){
        // aqui trazemos o datasource que no nosso caso e o button data-product
        var itemId = this.dataset.item
        var action = this.dataset.action

        console.log('itemId:', itemId, 'action', action)

        // aqui verificamos o utilizador esta ou nao autenticado
        console.log('USER:', user)
        if (user == 'AnonymousUser'){
           // ANONIMO

        }else{
            updateUserOrder(itemId, action)
        }
    })
}


function updateUserOrder(itemId, action){
    console.log('User is authenticated, sending data')

    var url = '/update_item/'
    // para enviar as novas informaçoes para o carrinho vamos usar um fetch
    fetch(url, {
        method: 'POST',
        headers:{
            'Content-Type':'application/json',
            'X-CSRFToken':csrftoken,
        },
        // como nao podemos enviar apenas os dados para o backend utilizamos o json Stringify
        body:JSON.stringify({'itemId':itemId, 'action':action})
    })
    // reposta do backend
    .then((response) => {
        return response.json();
    })
    .then((data) => {
        console.log('Data:', data)
        location.reload()
    })
}