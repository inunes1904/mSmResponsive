# Generated by Django 4.2.1 on 2023-06-11 10:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('restaurant', '0003_pedido_restaurante_restaurante_rating'),
    ]

    operations = [
        migrations.AddField(
            model_name='restaurante',
            name='tempo_medio',
            field=models.IntegerField(default=7),
        ),
    ]
