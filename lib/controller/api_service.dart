import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ninetiassignment/model/user_model.dart';
import 'package:ninetiassignment/model/post_model.dart';
import 'package:ninetiassignment/model/todo_model.dart';


class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<User1>> fetchUsers({int limit = 10, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?limit=$limit&skip=$skip'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<User1>.from(data['users'].map((x) => User1.fromJson(x)));
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<User1>> searchUsers(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/search?q=$query'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<User1>.from(data['users'].map((x) => User1.fromJson(x)));
    } else {
      throw Exception('Failed to search users');
    }
  }

  Future<List<Post>> fetchPosts(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/user/$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Post>.from(data['posts'].map((x) => Post.fromJson(x)));
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Todo>> fetchTodos(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/todos/user/$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Todo>.from(data['todos'].map((x) => Todo.fromJson(x)));
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
