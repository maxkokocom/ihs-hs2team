from django.conf.urls import url, include
from rest_auth.registration.views import SocialAccountListView, SocialAccountDisconnectView

from friends_workout.models import FacebookLogin, FacebookConnect
from friends_workout.views import router

import friends_workout.utils
# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    url(r'^', include(router.urls)),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^rest-auth/', include('rest_auth.urls')),
    # url(r'^rest-auth/registration/', include('rest_auth.registration.urls')),
    url(r'^rest-auth/facebook/login/$', FacebookLogin.as_view(), name='fb_login'),
    url(r'^rest-auth/facebook/connect/$', FacebookConnect.as_view(), name='fb_connect'),
    url(r'^socialaccounts/$', SocialAccountListView.as_view(), name='social_account_list'),
    url(r'^socialaccounts/(?P<pk>\d+)/disconnect/$', SocialAccountDisconnectView.as_view(), name='social_account_disconnect'),
]
