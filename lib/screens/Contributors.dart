
//Screen to view the list of all the contributors of the project selected in screen 1


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/ContributorsCardModel.dart';
import '../Widgets/Contributor_Card.dart';

class Contributors extends StatelessWidget {
  static String routename = '/Contributors';
  List <ContributorCard> cardList = [
    ContributorCard(userName:'Contributor 1',followers:'30',displayImgUrl:'https://www.cnam.ca/wp-content/uploads/2018/06/default-profile.gif'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Contributors List')),
        backgroundColor: Colors.grey,
      ),
      body:ListView.builder(
          // Get the List of contributors to the project from the GitHub Api
          // Append the details of the card to the cardList
          itemCount: cardList.length,
          itemBuilder:(ctx , index){
            return ContCard(userName: cardList[index].userName,dispImg: cardList[index].displayImgUrl,followers: cardList[index].followers);
          }
       ),
       floatingActionButton: FloatingActionButton(
         backgroundColor: Colors.black,
         child: Icon(Icons.add),
         onPressed: addToContributors,
       ),
    );
  }
}

addToContributors(){
 // Trigger an alert box or something similar
 // Ask the user to enter the details
 // Add to contributors list
}


