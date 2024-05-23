import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';

class myDrawer extends StatefulWidget {
   myDrawer({
    super.key,
  });

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {

  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  var userData;
  String? username;
  String? image_url;

  void getUserData() async{
    userData = await FirebaseFirestore.instance.collection('users').doc(authenticatedUser.uid).get();
    username = userData.data()!['username'];
    image_url = userData.data()!['image_url'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kGreenAccent,
      child: ListView(
        children:  [
          DrawerHeader(
            child: Column(
              children: [
                Text('Ciao'),
                 //Text('Ciao $username'),
                 CircleAvatar(
                 foregroundImage: AssetImage('images/success.png'),
                 //foregroundImage: NetworkImage(image_url!),

                ),
                ListTile(
                  title: const Text('Exit'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
          const ListTile(
            title: Text('Elemento 1'),
            leading: Icon(Icons.abc),
          ),
          const ListTile(
            title: Text('Elemento 2'),
            leading: Icon(Icons.abc),
          ),
        ],
      ),
    );
  }
}