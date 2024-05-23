import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/icons.dart';
import 'package:one_my_tasks/models/category_task.dart';

final categories = {
  Categories.casa: TaskCategory(
    name: 'Casa',
    categoryColor: coloreCasa,
    categoryIcon: iconCasa,
  ),
  Categories.lavoro: TaskCategory(
      name: 'Lavoro', categoryColor: coloreLavoro, categoryIcon: iconLavoro),
  Categories.studio: TaskCategory(
      name: 'Studio', categoryColor: coloreStudio, categoryIcon: iconStudio),
  Categories.benessere: TaskCategory(
      name: 'Benessere', 
      categoryColor: coloreBenessere, 
      categoryIcon: iconBenessere,),
  Categories.svago: TaskCategory(
    name: 'Svago', 
    categoryColor: coloreSvago, 
    categoryIcon: iconSvago)
};
