import '../../../model/post_model.dart';
import '../../../model/todo_model.dart';

abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final List<Post> posts;
  final List<Todo> todos;

  UserDetailsLoaded({required this.posts, required this.todos});
}

class UserDetailsError extends UserDetailsState {
  final String message;
  UserDetailsError(this.message);
}
