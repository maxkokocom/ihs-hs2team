from django.conf.urls import url, include
from django.contrib.auth.models import User
from friends_workout.models import StepSessions
from rest_framework import routers, serializers, viewsets


# Serializers define the API representation.
class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ('url', 'username', 'email', 'is_staff')


# ViewSets define the view behavior.
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer


# Serializers define the API representation.
class SessionsSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = StepSessions
        fields = ('startData', 'endData', 'steps', 'floors', 'pulse', 'distance', 'calories')


# ViewSets define the view behavior.
class SessionsViewSet(viewsets.ModelViewSet):
    queryset = StepSessions.objects.all()
    serializer_class = SessionsSerializer

# Routers provide an easy way of automatically determining the URL conf.
router = routers.DefaultRouter()
router.register(r'users', UserViewSet)

# Routers for sessions
router = routers.DefaultRouter()
router.register(r'sessions', SessionsViewSet)


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    url(r'^', include(router.urls)),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]