from rest_framework import serializers
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from .models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ("id", "username", "email", "first_name", "last_name", "bio", "profile_picture", "followers")

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ("username", "email", "password", "first_name", "last_name", "bio")

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        Token.objects.create(user=user)
        return user

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        user = authenticate(username=data.get("username"), password=data.get("password"))
        if not user:
            raise serializers.ValidationError("Invalid credentials.")
        data["user"] = user
        return data
EOF

cd social_media_api
python manage.py startapp notifications
cat >> posts/models.py << 'EOF'

from django.conf import settings
from django.db import models

class Post(models.Model):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

class Like(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name="likes")
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("post", "user")

    def __str__(self):
        return f"{self.user.username} liked {self.post.id}"
EOF

python manage.py startapp posts
cat >> posts/models.py << 'EOF'
from django.conf import settings
from django.db import models

class Post(models.Model):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

class Like(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name="likes")
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("post", "user")

    def __str__(self):
        return f"{self.user.username} liked {self.post.id}"
EOF

python manage.py startapp posts
nano social_media_api/settings.py
cat >> posts/models.py << 'EOF'
from django.conf import settings
from django.db import models

class Post(models.Model):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

class Like(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name="likes")
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("post", "user")

    def __str__(self):
        return f"{self.user.username} liked {self.post.id}"
EOF

python manage.py makemigrations posts
python manage.py migrate
python -m pip install Pillow
python manage.py makemigrations
python manage.py migrate
python manage.py startapp notifications
python manage.py startapp user_notifications
nano social_media_api/settings.py
cat > user_notifications/models.py << 'EOF'
from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey
from django.conf import settings

class Notification(models.Model):
    recipient = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='notifications')
    actor = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='actor_notifications')
    verb = models.CharField(max_length=255)
    target_ct = models.ForeignKey(ContentType, null=True, blank=True, on_delete=models.CASCADE)
    target_id = models.PositiveIntegerField(null=True, blank=True)
    target = GenericForeignKey('target_ct', 'target_id')
    unread = models.BooleanField(default=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.actor} {self.verb} -> {self.recipient}"
EOF

python manage.py makemigrations user_notifications
python manage.py migrate
cat > user_notifications/serializers.py << 'EOF'
from rest_framework import serializers
from .models import Notification

class NotificationSerializer(serializers.ModelSerializer):
    actor_username = serializers.CharField(source='actor.username', read_only=True)
    target_id = serializers.IntegerField(read_only=True)

    class Meta:
        model = Notification
        fields = ('id', 'actor_username', 'verb', 'target_id', 'unread', 'timestamp')
EOF

cat > user_notifications/views.py << 'EOF'
from rest_framework import generics, permissions
from .models import Notification
from .serializers import NotificationSerializer

class NotificationListAPIView(generics.ListAPIView):
    serializer_class = NotificationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Notification.objects.filter(recipient=self.request.user).order_by('-timestamp')
EOF

cat > user_notifications/urls.py << 'EOF'
from django.urls import path
from .views import NotificationListAPIView

urlpatterns = [
    path('', NotificationListAPIView.as_view(), name='notifications-list'),
]
EOF

path('api/notifications/', include('user_notifications.urls')),
nano social_media_api/urls.py
nano social_media_api/urls.py
cat > posts/views.py << 'EOF'
from rest_framework import status, permissions
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Post, Like
from user_notifications.models import Notification
from django.contrib.contenttypes.models import ContentType

class LikePostAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        try:
            post = Post.objects.get(pk=pk)
        except Post.DoesNotExist:
            return Response({"detail": "Post not found"}, status=status.HTTP_404_NOT_FOUND)

        like, created = Like.objects.get_or_create(post=post, user=request.user)
        if not created:
            return Response({"detail": "Already liked"}, status=status.HTTP_400_BAD_REQUEST)

        # Create notification for the post author if not liking own post
        if post.author != request.user:
            Notification.objects.create(
                recipient=post.author,
                actor=request.user,
                verb="liked your post",
                target=post
            )

        return Response({"detail": "Post liked"}, status=status.HTTP_200_OK)


class UnlikePostAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        try:
            post = Post.objects.get(pk=pk)
        except Post.DoesNotExist:
            return Response({"detail": "Post not found"}, status=status.HTTP_404_NOT_FOUND)

        like = Like.objects.filter(post=post, user=request.user)
        if like.exists():
            like.delete()
            return Response({"detail": "Post unliked"}, status=status.HTTP_200_OK)
        return Response({"detail": "You have not liked this post"}, status=status.HTTP_400_BAD_REQUEST)
EOF

cat > posts/urls.py << 'EOF'
from django.urls import path
from .views import LikePostAPIView, UnlikePostAPIView

urlpatterns = [
    path('<int:pk>/like/', LikePostAPIView.as_view(), name='like-post'),
    path('<int:pk>/unlike/', UnlikePostAPIView.as_view(), name='unlike-post'),
]
EOF

python manage.py makemigrations posts
python manage.py migrate
python manage.py makemigrations posts
POST http://127.0.0.1:8000/api/posts/1/like/
Authorization: Token <your_token>
git add .
git commit -m"social_media_api"
git push origin master
git remote -v
git remote add origin https://github.com/Bem132833/Alx_DjangoLearnLab.git
git push -u origin master
git push -u origin master:main
git fetch origin
git merge origin/main
git merge origin/main --allow-unrelated-histories
git stash push --include-untracked
git merge origin/main --allow-unrelated-histories
git stash pop
C:\Users\YourName\Desktop\backup_manage.py
https://github.com/Bem132833/smart-parking-api.git
cd ~/smart-parking
source venv/Scripts/activate
pwd
ls -la
pip install djangorestframework djangorestframework-simplejwt django-filter drf-yasg
pip freeze > requirements.txt
nano smart_parking/settings.py
nano parking_app/serializers.py
nano parking_app/views.py
nano parking_app/urls.py
nano smart_parking/urls.py
python manage.py makemigrations
nano smart_parking/settings.py
python manage.py makemigrations
nano smart_parking/settings.py
python manage.py makemigrations
 nano smart_parking/settings.py
 python manage.py makemigrations
nano smart_parking/settings.py
python manage.py makemigrations
nano smart_parking/settings.py
python manage.py makemigrations
 python manage.py migrate
python manage.py createsuperuser
mkdir -p scripts
nano scripts/seed_spots.py
python manage.py runserver
python manage.py runserver
[200~python manage.py createsuperuser
python manage.py createsuperuser
nano smart_parking/urls.py
python manage.py runserver
git add .
git commit -m "Added JWT auth, Swagger docs, and updated URLs"
git push origin main
cd smart-parking
ls
venv\Scripts\activate
source venv\Scripts\activate
source venv/Scripts/activate
nano parking_app/views.py
nano parking_app/urls.py
python manage.py runserver
nano parking_app/urls.py
nano smart_parking/urls.py
python manage.py runserver
nano parking_app/models.py
nano parking_app/views.py
nano parking_app/tests.py
python manage.py test
nano parking_app/views.py
python manage.py runserver
nano parking_app/views.py
git add .
git commit -m"finish api"
git push origin main 
nano smart_parking/settings.py
[200~python manage.py runserver
python manage.py runserver
 nano smart_parking/settings.py
 python manage.py runserver
 nano smart_parking/settings.py
python manage.py runserver
python manage.py runserver
nano smart_parking/urls.py
nano parking_app/urls.py
nano smart_parking/urls.py
 python manage.py runserver
nano smart_parking/settings.py
export DJANGO_DEBUG=True
export DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost,smart-parking-api-oxuw.onrender.com
python manage.py runserver
nano parking_app/serializers.py
python manage.py runserver
nano parking_app/serializers.py
python manage.py runserver
nano parking_app/serializers.py
python manage.py runserver
python manage.py runserver
git add .
git commit -m"set django=False and allow host"
git push origin main 
nano smart_parking/settings.py
git add smart_parking/settings.py
git commit -m "Fix DEBUG and ALLOWED_HOSTS for Render"
git push origin main
cd ~/smart-parking-api
cd /c/Users/bemig/smart-parking-api
git fetch origin
git branch -a
git branch -m master master_old
git checkout -b main origin/main
git stash push -u
cd ~/smart-parking
source venv/Scripts/activate
git fetch origin
git status --porcelain
git checkout main
git log --oneline -n 20
git add .
git commit -m "wip: save local changes before sync"
ls -la
ls -la parking_app
ls -la smart_parking
sed -n '1,200p' parking_app/models.py
sed -n '1,200p' parking_app/serializers.py
sed -n '1,300p' parking_app/views.py
sed -n '1,200p' parking_app/urls.py
sed -n '1,200p' smart_parking/settings.py
sed -n '1,200p' smart_parking/urls.py
cat > parking_app/serializers.py <<'PY'
from django.contrib.auth import get_user_model
from rest_framework import serializers
from .models import ParkingSpot, Reservation, Payment

User = get_user_model()

# -------- USER REGISTRATION ----------
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password')

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''),
            password=validated_data['password']
        )
        return user

# -------- PARKING SPOT ----------
class ParkingSpotSerializer(serializers.ModelSerializer):
    class Meta:
        model = ParkingSpot
        fields = ['id', 'location', 'status', 'price_per_hour']

# -------- RESERVATION ----------
class ReservationSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField(read_only=True)
    spot_detail = ParkingSpotSerializer(source='spot', read_only=True)

    class Meta:
        model = Reservation

fields = [
            'id', 'user', 'spot', 'spot_detail',
            'start_time', 'end_time', 'total_price', 'status', 'created_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'status', 'total_price']

    def validate(self, attrs):
        start = attrs.get('start_time')
        end = attrs.get('end_time')
        if start and end and start >= end:
            raise serializers.ValidationError('Start time must be before end time.')
        return attrs

# -------- PAYMENT ----------
class PaymentSerializer(serializers.ModelSerializer):
    reservation_detail = ReservationSerializer(source='reservation', read_only=True)

    class Meta:
        model = Payment
        fields = ['id', 'reservation', 'reservation_detail', 'amount', 'payment_method', 'status', 'created_at']
        read_only_fields = ['id', 'created_at']
PY

nano smart_parking/settings.py
nano parking_app/views.py
nano smart_parking/urls.py
python manage.py check
nano parking_app/serializers.py
cat > parking_app/serializers.py <<'PY'
from django.contrib.auth import get_user_model
from rest_framework import serializers
from .models import ParkingSpot, Reservation, Payment

User = get_user_model()

# -------- USER REGISTRATION ----------
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password')

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''),
            password=validated_data['password']
        )
        return user


# -------- PARKING SPOT ----------
class ParkingSpotSerializer(serializers.ModelSerializer):
    class Meta:
        model = ParkingSpot
        fields = ['id', 'location', 'status', 'price_per_hour']


# -------- RESERVATION ----------
class ReservationSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField(read_only=True)
    spot_detail = ParkingSpotSerializer(source='spot', read_only=True)

    class Meta:
        model = Reservation
        fields = [
            'id', 'user', 'spot', 'spot_detail',
            'start_time', 'end_time', 'total_price', 'status', 'created_at'
        ]
        read_only_fields = ['id', 'user', 'created_at', 'status', 'total_price']

    def validate(self, attrs):
        start = attrs.get('start_time')
        end = attrs.get('end_time')
        if start and end and start >= end:
            raise serializers.ValidationError('Start time must be before end time.')
        return attrs


# -------- PAYMENT ----------
class PaymentSerializer(serializers.ModelSerializer):
    reservation_detail = ReservationSerializer(source='reservation', read_only=True)

    class Meta:
        model = Payment
        fields = ['id', 'reservation', 'reservation_detail', 'amount', 'payment_method', 'status', 'created_at']
        read_only_fields = ['id', 'created_at']
PY

python manage.py check
git branch
git fetch origin
git status 
git remote -v
git remote set-url origin https://github.com/SWA-TeamQ/IP1-Frontend.git
git push correct-origin main
git branch
git remote -v
git pull old_work
