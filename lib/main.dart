import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/Home.dart';
import 'package:travelapp/HomePages/HomeView.dart';
import 'package:travelapp/HomePages/firstView.dart';
import 'package:travelapp/HomePages/signupview.dart';
import 'package:travelapp/services/provider.dart';

import 'services/authservice.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth:Auth(),
      child:
    MaterialApp(
      debugShowCheckedModeBanner:false ,
      title:'TravelApp',
      theme:ThemeData(
        primarySwatch:Colors.blue,
      
      ),
      home: HomeController()
      
      ,
       routes: <String, WidgetBuilder> {
        '/signUp': (BuildContext context) => SignUpView(),
        '/home': (BuildContext context) => HomeController(),
        '/homeView':(BuildContext context)=>HomeView()
    
    
  }
    )
  
    );
  }

    
}
class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final  auth=Provider.of(context);

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder:( context , snapshot){
        if(snapshot.connectionState==ConnectionState.active){
          final bool signedIn=snapshot.hasData;
          return signedIn?Home():FirstView();
        }
        return CircularProgressIndicator();


      }
    );
  }
}
