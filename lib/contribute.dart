import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class Contri extends StatelessWidget {
  final String title;
  Contri(this.title);


Future mail()
async {
    String dt = 'https://mail.google.com/mail/u/0/#inbox?compose=new';
   bool isInstalled = await DeviceApps.isAppInstalled('com.google.android.gm');
   if (isInstalled != false)
    { 
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: dt
    
  );await intent.launch();
    }
else
{
  String url = dt;
  if (await canLaunch(url)) 
    await launch(url);
   else 
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
             onPressed: ()=> mail()
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
