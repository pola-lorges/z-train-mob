import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/firestoreService/userService.dart';
import 'package:shop_app/helper/response.dart';
import 'package:shop_app/models/User.dart';
import 'dart:developer';



import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
 final FirebaseAuth auth = FirebaseAuth.instance;
 String lastname = 'Inconnu' ;
 String genre = 'Homme' ;

  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;
    setName(user);
  }

  setName(user) async {
    final resp = await getUser(user.uid) ; 
    setState(() {
      if(resp.lastName.isNotEmpty){
        lastname = resp.lastName;
        genre = resp.genre;
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.6,
      // decoration: BoxDecoration(
      //   color: kSecondaryColor.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(15),
      // ),
      child: TextField(
        onChanged: (value) => print(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: lastname,
            enabled: false,
            ),
      ),
    );
  }
}


