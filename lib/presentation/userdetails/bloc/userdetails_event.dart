abstract class UserDetailsEvent {}

class FetchUserDetails extends UserDetailsEvent {
  final int userId;
  FetchUserDetails(this.userId);
}
