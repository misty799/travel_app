import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/services/provider.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}
enum FormStatus{
  Login,
  Register
}

class _SignUpViewState extends State<SignUpView> {
  final formkey=GlobalKey<FormState>();
  FormStatus formStatus=FormStatus.Login;
  String _name;
  String _email;
  String _password;
  String _error;
  bool validateAndSave(){
    final form=formkey.currentState;
 if(form.validate())
 {
   form.save();
   return true;
 }
else
{
  return false;
}
  }
  Future<void> validateAndSubmit() async {
   
    if(validateAndSave()){
      try{
       final auth=Provider.of(context);
      if(formStatus==FormStatus.Register){
        await auth.createUserWithEmailAndPassword(_name, _email, _password);
        Navigator.of(context).pushReplacementNamed('/home');
       
        
      }
      else{
       String user=await auth.signInWithEmailAndPassword(_email, _password);
       print(user);
        Navigator.of(context).pushReplacementNamed('/home');
       
      }
      }
      catch(e){
        setState(() {
          _error=e.message;
        });
        print(e);
      }

    }

  }
  void moveToLogin(){
    setState(() {
      formStatus=FormStatus.Login;
      
    });

  }
  void moveToRegister(){
    setState(() {
      formStatus=FormStatus.Register;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:Text('SignUp')),
    body: Container(child: SafeArea(child:
    Column(
      children:<Widget>[
        showAlert(),
          Padding(
      padding:EdgeInsets.all(10.0),
      child:
    
      Form(
        key: formkey,
        child:
       Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
        children:buildInputs()
      ),),),])
      
      
    
     )) );
  }
  List< Widget> buildInputs(){
  
      if(formStatus==FormStatus.Login){
      return[
     
         
            TextFormField(decoration: InputDecoration(
            hintText: 'enter your email'
          ),
          validator: (value) => value.isEmpty?'email cant be empty':null,
          onSaved: (value) => _email=value,
        
        
          
          ),
            TextFormField(decoration: InputDecoration(
            hintText: 'enter your password'
          ),
            validator: (value) => value.isEmpty?'Password cant be empty':null,
          onSaved: (value) => _password=value,
        
          ),
          RaisedButton(
            child:Text('Login'),
            onPressed:validateAndSubmit ),
          FlatButton(child: Text('dont have an account?Register'),
          onPressed: moveToRegister,)
        ];}
        else
        {
         return[

        
             TextFormField(decoration: InputDecoration(
            hintText: 'enter your name'
          ),
          validator: (value) => value.isEmpty?'name cant be empty':null,
          onSaved: (value) => _name=value,),
        
         
            TextFormField(decoration: InputDecoration(
            hintText: 'enter your email'
          ),
          validator: (value) => value.isEmpty?'email cant be empty':null,
          onSaved: (value) => _email=value,
        
        
          
          ),
            TextFormField(decoration: InputDecoration(
            hintText: 'enter your password'
          ),
            validator: (value) => value.isEmpty?'Password cant be empty':null,
          onSaved: (value) => _password=value,
        
          ),
          RaisedButton(
            child:Text('Register'),
            onPressed: validateAndSubmit),
          FlatButton(child: Text(' have an account?Login'),
          onPressed: moveToLogin
          )
        ];
        }

  }
  Widget showAlert(){
    if(_error!=null){
      return Container(
        color:Colors.amberAccent,
        width:double.infinity,
        padding:EdgeInsets.all(8.0),
        child:Row(children: <Widget>[
          Padding(padding: EdgeInsets.only(right:8.0),
          child:
          Icon(Icons.error_outline),),
          Expanded(child: 
          AutoSizeText(
            _error,
            maxLines:3
          ),),
          Padding(padding: EdgeInsets.only(left:8.0),
          child:
          IconButton(icon: Icon(Icons.close), onPressed:(){
            setState(() {
              _error=null;
            });
          }))
          

        ],)

      );

    }
    return SizedBox(height: 0.0,);

  }
}