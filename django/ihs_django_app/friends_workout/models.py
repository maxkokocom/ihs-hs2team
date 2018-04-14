from django.db import models
from allauth.socialaccount.providers.facebook.views import FacebookOAuth2Adapter
from rest_auth.registration.views import SocialLoginView
from allauth.socialaccount.providers.facebook.views import FacebookOAuth2Adapter
from rest_auth.registration.views import SocialConnectView

class Exercise(models.Model):
    startData = models.DateTimeField(null=False)
    endData = models.DateTimeField(null=False)


class Steps(models.Model):
    amount = models.IntegerField(null=False, blank=False)


class Floors(models.Model):
    amount = models.IntegerField(null=False, blank=False)


class Pulse(models.Model):
    amount = models.IntegerField(null=False, blank=False)


class Distance(models.Model):
    amount = models.IntegerField(null=False, blank=False)


class Calories(models.Model):
    amount = models.IntegerField(null=False, blank=False)


class StepSessions(Exercise):
    steps = models.ForeignKey('Steps', null=True, blank=True, on_delete=True)
    floors = models.ForeignKey('Floors', null=True, blank=True, on_delete=True)
    pulse = models.ForeignKey('Pulse', null=True, blank=True, on_delete=True)
    distance = models.ForeignKey('Distance', null=True, blank=True, on_delete=True)
    calories = models.ForeignKey('Calories', null=True, blank=True, on_delete=True)


class FacebookLogin(SocialLoginView):
    adapter_class = FacebookOAuth2Adapter



class FacebookConnect(SocialConnectView):
    adapter_class = FacebookOAuth2Adapter

