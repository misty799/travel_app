
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/HomePages/newTrips/detailTripView.dart';
import 'package:travelapp/models/trip.dart';
import 'package:travelapp/services/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUserTrips(context),
      builder:(context,snapshot){ 
        if(!snapshot.hasData)
        return Text('Loading');
    return ListView.builder(
      itemCount:snapshot.data.documents.length,
      itemBuilder:(BuildContext context,int index){
        return buildCard(context, snapshot.data.documents[index]);
       
      }
    );
      }
    );
  }
  Stream<QuerySnapshot> getUserTrips(BuildContext context)async*{
    final uid=await Provider.of(context).getUserId();
    yield* Firestore.instance.collection('userData').document(uid).collection('trips').snapshots();

  }
  Widget buildCard(BuildContext context , DocumentSnapshot document){
  final  trip=Trip.fromSnapshot(document);
  final tripType=trip.types();
     return Container(
          child:Card(
            child:InkWell(
            child:
            Padding(padding: EdgeInsets.all(16.0),
            child:Column(children: <Widget>[
               Padding(padding: EdgeInsets.only(top:4.0,bottom:8.0),
               child:
              Row(
                 children:<Widget>[
                    Text(trip.title,style: TextStyle(
                      fontSize: 30.0
                    ),),
                    Spacer()

                 ]
                
              ),
               ),
                Padding(padding: EdgeInsets.only(top:4.0,bottom:80.0),
                child:
                Row(
                 children:<Widget>[
             Text('${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()}-${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}'),
             Spacer()
                

                 ]
                )
              ),
               Padding(padding: EdgeInsets.only(bottom:8.0,top:8.0),
               child:
               Row(

                 children:<Widget>[
                    Text("\$${(trip.budget==null)?"n/a":trip.budget.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 35.0),),

                    
                    Spacer(),
                   ( tripType.containsKey(trip.travelType))?tripType[trip.travelType]:tripType['others']

                 ]
               ))
           

            ],)
          ),
          onTap:(){
            Navigator.push(context, MaterialPageRoute(builder:(context){
              return DetailTripView(trip: trip,);
            } ));
          }
        )));

  }
}


