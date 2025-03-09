from rest_framework import viewsets
from rest_framework.parsers import MultiPartParser, FormParser
from .models import Category, Card
from .serializers import CategorySerializer, CardSerializer

class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class CardViewSet(viewsets.ModelViewSet):
    queryset = Card.objects.all()
    serializer_class = CardSerializer
    parser_classes = (MultiPartParser, FormParser)
