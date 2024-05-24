

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



typedef AsyncCallback = Future<void> Function();



class MyCustomForm extends StatefulWidget{
  
   
   MyCustomForm({super.key});



  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
   String? _enteredTitle = "";
    var _isSending = false;
      bool isTaskAdded = false;

  String? _enteredDescription = "";

  var _selectedCategory = categories[Categories.casa];

  var _selectedScadenza = "mese";

 
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


   void _validate(){
    _formKey.currentState!.validate();
    
    //prova 
     if (!context.mounted) {
        return;
      }
   }
  
   void saveItem() async {
     setState(() {
        _isSending = true;
        isTaskAdded= true;
      });
      final url = Uri.https(
          'tasks-3b776-default-rtdb.firebaseio.com', 'tasks-list.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enteredTitle,
          'description': _enteredDescription,
          'category': _selectedCategory?.name,
          'scadenza': _selectedScadenza,
          'done' : false,
        }),
      );

      print('**** STATUS CODE & RESPONSE POST ****');
      print(response.body);
      print(response.statusCode);
      
     
   //Prova = togliere questi due If da Async
//Prova aggiunto context.mounted
      // if (isTaskAdded && context.mounted) {
      // //  Navigator.of(context as BuildContext).pushNamed(HomePage.id);
      // Navigator.popAndPushNamed(context, HomePage.id);
      //   //Navigator.of(context as BuildContext).pop();
      // }

      // if(!context.mounted){
      //   return;
      // }
     
  }

  void changeContext(){
     if (isTaskAdded && context.mounted) {
      //  Navigator.of(context as BuildContext).pushNamed(HomePage.id);
      Navigator.popAndPushNamed(context, HomePage.id);
        //Navigator.of(context as BuildContext).pop();
      }

      if(!context.mounted){
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
                label: 'Title',
                isMultiLine: false,
                callBackOnChanged: (value){
                  setState(() {
                    _enteredTitle= value;

                  });
                  

                },
                callBackValidator: ValidationBuilder().minLength(1).build(), 
              ),
              AddTaskInput(
                label: 'Description',
                isMultiLine: true,
                callBackOnChanged: (value) {
                
                    _enteredDescription = value!;
                
                },
                callBackValidator:  ValidationBuilder().minLength(1).build(),
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
                  value: _selectedCategory,
                  items: [
                    for (final category in categories.entries)
                      DropdownMenuItem(
                        value: category.value,
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
                  onChanged: (value1) {
                    setState(() {
                      _selectedCategory = value1;
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
                     DropdownMenuItem(value: 'oggi',child: Text('Oggi'),),
                     DropdownMenuItem(value: 'settimana',child: Text('Settimana'),),
                     DropdownMenuItem(value: 'mese',child: Text('Mese'),),
                  ], 
                  onChanged: (value){
                    setState(() {
                      _selectedScadenza = value!;
                    });
                    
                  },
                  ),
              ),


              Container(
                margin: EdgeInsets.only(right: 15.0, left: 15, top: 50, bottom: 50),
                width: double.infinity,
                height: 70,
                child: TextButton(
                  style: kBtnStyle,
                  onPressed: ()  {
                    //prova modiifca validate
                     _validate();
                     if(!_formKey.currentState!.validate()){
                      showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Text(
                            'Task non aggiunto!'
                          ),
                        );
                      });
                      return;
                     }else if(_formKey.currentState!.validate()){
                    isTaskAdded=true;
                  
                    //widget.callback.call();
                    saveItem();
                    changeContext();
                    showDialog(
                    
                      context: context.mounted ? context : const HomePage().createState().context,
                      //context.mounted ? context : const HomePage().createState().context,
                      // widget.isTaskAdded
                      //     ? const HomePage().createState().context
                      //     : context,
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
                                  'You added a new task!',
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
                    child:  Text(
                      'Add',
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

  AddTaskInput(
      {super.key, required this.label,
      required this.isMultiLine,
      required this.callBackOnChanged,
      required this.callBackValidator,
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
            cursorColor: kTxtColor,
            maxLines: widget.isMultiLine ? 4 : 1,
            decoration: kInputDecoration,
            //da onChange a OnSaved
           // onSaved: widget.callBackOnChanged,
           //Prova: onFieldSubmitted
            onChanged: widget.callBackOnChanged,
           validator: widget.callBackValidator,
          ),
        ),
      ],
    );
  }
}
