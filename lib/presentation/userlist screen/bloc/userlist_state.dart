

import 'package:ninetiassignment/model/user_model.dart';


abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<User1> users;
  UserListLoaded(this.users);
}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);
}

class UserListLoadingMore extends UserListState {
  final List<User1> users;
  UserListLoadingMore(this.users);
}
