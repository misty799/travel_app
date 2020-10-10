import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/HomePages/newTrips/credentials.dart';
import 'package:travelapp/HomePages/newTrips/dateView.dart';
import 'package:travelapp/models/place.dart';
import 'package:travelapp/models/trip.dart';
class NewTripLocation extends StatefulWidget {
   NewTripLocation({Key key ,this.trip}):super(key:key);
    final Trip trip;
    @override
  State<StatefulWidget> createState() {
    return NewTripLocationState();
  }
}
class NewTripLocationState extends State<NewTripLocation>{


 String _heading;
 //List<SearchTrip> _placeLists;
  final List<SearchTrip> _suggestedList = [
    SearchTrip("New York", 320.00),
    SearchTrip("Austin", 250.00),
    SearchTrip("Boston", 290.00),
    SearchTrip("Florence", 300.00),
  SearchTrip("Washington D.C.", 190.00),
  ];
  void initState(){
    super.initState();
    _heading='suggestions';
   // _placeLists=_suggestedList;
  }
  Future<void> getLocationResults(String input) async {
    if(input.isEmpty){
      setState(() {
        _heading='suggestions';
      });
      return;
    }
    
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';

    String request = '$baseURL?input=$input&key=$PLACES_API_KEY&type=$type';
    Response response = await Dio().get(request);
    print(response);
    final predictions = response.data['predictions'];

      List<SearchTrip> _displayResults = [];

    for (var i=0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      double averageBudget = 200.0;
      _displayResults.add(SearchTrip(name, averageBudget));
    }

      setState(() {
        _heading='results';
      });
    

  }


  @override
  Widget build(BuildContext context) {
  //  TextEditingController _titleController = new TextEditingController();
   // _titleController.text = widget.trip.title;

    return Scaffold(
        appBar: AppBar(
          title: Text('Create Trip - Location'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
               // controller: _titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                
                ),
                onChanged: (text){
                  getLocationResults(text);

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(_heading),
            ),
            SizedBox(height:20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestedList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPlaceCard(context, index),
              ),
            ),
          ],
        )));
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "SelectedTrip-${_suggestedList[index].name}",
      transitionOnUserGestures: true,
      child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Card(
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(_suggestedList[index].name, style: TextStyle(fontSize: 30.0)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("Average Budget \$${_suggestedList[index].averageBudget.toStringAsFixed(2)}"),
                              ],
                            ),
                          ],
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
                onTap: () {
                  widget.trip.title = _suggestedList[index].name;
                  // that would need to be added to the Trip object
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewTripDateView(trip: widget.trip)),
                  );
                },
              ),
            ),

          ),
      ),
    );
  }

}