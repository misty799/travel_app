import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelapp/models/place.dart';
import 'package:travelapp/services/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isAdmin;
  User user=new User("");
  TextEditingController _userController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
      Container(
        width: MediaQuery.of(context).size.width,
        
      child: Column(
        children:<Widget>[
          FutureBuilder(
            future: Provider.of(context).getCurrentUser(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return displayUserInfo(context, snapshot);
              }
              else{
                return CircularProgressIndicator();
              }
            },
          )
        ]
      ),
      
    ));
  }
  Widget displayUserInfo(context,snapshot){
    final authData=snapshot.data;

    return Column(
      children:<Widget>[
        Padding(padding: EdgeInsets.all(8.0),
        child:
               Text("Name:${authData.displayName}",style: TextStyle(fontSize:20.0),)

        ),
        Padding(padding: EdgeInsets.all(8.0),
        child:
               Text("Email:${authData.email}",style: TextStyle(fontSize:20.0),)

        ),
         Padding(padding: EdgeInsets.all(8.0),
        child:
               Text(" Created:${DateFormat('MM/dd/yyyy').format(authData.metadata.creationTime)}",style: TextStyle(fontSize:20.0),)

        ),
        FutureBuilder(future: getProfileData(),
        builder: (context, snapshot) {

           if(snapshot.connectionState==ConnectionState.done){
                _userController.text=user.homeCountry;
                isAdmin=user.admin??false;
              }
              return 
                Padding(padding: EdgeInsets.all(8.0),
                child:
                Column(
                  children:<Widget>[
                      Text("HomeCountry:${user.homeCountry}",style: TextStyle(fontSize:20.0),),
                      adminFeature()

                  ]
                )
             
              

         ); }),
        
        showSignOut(context, authData.isAnonymous),
        RaisedButton(
          child:Text('Edit User'),
          onPressed:(){
            userEdit(context);
          }
        )

      ]
    );
  }
  getProfileData()async{
    final uid=await Provider.of(context).getUserId();
    await Firestore.instance.collection('userData').document(uid).get().then((value){
    user.homeCountry=value.data['homeCountry'];
    user.admin=value.data['admin'];
    
    });
  
    

  }
  Widget showSignOut(context,bool isAnonymous){
   if(isAnonymous==true){
     return RaisedButton(child: Text('SignIn to save your data'),
     onPressed: (){
       Navigator.of(context).pushReplacementNamed('/signUp');

     },);
   }
   else{
     return RaisedButton(
       child:Text('SignOut'),
       onPressed:()async{
         try{
        await  Provider.of(context).signOut();
         }
         catch(e){
           print(e);
         }
       }
     );
   }
  }
  Widget adminFeature(){
    if(isAdmin==true){
    return  Text('You are an Admin');
    }
    else{
     return Container();
    }
  }
 void userEdit(BuildContext context){
   showModalBottomSheet(context: context, builder: (BuildContext bc){
     return Container(
       height:MediaQuery.of(context).size.height*.60,
       child:Padding(

       padding: EdgeInsets.only(left:15.0,top:15.0),
       child:Column(
         children:<Widget>[
           Row(children: <Widget>[
             Text('update Profile'),
             Spacer(),
             IconButton(icon: Icon(Icons.cancel),
             color: Colors.orange,
             iconSize: 20.0,
             onPressed: (){
               Navigator.of(context).pop();
             },)
           ],),
           Row(
             children:<Widget>[
               Expanded(child: 
               Padding(padding: EdgeInsets.only(right:15.0),
               child: TextField(
                 decoration:InputDecoration(helperText: 'homeCountry'),
                 controller: _userController,
               ),
               ))

             ]
           ),
            Row(
             children:<Widget>[
               RaisedButton(
                 child:Text('save'),
                 color: Colors.green,
                 textColor: Colors.white,
                 onPressed: ()async{
                   user.homeCountry=_userController.text;
                   setState(() {
                     user.homeCountry=_userController.text;
                   });
                   final uid=await Provider.of(context).getUserId();
                 await  Firestore.instance.collection('userData').document(uid).
            setData(user.toJson());
                   Navigator.of(context).pop();
                 },
               )

             ]
           )
         ]
       )
     ));
   });

 }
}