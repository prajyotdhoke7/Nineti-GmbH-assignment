import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ninetiassignment/model/user_model.dart';


import '../../../../controller/api_service.dart';
import 'userlist_event.dart';
import 'userlist_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final ApiService _apiService = ApiService();
  List<User1> users = [];
  int limit = 100;
  int skip = 0;
  bool isFetchingMore = false;

  UserListBloc() : super(UserListInitial()) {
    on<FetchUsers>(_fetchUser);
    on<SearchUsers>(_searchUser);
  }

  FutureOr<void> _fetchUser(
    FetchUsers event,
    Emitter<UserListState> emit,
  ) async {
    isFetchingMore = true;
    emit(UserListLoading());
    try {
      final fetchedUsers = await _apiService.fetchUsers(
        limit: event.limit,
        skip: event.skip,
      );
      if (event.skip == 0) {
        users = fetchedUsers;
      } else {
        users.addAll(fetchedUsers);
      }
      emit(UserListLoaded(users));
    } catch (e) {
      emit(UserListError(e.toString()));
    } finally {
      isFetchingMore = false;
    }
  }

  FutureOr<void> _searchUser(
    SearchUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    try {
      final searchedUsers = await _apiService.searchUsers(event.query);
      emit(UserListLoaded(searchedUsers));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      skip = 0;
      add(FetchUsers(limit: limit, skip: skip));
    } else {
      add(SearchUsers(query));
    }
  }

  Future<void> _createPost(String title, String body) async {
    final url = Uri.parse('https://dummyjson.com/posts/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'body': body, 'userId': 1}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Post created: ${response.body}');
    } else {
      debugPrint('Failed to create post: ${response.statusCode}');
    }
  }

  Future<void> showCreatePostDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create New Post'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: 'Body'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final title = titleController.text.trim();
                  final body = bodyController.text.trim();
                  if (title.isNotEmpty && body.isNotEmpty) {
                    await _createPost(title, body);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post created successfully'),
                      ),
                    );
                  }
                },
                child: const Text('Post'),
              ),
            ],
          ),
    );
  }
}
