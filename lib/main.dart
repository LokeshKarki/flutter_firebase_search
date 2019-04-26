import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search/searchs.dart';
import 'package:search/searchLinksIntents.dart';
import 'package:search/contribute.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';
import 'package:device_apps/device_apps.dart';





void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.lightGreen,
        //brightness: Brightness.dark,
        backgroundColor: Colors.black,
        accentColor: Colors.green
        
      ),
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        "/homepage":(BuildContext context)=> MyApp(),
        "/linksearch":(BuildContext context)=> Intent("Link Search"),
        "/contributions":(BuildContext context)=> Contri("Contributions"),
      }

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
        if (element['songName'].startsWith(capitalizedValue)) {
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
        ), drawer:  Drawer(
        child: ListView(
          children: <Widget>[
             UserAccountsDrawerHeader(
              accountName:  Text("BeatsShare"),
              accountEmail:  Text("beatsshare07@gmail.com"),

              currentAccountPicture:  CircleAvatar(
                
                child: Text("BS"),
              ),
              
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  child: Text("LK"),
                  ),
                CircleAvatar(
                  child: Text("AP"),

                ),
              ],
              
            ),
            ListTile(
              title: Text("Home Page"),
              trailing:  Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/homepage");
              
              },
              ),
             ListTile(
              title: Text("Link Search"),
              trailing:  Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/linksearch");
              },
              ),

             ListTile(
              title: Text("Contributions"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/contributions");
                }
            ),

             Divider(color: Colors.black45,),

             ListTile(
              title:  Text("Close"),
              trailing:  Icon(Icons.close),
              onTap: ()=> Navigator.of(context).pop(),
            )
            
            
            
          ]
        ),
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
                     // Navigator.of(context).pop();
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
}
// Future<Null> initUniLinks() async {
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       String initialLink = await getInitialLink();
      


//       // Parse the link and warn the user, if it is not correct,
//       // but keep in mind it could be `null`.
//     } on PlatformException {
//       print("change the platform to Android");
//     }
  
// }
// linksearch(data)
// {
// String pm = data['PrimeMusic'] as String;
// String ga = data['Ganna'] as String;
// String wk = data['Wynk'] as String;
// String js = data['JioSavaan'] as String;

// String key;
// if (key == pm || key == ga|| key == wk||key == js )

// initiateSearch(Element);

// }


_openGanna (data) async
{
   String dt = data['gaanaUrl'] as String;
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
{String dt = data['wynkUrl'] as String;
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

_openSpotify (data) async
{String dt = data['spotifyUrl'] as String;
  bool isInstalled = await DeviceApps.isAppInstalled('com.spotify.music');
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

_openAppleMusic (data) async
{String dt = data['itunesUrl'] as String;
  bool isInstalled = await DeviceApps.isAppInstalled('com.apple.android.music');
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
    String singer = (data['singer1'] +', '+ data['singer2']+', '+ data['singer3']) as String;
   List items = [  Text(data['songName'], 
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20.0
                  ),
                  ),
                  Text(data['albumName'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontStyle:FontStyle.italic ,
                    fontSize: 15.0
                    
                  ),
                  ),
                  Text(singer,
                  style: TextStyle(
                    
                  ),
                  ),

                  Divider(color: Colors.lightGreen,),

                  Text('Ganna Link',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,   
                  ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(icon:Icon(Icons.audiotrack), 
                  onPressed: ()=> _openGanna(data)
                  ),
                  ),

                 Text('Wynk Link',
                 style: TextStyle(
                    fontWeight: FontWeight.w400,  
                  ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(icon:Icon(Icons.audiotrack), 
                    onPressed: ()=> _openWynk(data)
                  ),
                  ),
                  
                  Text('Spotify Link',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,   
                  ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(icon:Icon(Icons.audiotrack), 
                  onPressed: ()=> _openSpotify(data)
                  ),
                  ),
                  

                  Text('Apple Music Link',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,   
                  ),
                  ),
                   Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(icon:Icon(Icons.audiotrack), 
                  onPressed: ()=> _openAppleMusic(data)
                  ),
                  ),
                  ];


      return  ListView.builder(
           padding: EdgeInsets.only(top: 20),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
            return items[index];
           },
          );
        
        
}
     