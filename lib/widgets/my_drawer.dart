import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/sizes.dart';

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
    
  }

  @override
  Widget build(BuildContext context) {

  SizeConfig.init(context);

    return Drawer(
      backgroundColor: kGreenAccent,
      child: ListView(
        children:  [
          DrawerHeader(
            child: Column(
            children: [
            const CircleAvatar(
               foregroundImage: AssetImage('images/success.png'),
              //foregroundImage:  NetworkImage(imageUrl),
              ),
              Padding(
                padding:  EdgeInsets.only(top:  SizeConfig. blockSizeVertical!*1.5),
                child: Text('Ciao ${username!}!'),
              ),
              ListTile(
                   title:  Text('Exit', style: TextStyle(color: kRed),),
                   leading:  Icon(Icons.logout, color: kRed,),
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