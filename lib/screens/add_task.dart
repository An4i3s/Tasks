


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
 // bool isTaskAdded = false;
 
  // var _enteredTitle;

  // var _enteredDescription;

  // var _selectedCategory = categories[Categories.casa];

  // final _status = Status.pending;

  //var _isSending = false;

  

  //  Future<AsyncCallback> saveItem() async {
  //    setState(() {
  //       _isSending = true;
  //       //PROVA
  //       isTaskAdded= true;
  //     });
  //     final url = Uri.https(
  //         'tasks-3b776-default-rtdb.firebaseio.com', 'tasks-list.json');

  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //        // 'name': _enteredTitle,
  //         'name': MyCustomForm.,
  //         'description': _enteredDescription,
  //         'category': _selectedCategory?.name,
  //         'status': _status.name,
  //       }),
  //     );

  //     print('**** STATUS CODE & RESPONSE POST ****');
  //     print(response.body);
  //     print(response.statusCode);
      
     
   

  //     if (isTaskAdded) {
  //       Navigator.of(context as BuildContext).pushNamed(HomePage.id);
  //       //Navigator.of(context as BuildContext).pop();
  //     }
  //     return saveItem();
  // }




  

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
