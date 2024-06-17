
import 'package:flutter/material.dart';
import 'package:one_my_tasks/screens/add_task.dart';
import 'package:one_my_tasks/screens/home_page.dart';

class MyBottomNavBar extends StatefulWidget {
   MyBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  late int selectedIndex;

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap:(value) {
        if(value==1){
          
          setState(() {
            widget.selectedIndex = value;
            // Navigator.pushNamed(context, AddTaskScreen.id);
            Navigator.popAndPushNamed(context, AddTaskScreen.id);
          print('tap on value 1');
          });
         
        }else{
          setState(() {
            widget.selectedIndex = 0;
             Navigator.popAndPushNamed(context, HomePage.id);
             //prova: con pop
          
             
          print('tap on value 0');
          });
        }
      },
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task',),
      ],
      );
  }
}