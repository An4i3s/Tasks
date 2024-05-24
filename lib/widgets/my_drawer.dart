import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/sizes.dart';
import 'package:one_my_tasks/constants/widgets_styles.dart';

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
    String? imageUrl = '';


   @override
  void initState() {
    
    super.initState();
    getUserData();
  }

 //  String imageUrl = '';
  void getUserData() async{
    userData = await FirebaseFirestore.instance.collection('users').doc(authenticatedUser.uid).get();
    // print('********* ${userData['username']}');
     setState(() {
        username = userData['username'];
        imageUrl =  userData['image_url'];
     });
    
  }

//todo da sistemare:
//todo => username e imageUrl ci mettono qualche secondo prima di caricarsi... usare Future Delay??? Oppure metodo che se isLoading sosituisce con ProgressBar
//todo => Network Img da questa Exception... ma tanto funziona lo stesso... ;)
//todo => Network Image non funziona su Chrome/Edge
// '════════ Exception caught by image resource service ════════════════════════════
//Invalid argument(s): No host specified in URI file:///'


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
             CircleAvatar(
              //SharedPereferences (validazione cache login/data)
              
              backgroundImage:  NetworkImage(imageUrl!),
              
              ),
              Padding(
                padding:  EdgeInsets.only(top:  SizeConfig.blockSizeVertical!*1.2),
                child: Text('Ciao ${username!}!'),
              ),
              ListTile(
                   title:  Text('Exit', style: TextStyle(color: kRed, fontWeight: FontWeight.bold),),
                   leading:  Icon(Icons.logout, color: kRed,),
                  onTap: () {
                       FirebaseAuth.instance.signOut();
                      },
             ),
            ],
                        ),
            
          ),
           ListTile(
            title:  Text('Gestici Categorie', style: kTextStyle,),
            leading: Icon(Icons.settings, color: kTxtColor,),
          ),
           ListTile(
            title:  Text('Modifica Profilo', style: kTextStyle,),
            leading: Icon(Icons.image, color: kTxtColor),
          ),
        ],
      ),
    );
  }
}