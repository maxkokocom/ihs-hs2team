from django.contrib import admin
from friends_workout.models import StepSessions


class StepSessionsAdmin(admin.ModelAdmin):
    pass

admin.register(StepSessions, StepSessionsAdmin)
# admin.site.register(StepSessions, StepSessionsAdmin)
