import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Department Calendar',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.white,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Department Calendar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
               
              },
              icon: Icon(Icons.login),
              label: Text('Sign in with Google'),
            ),
          ],
        ),
      )  
     );
  }
}