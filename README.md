Project Overview
User List:Paginated list of users with infinite scroll and real-time search
Search Bar:Filter users dynamically as you type
User Details::View user's detailed profile, posts, and todos
Theme Toggle:Switch between light and dark themes with a button in the app bar
Create Post UI:Simple UI to simulate post creation.


Architecture Explanation
lib/
 controller/             # Business logic and BLoC classes
    userlist_bloc.dart
 model/                  # Data models (User, Post, Todo)
   user_model.dart
 presentation/           # UI layer
   userlist screen/      # List view, bloc, event, state
   userdetails/          # User detail view, bloc, event, state
   main.dart             # App entry point and theme logic


All Output and Screenshout is in Output folder. 

