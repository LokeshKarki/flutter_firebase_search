import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class Contri extends StatelessWidget {
  final String title;
  Contri(this.title);


Future mail(String toMailId, String subject, String body)
async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
   if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

}


Widget show()
{
return Container(
  padding: EdgeInsets.all(8.0),
  child:Center(
    
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        
      
        Text("Guidance and Mentorship by: ",
        style: TextStyle(fontSize: 22.0,
          fontWeight: FontWeight.w800)),
        Text("Mr. Rochak Sharma",
        style: TextStyle(fontSize: 17.0,
          fontWeight: FontWeight.w500)),
          Text("IBM Faculty",
        style: TextStyle(fontSize: 17.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500)),
          Text(""),
          Text("Contributions by: ", 
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 22.0,
        fontWeight: FontWeight.w800)),
        Text("Lokesh Karki & Ashish Pant",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 17.0,
          fontWeight: FontWeight.w500)),
          RaisedButton(
             child: Text("Mail us feedback"),
             onPressed: ()=> mail('beatsshare07@gmail.com', 'App Feedback' , 'Hey, I have used your app, and I would like to give my feedback as follows -  ')
             )

      ],
    ),
  ) ,
  );

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: show()
        );
        
  }

}
