import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ninetiassignment/model/user_model.dart';

import '../../../model/todo_model.dart';
import '../bloc/userdetails_bloc.dart';
import '../bloc/userdetails_event.dart';
import '../bloc/userdetails_state.dart';
import '../../../model/post_model.dart';

class UserDetailsScreen extends StatelessWidget {
  final User1 user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDetailsBloc()..add(FetchUserDetails(user.id)),
      child: Scaffold(
        appBar: AppBar(title: Text(user.name)),
        body: BlocBuilder<UserDetailsBloc, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserDetailsLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(user),
                    const SizedBox(height: 20),
                    const Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...state.posts.map(_buildPostCard).toList(),
                    const SizedBox(height: 20),
                    const Text(
                      'Todos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...state.todos.map(_buildTodoTile).toList(),
                  ],
                ),
              );
            } else if (state is UserDetailsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(User1 user) {
    return Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(user.image), radius: 40),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(title: Text(post.title), subtitle: Text(post.body)),
    );
  }

  Widget _buildTodoTile(Todo todo) {
    return ListTile(
      leading: Icon(
        todo.completed ? Icons.check_circle : Icons.circle_outlined,
        color: todo.completed ? Colors.green : Colors.grey,
      ),
      title: Text(todo.todo),
    );
  }
}
