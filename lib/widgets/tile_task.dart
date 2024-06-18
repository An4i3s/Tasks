import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/sizes.dart';

class TaskTile extends StatelessWidget{

  late String title;
  late String description;
  late Color bckColor;
  late Icon icon;
  Function()? callBack;
  //late String status;

  TaskTile({super.key, required this.title, required this.description, required this.bckColor, required this.icon, required this.callBack });



  @override
  Widget build(BuildContext context) {

  SizeConfig.init(context);


    return Padding(
      padding:  EdgeInsets.symmetric(vertical:  SizeConfig.blockSizeVertical!*1, horizontal: SizeConfig.blockSizeHorizontal!*4),
      child: Card(
        color: bckColor,
        child: ListTile(
          tileColor: bckColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          subtitle: Text(description),
          leading: CircleAvatar(
            child: icon,
          ),
          onLongPress: callBack,
        ),
      ),
    );
  }
  
}