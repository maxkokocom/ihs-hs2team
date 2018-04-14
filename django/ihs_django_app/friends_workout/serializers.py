from django.contrib.auth.models import User
from friends_workout.models import StepSessions
from rest_framework import serializers

# Serializers define the API representation.
class SessionsSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = StepSessions
        fields = ('startData', 'endData', 'steps', 'floors', 'pulse', 'distance', 'calories')


# Serializers define the API representation.
class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ('url', 'username', 'email', 'is_staff')

