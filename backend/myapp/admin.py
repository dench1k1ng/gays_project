from django.contrib import admin
from .models import Category, Card

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ("id", "name")
    search_fields = ("name",)

@admin.register(Card)
class CardAdmin(admin.ModelAdmin):
    list_display = ("id", "title", "category", "image", "audio")
    list_filter = ("category",)
    search_fields = ("title",)
