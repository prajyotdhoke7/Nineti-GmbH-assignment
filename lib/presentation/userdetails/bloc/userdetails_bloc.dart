import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../controller/api_service.dart';
import 'userdetails_event.dart';
import 'userdetails_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final ApiService _apiService = ApiService();

  UserDetailsBloc() : super(UserDetailsInitial()) {
    on<FetchUserDetails>((event, emit) async {
      emit(UserDetailsLoading());
      try {
        final posts = await _apiService.fetchPosts(event.userId);
        final todos = await _apiService.fetchTodos(event.userId);
        emit(UserDetailsLoaded(posts: posts, todos: todos));
      } catch (e) {
        emit(UserDetailsError(e.toString()));
      }
    });
  }
}
