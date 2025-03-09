from django.urls import path, re_path, include
from rest_framework.routers import DefaultRouter
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from .views import CategoryViewSet, CardViewSet

schema_view = get_schema_view(
    openapi.Info(
        title="API для категорий и карточек",
        default_version="v1",
        description="Документация API с поддержкой загрузки файлов",
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

router = DefaultRouter()
router.register(r'categories', CategoryViewSet)
router.register(r'cards', CardViewSet)

urlpatterns = [
    path('api/', include(router.urls)),

    # Swagger UI
    re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
]
