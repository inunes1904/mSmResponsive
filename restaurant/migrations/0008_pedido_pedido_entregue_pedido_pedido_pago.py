# Generated by Django 4.2.1 on 2023-06-19 18:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('restaurant', '0007_alter_pedido_restaurante'),
    ]

    operations = [
        migrations.AddField(
            model_name='pedido',
            name='pedido_entregue',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='pedido',
            name='pedido_pago',
            field=models.BooleanField(default=False),
        ),
    ]