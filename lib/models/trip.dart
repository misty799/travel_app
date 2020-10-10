import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Trip{
 String title;
  DateTime startDate;
   DateTime endDate;double budget;
String travelType;
Map budgetTypes;
String notes;
String documentId;

  Trip( this.title,this.startDate,this.endDate,this.budget,this.travelType,this.budgetTypes);
  Map<String, dynamic> toJson()=>{
    'title':title,
    'startDate':startDate,
    'endDate':endDate,
    'budget':budget,
    'budgetTypes':budgetTypes,
    'travelType':travelType


  };
  Trip.fromSnapshot(DocumentSnapshot snapshot):
  title=snapshot['title'],
  startDate=snapshot['startDate'].toDate(),
   endDate=snapshot['endDate'].toDate(),
   budget=snapshot['budget'],
   budgetTypes=snapshot['budgetTypes'],
   travelType=snapshot['travelType'],
   notes=snapshot['notes'],
   documentId=snapshot.documentID;
  Map<String ,Icon> types()=>{
    'car':Icon(Icons.directions_car,size: 50,),
     'bus':Icon(Icons.directions_bus,size: 50,),
      'train':Icon(Icons.train,size: 50,),
       'plane':Icon(Icons.airplanemode_active,size: 50,),
        'ship':Icon(Icons.directions_boat,size: 50,),
         'others':Icon(Icons.directions,size: 50,),

  

  };

}
