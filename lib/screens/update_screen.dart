import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/models/tasks.dart';
import 'package:one_my_tasks/widgets/update_form.dart';


//todo => 1. creare callback funzione onLongPress in taskTile
//todo => 2. da Long Click su elemento in Home Page (=task=tilte) devo rimandarmi a updateScreen conservando item.id ('name di relatime db') del task
//todo => 3. da usare 

class UpdateScreen extends StatefulWidget{

  static const String id = 'updateScreenId';

  UpdateScreen({super.key, required this.currentTask});
//  String itemId;
  Tasks currentTask;



  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiorna il Task'),
        backgroundColor: bckColor,
      ),
      body:  SingleChildScrollView(
        child: Column(
        children: [
          UpdateForm(currentTask: widget.currentTask,),
        ],
             ),
      ),
     );
     
    
  }
}