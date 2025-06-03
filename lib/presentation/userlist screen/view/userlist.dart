import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ninetiassignment/model/user_model.dart';
import 'package:ninetiassignment/presentation/userdetails/view/userdetails.dart';

import '../bloc/userlist_bloc.dart';
import '../bloc/userlist_event.dart';
import '../bloc/userlist_state.dart';

class UserListScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const UserListScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    final bloc = context.read<UserListBloc>();
    bloc.add(FetchUsers(limit: bloc.limit, skip: bloc.skip));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !bloc.isFetchingMore &&
          _searchController.text.isEmpty) {
        bloc.skip += bloc.limit;
        bloc.add(FetchUsers(limit: bloc.limit, skip: bloc.skip));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserListBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: bloc.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<UserListBloc, UserListState>(
                builder: (context, state) {
                  if (state is UserListLoading &&
                      _searchController.text.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserListLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final User1 user = state.users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.image),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserDetailsScreen(user: user),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is UserListError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.showCreatePostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
