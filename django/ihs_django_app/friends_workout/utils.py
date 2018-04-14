import json

from allauth.socialaccount.models import SocialAccount
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User


def get_profile_data(id):
    user = User.objects.filter(id=id)
    print(user)
    print(user.first())
    user = user.first()
    social = SocialAccount.objects.filter(user=user.id)
    print(social)
    social = social.all()
    print(social.first().extra_data)
    dict_data = social.first().extra_data
    print(type(dict_data))

    # json_data = social.first().extra_data['friends']
    print(dict_data['name'])

def get_friends(id):
    user = User.objects.filter(id=id)
    print(user.first())
    user = user.first()
    social = SocialAccount.objects.filter(user=user.id)
    print(social)
    social = social.all()
    print(social.first().extra_data)
    dict_data = social.first().extra_data
    print(type(dict_data))

    # json_data = social.first().extra_data['friends']
    print(dict_data['friends']['data'])