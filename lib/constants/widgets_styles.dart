import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';

TextStyle kTextStyle = TextStyle(
  color: kPink,
  fontWeight: FontWeight.bold,
  fontSize: 25,
);

TextStyle kMenuStyle = TextStyle(
color: kGreenAccent,
fontSize: 20,
);

InputDecorationTheme kInputDecorationTheme = InputDecorationTheme(

              border: OutlineInputBorder(
                
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                  //color: kGreen,
                  width: 0,
                  
                )
              ),
              filled: true,
              fillColor: kDarkGreen,
              
              // coloreStudio,
              
            
);

InputDecoration kInputDecoration = InputDecoration(
              
              border: OutlineInputBorder(
                
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  style: BorderStyle.none,
                  //color: kGreen,
                  width: 0,
                  
                )
              ),
              filled: true,
              fillColor: kDarkGreen,
              
              // coloreStudio,
              
            
);



ButtonStyle kMenuEntry = ButtonStyle(
 backgroundColor: MaterialStatePropertyAll<Color>(bckColor),
  foregroundColor: MaterialStatePropertyAll<Color>(kGreenAccent),
  textStyle: MaterialStatePropertyAll<TextStyle>(kMenuStyle),
);

TextButtonThemeData kStyleTxtBtnTheme =  TextButtonThemeData(
            
            style: TextButton.styleFrom(
            
            foregroundColor: Colors.white,
            backgroundColor: kPink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );

ButtonStyle kBtnStyle = ButtonStyle(
 backgroundColor: MaterialStatePropertyAll<Color>(kPink),
  foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
  padding: MaterialStatePropertyAll(EdgeInsets.only(bottom: 25)),
  //textStyle: MaterialStatePropertyAll<TextStyle>(kMenuStyle),
);

