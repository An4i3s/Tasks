import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/widgets_styles.dart';
import 'package:one_my_tasks/data/category_data.dart';
import 'package:one_my_tasks/models/category_task.dart';
import 'package:one_my_tasks/models/tasks.dart';
import 'package:one_my_tasks/screens/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_my_tasks/screens/update_screen.dart';


class UpdateForm extends StatefulWidget {
  UpdateForm({super.key, required this.currentTask});
  //todo creare liste differenti in base a User
 
  Tasks currentTask;

  Tasks get task {
    return currentTask;
  }

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {

  final authUser = FirebaseAuth.instance.currentUser;


  String _enteredTitle = '';
  var _isSending = false;
  bool isTaskUpdated = false;

  String _enteredDescription = '';

  String selectedCategory = '';
  //  String selectedCategory = categories.entries.where((element) => element.value.name == widget.currentTask.taskCategory.toString()).toString();
  // //var _selectedCategory = "";

  var _selectedScadenza = "mese";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validate() {
    _formKey.currentState!.validate();

    //prova
    if (!context.mounted) {
      return;
    }
  }

  void upddateItem() async {
    setState(() {
      _isSending = true;
      isTaskUpdated = true;
    });

    if (_enteredDescription.isEmpty) {
      _enteredDescription = widget.task.description;
    }
    if (_enteredTitle.isEmpty) {
      _enteredTitle = widget.task.title;
    }
    if (selectedCategory.isEmpty) {
      selectedCategory = widget.task.taskCategory.name;
    }

    final url = Uri.https('tasks-3b776-default-rtdb.firebaseio.com',
        'tasks-list/${authUser!.uid}/${widget.currentTask.id}.json');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _enteredTitle,
        'description': _enteredDescription,
        'category': selectedCategory,
        'scadenza': _selectedScadenza,
        'done': false,
      }),
    );

    print('**** STATUS CODE & RESPONSE POST ****');
    print(response.body);
    print(response.statusCode);
  }

  void changeContext() {
    if (isTaskUpdated && context.mounted) {
      Navigator.popAndPushNamed(context, HomePage.id);
      setState(() {});
    }

    if (!context.mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AddTaskInput(
              initialTitle: widget.currentTask.title,
              label: 'Title',
              isMultiLine: false,
              isTitle: true,
              callBackOnChanged: (value) {
                setState(() {
                  _enteredTitle = value!;
                });
              },
              callBackValidator: ValidationBuilder().minLength(1).build(),
            ),
            AddTaskInput(
              initialDescription: widget.currentTask.description,
              label: 'Description',
              isMultiLine: true,
              isTitle: false,
              callBackOnChanged: (value) {
                _enteredDescription = value!;
              },
              callBackValidator: ValidationBuilder().minLength(1).build(),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
                  child: Text(
                    'Category',
                    textAlign: TextAlign.start,
                    style: kTextStyle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField(
                style: kMenuStyle,
                decoration: kInputDecoration,
                //todo value : item.category.value
                value: widget.currentTask.taskCategory.name,
                items: [
                  for (final category in categories.entries)
                    DropdownMenuItem(
                      value: category.value.name,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                          ),
                          Text(category.value.name),
                        ],
                      ),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
                  child: Text(
                    'Scadenza',
                    textAlign: TextAlign.start,
                    style: kTextStyle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField(
                value: _selectedScadenza,
                style: kMenuStyle,
                decoration: kInputDecoration,
                items: const [
                  DropdownMenuItem(
                    value: 'oggi',
                    child: Text('Oggi'),
                  ),
                  DropdownMenuItem(
                    value: 'settimana',
                    child: Text('Settimana'),
                  ),
                  DropdownMenuItem(
                    value: 'mese',
                    child: Text('Mese'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedScadenza = value!;
                  });
                },
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(right: 15.0, left: 15, top: 50, bottom: 50),
              width: double.infinity,
              height: 70,
              child: TextButton(
                style: kBtnStyle,
                onPressed: () {
                  //prova modiifca validate
                  _validate();
                  if (!_formKey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Task non aggiunto!'),
                          );
                        });
                    return;
                  } else if (_formKey.currentState!.validate()) {
                    // isTaskUpdated=true;

                    // if(_enteredDescription!.isEmpty){
                    //     _enteredDescription = widget.task.description;
                    // }
                    // if(_enteredTitle!.isEmpty){
                    //   _enteredTitle = widget.task.title;
                    // }
                    // if(selectedCategory!.isEmpty){
                    //    selectedCategory = widget.task.taskCategory.name;
                    // }

                    upddateItem();
                    changeContext();

                    showDialog(
                      context: context.mounted
                          ? context
                          : const HomePage().createState().context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text(
                            'Success',
                            style: TextStyle(
                              color: kGreenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Image(
                                image: AssetImage('images/success.png'),
                                width: 60,
                                height: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Task Aggiornato!',
                                  style: kTextStyle,
                                ),
                              )
                            ],
                          ),
                          backgroundColor: bckColor,
                        );
                      }),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskInput extends StatefulWidget {
  String label;
  bool isMultiLine;
  bool isTitle;
  String? initialTitle;
  String? initialDescription;

  AddTaskInput({
    super.key,
    required this.label,
    required this.isMultiLine,
    required this.callBackOnChanged,
    required this.callBackValidator,
    required this.isTitle,
    this.initialTitle,
    this.initialDescription,
  });

  Function(String?) callBackOnChanged;
  String? Function(String?) callBackValidator;

  @override
  State<AddTaskInput> createState() => _AddTaskInputState();
}

class _AddTaskInputState extends State<AddTaskInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
              child: Text(
                widget.label,
                textAlign: TextAlign.start,
                style: kTextStyle,
              ),
            ),
          ],
        ),
        //?
        SizedBox(
          width: 350,
          height: widget.isMultiLine ? 120 : 45,
          child: TextFormField(
            initialValue: widget.isTitle
                ? widget.initialTitle
                : widget.initialDescription,
            cursorColor: kTxtColor,
            maxLines: widget.isMultiLine ? 4 : 1,
            decoration: kInputDecoration,
            onChanged: widget.callBackOnChanged,
            validator: widget.callBackValidator,
          ),
        ),
      ],
    );
  }
}
