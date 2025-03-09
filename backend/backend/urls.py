from django.contrib import admin
from django.urls import path, re_path, include
from rest_framework.routers import DefaultRouter
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from myapp.views import CategoryViewSet, CardViewSet
from django.conf import settings
from django.conf.urls.static import static

# Настройки Swagger
schema_view = get_schema_view(
    openapi.Info(
        title="API для категорий и карточек",
        default_version="v1",
        description="Документация API",
        contact=openapi.Contact(email="support@example.com"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

# Роутер API
router = DefaultRouter()
router.register(r'categories', CategoryViewSet)
router.register(r'cards', CardViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),  # Админка
    path('api/', include(router.urls)),  # API роуты

    # Swagger UI и Redoc
    re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
]

# Добавляем обработку media файлов
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
