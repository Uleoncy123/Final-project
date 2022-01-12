import 'package:flutter/material.dart';  
  
// void main() { runApp(MyApp()); }  
  
class welcome extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
        theme: ThemeData(  
          primarySwatch: Colors.green,  
        ),  
        home: MyTextPage()  
    );  
  }  
}  
class MyTextPage extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      
    
        
      body: Center(  
          child:Text("Welcome to the Restaurant application "
          'Excellent Indian restaurant under a large wooden awning, with very successful decorations. The cuisine is Indian down to the last detail, including the dishes and the waiters. The service is courteous, efficient and professional. Lovers of Indian cuisine will find authentic flavors here. Large choice of vegetarian dishes. The curries are delicious, the tandoori chicken uncontrollable. The settings for birthday cakes are not lacking in kitsch. An address that maintains a constant reputation over time.')  
      ),  
    );  
  }  
}  