


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';

import 'package:one_my_tasks/widgets/my_Custom_form.dart';
import 'package:one_my_tasks/widgets/my_bottom_navbar.dart';




typedef AsyncCallback = Future<void> Function();


class AddTaskScreen extends StatefulWidget {
  static const String id = 'Add Task Screen';

  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String title = 'Add Task';



  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: bckColor,
      ),
      bottomNavigationBar: MyBottomNavBar(
        selectedIndex: 1,
      ),
      body:
              MyCustomForm(
             
               )
        
    );
  }
}
