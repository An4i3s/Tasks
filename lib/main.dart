
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/firebase_options.dart';
import 'package:one_my_tasks/screens/add_task.dart';
import 'package:one_my_tasks/screens/auth.dart';
import 'package:one_my_tasks/screens/home_page.dart';
import 'package:flutter/services.dart';
import 'package:one_my_tasks/screens/splash_screen.dart';
import 'package:one_my_tasks/utility/multiple_languages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


List? locales;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ]
  ).then((value) => runApp(const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    state!.changeLocale(newLocale);
  }
}

class _MainAppState extends State<MainApp> {

  Locale _locale = const Locale.fromSubtags(languageCode: 'en');

   void changeLocale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final multilanguages = Mutlilanguages();
    final localeKey = await multilanguages.readLocaleKey();
    if(localeKey == 'it'){
      _locale = const Locale('it', 'IT');
    }else{
      _locale = const Locale.fromSubtags(languageCode: 'en');
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      supportedLocales: const [
        Locale('it'),
        Locale('en'),
        // Locale('it', 'IT'),
        // Locale.fromSubtags(languageCode: 'en')
      ],
      localizationsDelegates:  const [
        Mutlilanguages.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      // localeResolutionCallback: (locale, supportedLocales) {
      //   for(var supportedLocaleLanguage in supportedLocales){
      //     if(supportedLocaleLanguage.languageCode == locale?.languageCode && supportedLocaleLanguage.countryCode == locale?.countryCode){
      //       return supportedLocaleLanguage;
      //     }
      //   }
      //   return supportedLocales.first;
      // },
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
        //UpdateScreen.id:(context) =>  UpdateScreen(),
      },
      //theme: //?,
    );
  }
}
