import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/sizes.dart';
import 'package:one_my_tasks/constants/widgets_styles.dart';
import 'package:one_my_tasks/data/category_data.dart';
import 'package:one_my_tasks/models/tasks.dart';
import 'package:one_my_tasks/screens/update_screen.dart';
import 'package:one_my_tasks/widgets/my_bottom_navbar.dart';
import 'package:one_my_tasks/widgets/my_drawer.dart';
import 'package:one_my_tasks/widgets/tile_task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;





class HomePage extends StatefulWidget {
  final String title = 'Tasks';

  const HomePage({super.key});

  static const String id = "Home Page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final authUser = FirebaseAuth.instance.currentUser;


   

  int selectedIndex = 0;
  
  String? pressedItemId;


  List<Tasks> _displayTasks = [];
  List<Tasks> _tasksItems = [];

  Scadenza? filtroScadenza;
  List<Tasks> _searchList = [];
  String? parolaCercata;


  SearchController? myController;

  var _isLoading = true;
  String? _error;


    var userData;
    
   String? username = ' ';
    String? imageUrl = '';

    void getUserData() async{
    userData = await FirebaseFirestore.instance.collection('users').doc(authUser!.uid).get();
    // print('********* ${userData['username']}');
     setState(() {
        username = userData['username'];
        imageUrl =  userData['image_url'];
     });
    
  }

  @override
  void initState() {
    
    super.initState();
    myController=SearchController();
    _loadItems();
    getUserData();

    
  
  }

  void _loadItems() async {
    final url =
        Uri.https('tasks-3b776-default-rtdb.firebaseio.com', 'tasks-list/${authUser!.uid}.json');
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


int i =0;
    for (final item in listData.entries) {
      i++;
      print('*****$i');
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
        'tasks-list/${authUser!.uid}/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _displayTasks.insert(index, item);
      });
    }
  }

  

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;

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
           
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {


   SizeConfig.init(context);


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


     if(parolaCercata!=null && parolaCercata!.isNotEmpty){
      _displayTasks = _tasksItems.where((element) => element.title.contains(parolaCercata!)).toList();

    }



    if (_displayTasks.isNotEmpty) {
      content = ListView.builder(
        itemCount: _displayTasks.length,
        itemBuilder: (context, index) => Dismissible(
          direction: DismissDirection.endToStart,
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
            callBack: () {
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdateScreen(currentTask: _displayTasks[index]),
                ),
            );
            },
          ),
        ),
      );
    }

    //var size = MediaQuery.of(context).size;

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
      drawer:    myDrawer(username: username!, imageUrl: imageUrl!,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical!*1.5, horizontal: SizeConfig.blockSizeVertical!*1.5),
              child: SizedBox(
                width: SizeConfig.blockSizeHorizontal!*80,
                height: SizeConfig.blockSizeVertical!*7,
                
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
                  padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal!*1.5),
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
                  padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal!*1.5),
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
                  padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal!*1.5),
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
                  padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal!*1.5),
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

              margin:  EdgeInsets.all(SizeConfig.blockSizeHorizontal!*2),
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
              width: SizeConfig.blockSizeHorizontal!*100,
             
             height: SizeConfig.blockSizeVertical!*60,
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}


