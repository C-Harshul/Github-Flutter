
//Page where the user signs in through his/her GitHub account

import 'package:flutter/material.dart';
import 'package:github_flutter/screens/Home_Page.dart';
import '../Widgets/Place_Holder.dart';
import 'package:github_flutter/routes.dart';

class SignIn extends StatelessWidget {
  static const routeName = '/SignIn';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign In page',)),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Enter the email ID
          Place_Holder(height:70.0,width: 400),
          //Enter the Password
          Place_Holder(height:70.0,width: 400),
          //Log in button
          Place_Holder(height: 30,width: 200),
          //Login through GitHub account
          Container(
            height: 80,
            child: Image.asset('assets/images/git.png'),
          ),


          //Button will be removed once the login button is designed

          FlatButton(
            color: Colors.black,
            onPressed: (){
            Navigator.popAndPushNamed(context,HomePage.routename );
          },
         ),
        ],
      ),
    );
  }
}



