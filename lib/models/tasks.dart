import 'package:one_my_tasks/models/category_task.dart';
//enum Status{inProgress, pending, completed}
enum Scadenza {oggi,settimana,mese}

class Tasks{
  
  String id;
  String title;
  String description;
  TaskCategory taskCategory;
  bool done;
  Scadenza scadenza;
  
 // Status status;
  

  Tasks({required this.id,required this.title, required this.description, required this.taskCategory, required this.scadenza, this.done=false});
}