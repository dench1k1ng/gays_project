from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.name

class Card(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name="cards")
    title = models.CharField(max_length=255)
    image = models.FileField(upload_to="cards/images/") 
    audio = models.FileField(upload_to="cards/audio/")

    def __str__(self):
        return self.title