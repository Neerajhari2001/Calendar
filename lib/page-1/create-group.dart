import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(CreateGroupApp());
// }

class CreateGroupApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Group App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddParticipantsScreen(),
    );
  }
}

class AddParticipantsScreen extends StatefulWidget {
  @override
  _AddParticipantsScreenState createState() => _AddParticipantsScreenState();
}

class _AddParticipantsScreenState extends State<AddParticipantsScreen> {
  List<String> addedEmails = [];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _currentUser;
  bool _isAddingParticipant = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _addParticipant() async {
    if (_isAddingParticipant) return;

    setState(() {
      _isAddingParticipant = true;
    });

    String email = _emailController.text;
    if (email.isNotEmpty) {
      setState(() {
        addedEmails.add(email);
        _emailController.clear();
      });

      try {
        final QuerySnapshot snapshot = await _firestore
            .collection('groups')
            .doc(_currentUser.uid)
            .collection('participants')
            .get();

        if (snapshot.size < 5) {
          await _firestore
              .collection('groups')
              .doc(_currentUser.uid)
              .collection('participants')
              .doc()
              .set({'email': email});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Cannot add more than 5 participants.'),
          ));
        }
      } catch (e) {
        print('Error adding participant: $e');
      }
    }

    setState(() {
      _isAddingParticipant = false;
    });
  }

  void _removeParticipant(int index) {
    setState(() {
      addedEmails.removeAt(index);
    });
  }

  Future<void> _createGroup() async {
    log("Create group");
    String groupName = _groupNameController.text.trim();

    if (groupName.isNotEmpty && addedEmails.isNotEmpty) {
      try {
        final DocumentReference groupDoc =
            await _firestore.collection('groups').add({'name': groupName});
        log(groupDoc.toString());
        for (String email in addedEmails) {
          await groupDoc.collection('participants').add({'email': email});
        }

        // Clear the input fields
        _groupNameController.clear();
        addedEmails.clear();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Group created successfully.'),
        ));
      } catch (e) {
        print('Error creating group: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Group'),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 51,
              left: 15,
              child: Text(
                'Group Name:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(101, 119, 134, 1),
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: 86,
              left: 10,
              child: Container(
                width: 310,
                height: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(215, 233, 255, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter group name',
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 158,
              left: 15,
              child: Text(
                'Participants:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(101, 119, 134, 1),
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: 185,
              left: 15,
              child: Container(
                width: 300,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Color.fromRGBO(29, 161, 242, 1),
                ),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Participant'),
                          content: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Enter email ID',
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                _addParticipant();
                                Navigator.of(context).pop();
                              },
                              child: Text('Add'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'ADD PARTICIPANTS',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 250,
              left: 15,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(215, 233, 255, 1),
                ),
                width: 300,
                height: 200,
                child: ListView.builder(
                  itemCount: addedEmails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(addedEmails[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Edit Participant'),
                                content: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter email ID',
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        addedEmails[index] =
                                            _emailController.text;
                                        _emailController.clear();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Save'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Participant'),
                              content: Text(
                                'Are you sure you want to delete this participant?',
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    _removeParticipant(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                width: 100,
                height: 36,
                child: ElevatedButton(
                  onPressed: _createGroup,
                  child: Text(
                    'CREATE',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(29, 161, 242, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}