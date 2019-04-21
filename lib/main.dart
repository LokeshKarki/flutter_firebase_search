import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search/searchs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:io';
import 'package:flutter_appavailability/flutter_appavailability.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text('BeatsShare'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Enter Song here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 20.0,),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList())
        ]));
  }





_openGanna (data) async
{
   String dt = data['Ganna'] as String;
   bool isInstalled = await DeviceApps.isAppInstalled('com.ganna');
   if (isInstalled != false)
    {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: dt
     // arguments: {'authAccount': currentUserEmail"},
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

_openWynk (data) async
{String dt = data['Wynk'] as String;
  bool isInstalled = await DeviceApps.isAppInstalled('com.bsportal.music');
if (isInstalled != false)
  { 
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: dt
  ); await intent.launch();
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

_openJioSavaan (data) async
{String dt = data['JioSavaan'] as String;
  bool isInstalled = await DeviceApps.isAppInstalled('com.jio.media.jiobeats');
if (isInstalled != false)
 {
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: dt
  ); await intent.launch();
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

_openPrimeMusic (data) async
{String dt = data['PrimeMusic'] as String;
  bool isInstalled = await DeviceApps.isAppInstalled('com.amazon.mp3');
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


    



Widget buildResultCard(data) {
  
   List items = [Text(data['Ganna']),
                  IconButton(icon:Icon(Icons.audiotrack), 
                  onPressed: ()=> _openGanna(data)
                  ),

                 Text(data['Wynk']),
                  IconButton(icon:Icon(Icons.audiotrack), 
                  onPressed: ()=> _openWynk(data)
                  ), 

                  Text(data['JioSavaan']),
                  IconButton(icon:Icon(Icons.audiotrack), 
                  onPressed: ()=> _openJioSavaan(data)
                  ),

                   Text(data['PrimeMusic']),
                   IconButton(icon:Icon(Icons.audiotrack), 
                  onPressed: ()=> _openPrimeMusic(data)
                  )];

      return  ListView.builder(
           padding: EdgeInsets.only(top: 20),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
            return items[index];
           },
          );
        
        
      

}
     
     
 

}
