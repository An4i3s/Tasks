import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';

// ignore: camel_case_types
class myDrawer extends StatefulWidget {
  const myDrawer({super.key});

  


  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  var userData;

   String? username = ' ';

   @override
  void initState() {
    getUserData();
    super.initState();
  }

 //  String imageUrl = '';
  void getUserData() async{
    userData = await FirebaseFirestore.instance.collection('users').doc(authenticatedUser.uid).get();
    // print('********* ${userData['username']}');
     setState(() {
        username = userData['username'];
     });
    
     //imageUrl =  userData['image_url'];
     print('************${authenticatedUser.uid}');
     print( userData['username']);
     print('********* ${userData['image_url']}');
  }

  @override
  Widget build(BuildContext context) {

  

   Future.delayed(Duration.zero);
    return Drawer(
      backgroundColor: kGreenAccent,
      child: ListView(
        children:  [
          DrawerHeader(
            child: Column(
              children: [
                //Text('Ciao'),
                //! The following LateError was thrown building myDrawer(dirty, state: _myDrawerState#180fb):
                //!LateInitializationError: Field 'username' has not been initialized.

                 Text('Ciao ${username!}'),
                 const CircleAvatar(
                 foregroundImage: AssetImage('images/success.png'),
                
                //foregroundImage:  NetworkImage(imageUrl),

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