


import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/models/trip.dart';
import 'package:travelapp/services/provider.dart';

import 'editNoteView.dart';
class DetailTripView extends StatefulWidget {
   DetailTripView({this.trip});
  final Trip trip;
  @override
  _DetailTripViewState createState() => _DetailTripViewState();
}

class _DetailTripViewState extends State<DetailTripView> {
 
 TextEditingController _budgetController=new TextEditingController();
 var _budget;
 void initState(){
   super.initState();
   _budgetController.text=widget.trip.budget.toStringAsExponential(0);
   _budget=widget.trip.budget.floor();
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('Trip Details'),
              backgroundColor: Colors.green,
              expandedHeight: 350.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Icon(Icons.person),
              ),
              actions: <Widget>[
                IconButton(icon:Icon(Icons.settings,size: 30.0,color: Colors.white,) ,
                padding: EdgeInsets.only(right:15.0)
                , onPressed: (){
                  tripEditModalBottomSheet(context);

                })
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                tripDetails(),
                totalBudgetCard(),
                daysOutCard(),
                notesCard(context),
                Container(
                  height: 200,
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  // DAYS TILL TRIP CARD
  Widget daysOutCard() {
    return Card(
      color: Colors.amberAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("${getDaysUntilTrip()}", style: TextStyle(fontSize: 75)),
            Text("days until your trip", style: TextStyle(fontSize: 25))
          ],
        ),
      ),
    );
  }

  // TRIP DETAILS
  Widget tripDetails() {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.trip.title,
                  style: TextStyle(fontSize: 30, color: Colors.green[900]),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                    "${DateFormat('MM/dd/yyyy').format(widget.trip.startDate).toString()} - ${DateFormat('MM/dd/yyyy').format(widget.trip.endDate).toString()}"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // BUDGET CARD
  Widget totalBudgetCard() {
    return Card(
      color: Colors.blue,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Daily Budget",
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: AutoSizeText(
                    "\$$_budget",
                    style: TextStyle(fontSize: 100),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.blue[900],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Text(
                      "\$${widget.trip.budget.floor() * getTotalTripDays()} total",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // NOTES CARD
  Widget notesCard(context) {
    return Hero(
      tag: "TripNotes-${widget.trip.title}",
      transitionOnUserGestures: true,
      child: Card(
        color: Colors.deepPurpleAccent,
        child: InkWell(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    Text("Trip Notes",
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: setNoteText(),
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditNoteView(trip: widget.trip)));
          },
        ),
      ),
    );
  }

  List<Widget> setNoteText() {
    if (widget.trip.notes == null) {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(Icons.add_circle_outline, color: Colors.grey[300]),
        ),
        Text("Click To Add Notes", style: TextStyle(color: Colors.grey[300])),
      ];
    } else {
      return [Text(widget.trip.notes, style: TextStyle(color: Colors.grey[300]))];
    }
  }

  int getTotalTripDays() {
    return widget.trip.endDate.difference(widget.trip.startDate).inDays;
  }

  int getDaysUntilTrip() {
    int diff =widget. trip.startDate.difference(DateTime.now()).inDays;
    if (diff < 0) {
      diff = 0;
    }
    return diff;
  }
  void tripEditModalBottomSheet(context){
  showModalBottomSheet(context: context,
     builder: (BuildContext bc){
      return Container(
        height: MediaQuery.of(context).size.height*0.60,
        child: Padding(
          padding:EdgeInsets.only(left:8.0,right:8.0),
          child:Column(
            children:<Widget>[
              Row(
                children:<Widget>[
                  Text('Edit Trip'),
                  Spacer(),
                  IconButton(
                    icon:Icon(Icons.cancel,color:Colors.orange,size:25.0),
                    onPressed:(){
                      Navigator.of(context).pop();
                    }
                  )
                ]
              ),
              Row(children: <Widget>[
                 Text(
                  widget.trip.title,
                  style: TextStyle(fontSize: 30, color: Colors.green[900]),
                ),
                
              ],),
               Row(children: <Widget>[
                 Expanded(child: generateTextField(_budgetController,'Budget' ),)
               ]),
               Row(
                 mainAxisAlignment:MainAxisAlignment.center,
                 children:<Widget>[
                   RaisedButton(child: Text('submit'),
                   color: Colors.deepPurple,
                   textColor: Colors.white,
                  
                   onPressed: ()async{
                    widget.trip.budget=double.parse(_budgetController.text);
                    setState(() {
                      _budget=widget.trip.budget.floor();
                    });
                    await updateTrip(context);
                     Navigator.of(context).pop();

                   },)

                 ]
               ),
                 Row(
                 mainAxisAlignment:MainAxisAlignment.center,
                 children:<Widget>[
                   RaisedButton(child: Text('delete'),
                   color: Colors.deepPurple,
                   textColor: Colors.white,
                  
                   onPressed: ()async{
                  
                    await deleteTrip(context);
                     Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);

                   },)])

            ]
          )
        )
        

      );
     }


  );}
  Future updateTrip(context) async {
    var uid=await Provider.of(context).getUserId();
    final doc=Firestore.instance.collection('userData').document(uid).collection('trips').
    document(widget.trip.documentId);
    return await doc.setData(widget.trip.toJson());}

    
Future deleteTrip(context) async {
    var uid=await Provider.of(context).getUserId();
    final doc=Firestore.instance.collection('userData').document(uid).collection('trips').
    document(widget.trip.documentId);
    return await doc.delete();

    


  }
  Widget generateTextField(controller, helperText) {
    Widget textField = Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextField(
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.attach_money),
          helperText: helperText,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        autofocus: true,
      ),
    );
    return textField;
  }
}



 