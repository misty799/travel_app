import 'package:flutter/material.dart';
import 'package:travelapp/HomePages/HomeView.dart';
import 'package:travelapp/HomePages/newTrips/locationView.dart';
import 'package:travelapp/HomePages/profileview.dart';
import 'package:travelapp/models/trip.dart';
import 'package:travelapp/pages.dart';
import 'package:travelapp/services/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex=0;
  final List<Widget> _children=[
    HomeView(),
    ExplorePage(),
     ProfileView()
  ]
  ;
  void onTapped(int index){
    setState(() {
_currentIndex=index;
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
   //  final newTrip=new Trip(null,null,null,null,null,null);
    return Scaffold(
      appBar: AppBar(
        title:Text('Travel Budget App'),
    
              actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>NewTripLocation(trip:Trip(null, null, null,null,null,null),)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () async {
              try {
                var auth = Provider.of(context);
                await auth.signOut();
                print("Signed Out!");
              } catch (e) {
                print (e);
              }
            },
          ),
        
          
        ],),
      

    

      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex:_currentIndex,
        items:[
          BottomNavigationBarItem(
            icon:Icon(Icons.home),
            title: Text('Home')
          ),
          
           BottomNavigationBarItem(
            icon:Icon(Icons.explore),
            title: Text('Explore')
          ),
           BottomNavigationBarItem(
            icon:Icon(Icons.account_circle),
            title: Text('Profile')
          )
        ]
      ),
      

      
    );
  }
}