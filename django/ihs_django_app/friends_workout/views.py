from django.shortcuts import render
from django.contrib.auth.models import User
from rest_framework import routers, viewsets

from friends_workout.serializers import UserSerializer, SessionsSerializer
from friends_workout.models import StepSessions
# Create your views here.


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer


# ViewSets define the view behavior.
class SessionsViewSet(viewsets.ModelViewSet):
    queryset = StepSessions.objects.all()
    serializer_class = SessionsSerializer


# Routers provide an easy way of automatically determining the URL conf.
router = routers.DefaultRouter()
router.register(r'users', UserViewSet)
# Routers for sessions
router.register(r'sessions', SessionsViewSet)
