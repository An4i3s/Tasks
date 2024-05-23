import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/widgets_styles.dart';
import 'package:one_my_tasks/data/category_data.dart';
import 'package:one_my_tasks/models/tasks.dart';
import 'package:one_my_tasks/widgets/my_bottom_navbar.dart';
import 'package:one_my_tasks/widgets/my_drawer.dart';
import 'package:one_my_tasks/widgets/tile_task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



/*
todo: - gestire caso in submit quando parola cercata non esiste (content == circular=) 
todo  - ??
todo  - ??
 */




class HomePage extends StatefulWidget {
  final String title = 'Tasks';

  const HomePage({super.key});

  static const String id = "Home Page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
 
 

  List<Tasks> _displayTasks = [];
  List<Tasks> _tasksItems = [];

  Scadenza? filtroScadenza;
  List<Tasks> _searchList = [];
   String? parolaCercata;


  SearchController? myController;

  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    myController=SearchController();
    
    _loadItems();
    
  }

  void _loadItems() async {
    final url =
        Uri.https('tasks-3b776-default-rtdb.firebaseio.com', 'tasks-list.json');
    final response = await http.get(url);

    //ERROR HANDLING
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data';
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    print('RESPONSE BODY GET = ${response.body}');

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Tasks> loadedItems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.name == item.value['category'])
          .value;
      final Scadenza scadenza;
      if (item.value['scadenza'] == 'mese') {
        scadenza = Scadenza.mese;
      } else if (item.value['scadenza'] == 'oggi') {
        scadenza = Scadenza.oggi;
      } else {
        scadenza = Scadenza.settimana;
      }

      loadedItems.add(Tasks(
        id: item.key,
        title: item.value['name'],
        description: item.value['description'],
        taskCategory: category,
        done: item.value['done'],
        scadenza: scadenza,
      ));
    }
    setState(() {
      _tasksItems = loadedItems;
    
    });
    print('GET METHOD = ');
    print(response.body);
  }

  void _removeItem(Tasks item) async {
    int index = _displayTasks.indexOf(item);

    setState(() {
      _displayTasks.remove(item);
    });

    final url = Uri.https('tasks-3b776-default-rtdb.firebaseio.com',
        'tasks-list/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _displayTasks.insert(index, item);
      });
    }
  }

  

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
   // staCercando = true;

    _searchList =
        _tasksItems.where((element) => element.title.contains(input)).toList();

    return List<ListTile>.generate(_searchList.length, (index) {
       String item = _searchList[index].title;
      return ListTile(
        title: Text(item, style: kMenuStyle),
        onTap: () {
          setState(() {
            
            parolaCercata = item;
            item='';
           
            Navigator.pop(context);
            //controller.closeView(item);
            //mod fa true a false
            //staCercando = false;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet'),
    );


   

    _displayTasks = switch (filtroScadenza) {
      Scadenza.oggi => _tasksItems
          .where((element) => element.scadenza == Scadenza.oggi)
          .toList(),
      Scadenza.settimana => _tasksItems
          .where((element) => element.scadenza == Scadenza.settimana)
          .toList(),
      Scadenza.mese => _tasksItems
          .where((element) => element.scadenza == Scadenza.mese)
          .toList(),
      null => _tasksItems,
      
    };

    if (_isLoading) {
      content = Center(
        child: CircularProgressIndicator(
          color: kGreenAccent,
        ),
      );
    }

//?&& sta cercando?
     if(parolaCercata!=null && parolaCercata!.isNotEmpty){
      _displayTasks = _tasksItems.where((element) => element.title.contains(parolaCercata!)).toList();
     // staCercando=false;
     // parolaCercata=null;
    }

    // if (staCercando) {
    //   _displayTasks = _searchList;
    //   staCercando = false;
    // }

    if (_displayTasks.isNotEmpty) {
      content = ListView.builder(
        itemCount: _displayTasks.length,
        itemBuilder: (context, index) => Dismissible(
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            setState(() {
              _removeItem(_tasksItems[index]);
            });
          },
          key: ValueKey(_displayTasks[index].id),
          child: TaskTile(
            title: _displayTasks[index].title,
            description: _displayTasks[index].description,
            bckColor: _displayTasks[index].taskCategory.categoryColor,
            icon: _displayTasks[index].taskCategory.categoryIcon,
          ),
        ),
      );
    }

    var size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.title,
        )),
        backgroundColor: bckColor,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: MyBottomNavBar(selectedIndex: 0),
      drawer:   myDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, top: 15, right: 15, bottom: 15),
              child: SizedBox(
                width: size.width - 80,
                height: 45,
                // child: TextField(
                //   onChanged: (value) {
                //     if (mounted) {
                //       print("********$value");
                //       setState(() {
                //         //  _displayTasks = _tasksItems.where((element) => element.title.contains(value)).toList();
                //         parolaCercata = value;
                //       });
                //     }
                //   },
                //   // onSubmitted: (value) {
                //   //   setState(() {
             
                // ),
                child: SearchAnchor.bar(
                  searchController: myController!,
                  viewConstraints: const BoxConstraints(
                    maxHeight: 300,
                  ),
                  isFullScreen: false,
                  barLeading: Icon(Icons.search, color: kTxtColor,),
                  barBackgroundColor: const MaterialStatePropertyAll(Colors.white),
                  barHintText: 'Cerca',
                  viewBackgroundColor: Colors.white,
                  viewHeaderTextStyle: kMenuStyle,
                  suggestionsBuilder: (context, controller) {
                    //return [];
                    return getSuggestions(controller);
                  },
                  textInputAction: TextInputAction.search,
                  
                  onSubmitted: (value) {
                    print('***** ${myController!.isOpen}');
                    setState(() {
                      parolaCercata=value;
                      value='';
                      
                    });

                    if(context.mounted && myController!.isOpen){
                      Navigator.pop(context);
                     
                      }
                    
                  },
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextButton(
                    onPressed: () {
                      filtroScadenza = null;
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: kPink, foregroundColor: Colors.white),
                    child: const Text(
                      'Tutti',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextButton(
                      onPressed: () {
                        filtroScadenza = Scadenza.oggi;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: kGreen,
                          foregroundColor: Colors.white),
                      child: const Text('Oggi')),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextButton(
                      onPressed: () {
                        filtroScadenza = Scadenza.settimana;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: kBlue,
                          foregroundColor: Colors.white),
                      child: const Text('Settimana')),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextButton(
                      onPressed: () {
                        filtroScadenza = Scadenza.mese;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: kRed, foregroundColor: Colors.white),
                      child: const Text('Mese')),
                ),
              ],
            ),
            Container(
              width: double.infinity,

              margin: const EdgeInsets.all(15),
              //alignment: ,
              child: Text(
                'Your Tasks',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: kPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(
              width: size.width,
              height: 500,
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}


