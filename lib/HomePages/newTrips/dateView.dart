import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/HomePages/newTrips/budgetView.dart';
import 'package:travelapp/models/trip.dart';
class NewTripDateView extends StatefulWidget {
    NewTripDateView({this.trip});
  final Trip trip;
  @override
  _NewTripDateViewState createState() => _NewTripDateViewState();
}

class _NewTripDateViewState extends State<NewTripDateView> {
  DateTime _startDate=DateTime.now();
  DateTime _endDate=DateTime.now().add(Duration(days:15));
  Future displayDatePicker(BuildContext context)async{
  
        

  }
 
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title:Text('create Trip-Date')
      ),
      body: Center(
        child:

      
      Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children:<Widget>[
          buildCardDetails(context,widget.trip),
          Spacer(),
          Text('Location:${widget.trip.title}'),
          RaisedButton(
            child:Text('Select Dates'),
            onPressed:(){}
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:<Widget>[
         Text('StartDate :${DateFormat('dd/MM/yy').format(_startDate)}'),
         Text('EndDate :${DateFormat('dd/MM/yy').format(_endDate)}'),

            ]
          ),

          RaisedButton(
            child:Text('continue'),
            onPressed: (){
             widget. trip.startDate=_startDate;
              widget.trip.endDate=_endDate;
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewTripBudgetView(trip:widget.trip,))
              );

            }
          ),
          Spacer()])
      
    ));
  }
  Widget buildCardDetails(BuildContext context,Trip trip){
     return Hero(
      tag: "SelectedTrip-${trip.title}",
      transitionOnUserGestures: true,
      child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: SingleChildScrollView(child:
            Card(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top:16.0,left: 16.0,bottom: 16.0),
                        child: Column(
                          children:<Widget>[
                            Row(children: <Widget>[
                             Text(trip.title,style:TextStyle(fontSize: 30.0))
                            ],),
                             Row(children: <Widget>[
                              Text("Average Budget-Not set up Yet")
                            ],),
                             Row(children: <Widget>[
                              Text("Trip Dates")
                            ],)
                            , Row(children: <Widget>[
                              Text("Trip Budget")
                            ],),
                             Row(children: <Widget>[
                              Text("Trip Type")
                            ],)

                          ]
                        ),
                        
                      ),
                    ),

                    Column(
                      children: <Widget>[
                        Placeholder(
                          fallbackHeight: 80,
                          fallbackWidth: 80,
                        ),
                      ],
                    )
                  ],
                ),
              
                
              ),
            ),

          ),
      
     ));
  }

  }
