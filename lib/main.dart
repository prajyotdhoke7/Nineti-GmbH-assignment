import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ninetiassignment/presentation/userdetails/bloc/userdetails_bloc.dart';
import 'package:ninetiassignment/presentation/userlist screen/bloc/userlist_bloc.dart';
import 'package:ninetiassignment/presentation/userlist screen/view/userlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DummyJSON Users',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserListBloc>(create: (create) => UserListBloc()),
          BlocProvider<UserDetailsBloc>(create: (create) => UserDetailsBloc()),
        ],
        child: UserListScreen(toggleTheme: toggleTheme, isDark: isDark),
      ),
    );
  }
}
