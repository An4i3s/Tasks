import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/widgets_styles.dart';
import 'package:one_my_tasks/firebase_options.dart';
import 'package:one_my_tasks/screens/add_task.dart';
import 'package:one_my_tasks/screens/auth.dart';
import 'package:one_my_tasks/screens/home_page.dart';
import 'package:flutter/services.dart';
import 'package:one_my_tasks/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ]
  ).then((value) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: ((ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
          return const SplashScreen();
         }
        if(snapshot.hasData){
          return const HomePage();
        }
        return const AuthScreen();
        }),
        ),

      theme: ThemeData(
       // primaryColor: Colors.amber,
        //highlightColor: const Color.fromRGBO(204, 231, 213, 1),
        scaffoldBackgroundColor: bckColor,

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
       selectedItemColor: kGreenAccent,
       unselectedItemColor: kTxtColor,
       backgroundColor: kNavColor,
       elevation: 20,
          
        ),

      
      ),
      routes:  {
        AddTaskScreen.id:(context) => const AddTaskScreen(),
        HomePage.id:(context) => const HomePage(),
      },
      //theme: //?,
    );
  }
}
