import 'package:flutter/material.dart';

enum Categories {
  casa,
  lavoro,
  studio,
  svago,
  benessere
}

class TaskCategory{
  
  late final String name;
  final Color categoryColor;
  final Icon categoryIcon;

  TaskCategory({required this.name, required this.categoryColor, required this.categoryIcon});

  //void addCategory 

}