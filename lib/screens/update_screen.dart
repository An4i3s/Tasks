import 'package:flutter/material.dart';


//todo => 1. creare callback funzione onLongPress in taskTile
//todo => 2. da Long Click su elemento in Home Page (=task=tilte) devo rimandarmi a updateScreen conservando item.id ('name di relatime db') del task
//todo => 3. da usare 

class UpdateScreen extends StatefulWidget{

  static const String id = 'updateScreenId';

  UpdateScreen({super.key, required this.itemId});
  String itemId;



  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  

  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        Text('itemId is = ${widget.itemId}'),

      ],
     );
  }
}