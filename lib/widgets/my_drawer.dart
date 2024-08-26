import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_my_tasks/constants/colors.dart';
import 'package:one_my_tasks/constants/constant_strings.dart';
import 'package:one_my_tasks/constants/sizes.dart';
import 'package:one_my_tasks/constants/widgets_styles.dart';
import 'package:one_my_tasks/utility/multiple_languages.dart';
import 'package:country_flags/country_flags.dart';



class myDrawer extends StatefulWidget {
  const myDrawer({super.key, required this.username,required this.imageUrl});
  final String username;
  final String imageUrl;

  

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  
  Mutlilanguages multilanguages = Mutlilanguages();


   @override
  void initState() {
    
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

 
  SizeConfig.init(context);

    return Drawer(
      backgroundColor: kGreenAccent,
      child: ListView(
        children:  [
          DrawerHeader(
            child: Column(
            children: [
              CircleAvatar(
              //SharedPereferences (validazione cache login/data)
              
              backgroundImage:  CachedNetworkImageProvider(widget.imageUrl,),
            
              
              ),
              Padding(
                
                padding:  EdgeInsets.only(top:  SizeConfig.blockSizeVertical!*1.2),
                child: Text('Ciao ${widget.username}!'),
              ),
              ListTile(
                    title:  Text('Exit', style: TextStyle(color: kRed, fontWeight: FontWeight.bold),),
                    leading:  Icon(Icons.logout, color: kRed,),
                  onTap: () {
                        FirebaseAuth.instance.signOut();
                      },
              ),
              
            ],
                        ),
            
          ),
        ListTile(
              title: Text(Mutlilanguages.of(context)!.translate(Constants.introduceLabel),
              //title: Text(Mutlilanguages.of(context)!.translate('introduce'),
              style: const TextStyle(fontSize: 32),
              ),
              
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                      multilanguages.setLocale(context, const Locale.fromSubtags(languageCode: 'en'));
                        print('°°°°°°°°°°°°°°°°TEXT BUTTON PRESSED');
                    });
                }, 
                icon: CountryFlag.fromLanguageCode('en'),),
                  IconButton(
                onPressed: (){
                  setState(() {
                      multilanguages.setLocale(context, const Locale.fromSubtags(languageCode: 'it'));
                        print('°°°°°°°°°°°°°°°°TEXT BUTTON PRESSED');
                    });
                }, 
                icon: CountryFlag.fromLanguageCode('it'),),
        ],
      ),
    );
  }
}