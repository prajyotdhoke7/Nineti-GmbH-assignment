abstract class UserListEvent {}

class FetchUsers extends UserListEvent {
  final int limit;
  final int skip;
  FetchUsers({required this.limit, required this.skip});
}

class SearchUsers extends UserListEvent {
  final String query;
  SearchUsers(this.query);
}
