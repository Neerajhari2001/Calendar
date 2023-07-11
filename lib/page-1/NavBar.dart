import 'package:flutter/material.dart';
import 'package:myapp/authentication.dart';
import 'add-event.dart';
import 'create-group.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Patrick bateman'),
            accountEmail: Text('sigma@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/147/147142.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: NetworkImage(
              //         'https://www.freepik.com/free-icon/avatar_14021515.htm')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('HOME'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('CREATE GROUP'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateGroupApp()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('ADD EVENTS'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventPage()),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();

              WidgetsBinding.instance!.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
              );
            },
           
          ),
        ],
      ),
    );
  }
}

Future<bool> signOut() async{
  try {
  await FirebaseAuth.instance.signOut();
  
  await GoogleSignIn().signOut();
  return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }