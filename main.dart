

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HW4 App',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/second': (context) => UserInfoScreen(),
        '/third': (context) => SQLiteScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('firstLaunch') ?? true;

    if (isFirstLaunch!) {
      // Show tutorial or any initial setup
      // ...

      // Mark the app as launched
      prefs.setBool('firstLaunch', false);
    } else {
      // Navigate to the second screen
      navigateTo('/second');
    }
  }

  void navigateTo(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to HW4 App!'),
            ElevatedButton(
              onPressed: () {
                navigateTo('/second');
              },
              child: Text('Go to Second Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  List<String> users = [];

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://api.example.com/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> userList =
          data.map((user) => user['name'].toString()).toList();

      setState(() {
        users = userList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                fetchUsers();
              },
              child: Text('Get More Users'),
            ),
            ElevatedButton(
              onPressed: () {
                // Store selected data in SQLite (Implementation needed)
                // ...

                // Navigate to the third screen
                Navigator.pushNamed(context, '/third');
              },
              child: Text('Store Data in SQLite'),
            ),
          ],
        ),
      ),
    );
  }
}

class SQLiteScreen extends StatelessWidget {
  // Read data from SQLite and display (Implementation needed)
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display user information from SQLite
            // ...

            ElevatedButton(
              onPressed: () {
                // Navigate back to the user info screen
                Navigator.pop(context);
              },
              child: Text('Go Back to User Info Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
