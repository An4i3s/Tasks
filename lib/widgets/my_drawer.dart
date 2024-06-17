import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/sizes.dart';


class myDrawer extends StatefulWidget {
  const myDrawer({super.key, required this.username,required this.imageUrl});
  final String username;
  final String imageUrl;

  

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;



   @override
  void initState() {
    
    super.initState();
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
             CircleAvatar(
              //SharedPereferences (validazione cache login/data)
              
              backgroundImage:  CachedNetworkImageProvider(widget.imageUrl,),
            
              
              ),
              Padding(
                
                padding:  EdgeInsets.only(top:  SizeConfig.blockSizeVertical!*1.2),
                child: Text('Ciao ${widget.username}!'),
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
       
        ],
      ),
    );
  }
}