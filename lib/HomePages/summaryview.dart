import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/models/trip.dart';
import 'package:travelapp/services/provider.dart';
class NewTripSummaryView extends StatelessWidget {
   NewTripSummaryView({Key key ,this.trip}):super(key:key);
  final Trip trip;
 

  @override
  
  Widget build(BuildContext context) {
     final tripTypes=trip.types();
     var tripKeys=tripTypes.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title:Text('Trip-summary')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Text('finish'),
          Text('location:${trip.title}'),
          Text('startDate:${trip.startDate}'),
          Text('endDate:${trip.endDate}'),
          Text('TotalBudget:${trip.budget}'),
          Expanded(
          child:
          GridView.count(crossAxisCount:3,
          scrollDirection: Axis.vertical,
          primary: false,
          children:List.generate(tripTypes.length, (index) 
          {
        return FlatButton(child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            tripTypes[tripKeys[index]],
            Text(tripKeys[index])

          ]
        ),
        onPressed: () async{
          trip.travelType=tripKeys[index];
          final uid=await Provider.of(context).getUserId();
            await  Firestore.instance.collection('userData').document(uid).collection('trips').
            add(trip.toJson());
             Navigator.of(context).popUntil((route) => route.isFirst);
                      

              
        },);
           } )

          )),
         
        
          
        ]
      ),
      
    );
  }
}