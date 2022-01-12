import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restaurantapp/model/user_model.dart';
//import 'package:restaurantapp/screens/home-screen.dart';
//import 'login-screen.dart';
import 'Home_Screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({ Key? key }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  //our form key
  final _formKey = GlobalKey<FormState>();
  // editing controller
  final firstNameEditingConttroller = new TextEditingController();
  final secondNameEditingConttroller = new TextEditingController();
  final emailEditingConttroller = new TextEditingController();
  final passwordEditingConttroller = new TextEditingController();
  final confirmPasswordEditingConttroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    //first name field
final firstNameField = TextFormField(
  autofocus: false,
  controller: firstNameEditingConttroller,
  keyboardType: TextInputType.name,
  validator: (value) {
  RegExp regex = new RegExp(r'^.{6,}$');
    if (value!.isEmpty)
    {
      return ("First Name canmot be Empty");
    }
    if(!regex.hasMatch(value))
    {
      return("Please Enter Valid name(Min. 3 character");
    }
    return null;
  },
  onSaved: (value){
    firstNameEditingConttroller.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    prefixIcon: Icon(Icons.account_circle),
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    hintText: "First Name",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),);

 //second name field
final secondNameField = TextFormField(
  autofocus: false,
  controller: secondNameEditingConttroller,
  keyboardType: TextInputType.name,
  validator: (value) {
      if (value!.isEmpty)
    {
      return ("Second Name canmot be Empty");
    }
      return null;
        },
  onSaved: (value){
    secondNameEditingConttroller.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    prefixIcon: Icon(Icons.account_circle),
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    hintText: "Second Name",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),);
   //email field
final emailField = TextFormField(
  autofocus: false,
  controller: emailEditingConttroller,
  keyboardType: TextInputType.emailAddress,
 validator: (value) {
    if(value!.isEmpty){
     return ("Please Enter Your Email");
    }
    // reg expression for email validation
    if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
    {
      return ("Please Enter a valid email");
    }
    return null;

  },  onSaved: (value){
    emailEditingConttroller.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    prefixIcon: Icon(Icons.mail),
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    hintText: "Email",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),);
   //password field
final passwordField = TextFormField(
  autofocus: false,
  controller: passwordEditingConttroller,
  obscureText: true,

  validator: (value) {
    RegExp regex = new RegExp(r'^.{6,}$');
    if (value!.isEmpty)
    {
      return ("Password is required for login");
    }
    if(!regex.hasMatch(value))
    {
      return("Please Enter Valid Password(Min. 6 character");
    }
  },
  onSaved: (value){
    passwordEditingConttroller.text = value!;
  },
  textInputAction: TextInputAction.next,
  decoration: InputDecoration(
    prefixIcon: Icon(Icons.vpn_key),
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    hintText: "Password",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),);
   //confirm password field
final ConfirmPasswordField = TextFormField(
  autofocus: false,
  controller: confirmPasswordEditingConttroller,
  obscureText: true,
  validator: (value) {
    if(confirmPasswordEditingConttroller.text != passwordEditingConttroller.text){
      return "Password don't match";
    } 
    return null;
  },
  onSaved: (value){
    confirmPasswordEditingConttroller.text = value!;
  },
  textInputAction: TextInputAction.done,
  decoration: InputDecoration(
    prefixIcon: Icon(Icons.vpn_key),
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    hintText: "Confirm Password",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),);
  //signup button
  final signUpButton = Material(
  elevation: 5,
  borderRadius: BorderRadius.circular(30),
  color: Colors.redAccent,
  child: MaterialButton(
    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    minWidth: MediaQuery.of(context).size.width,
    onPressed: () {
      signup(emailEditingConttroller.text, passwordEditingConttroller.text);
    },
    child: Text(
      "signUp", 
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    )),
    );
  return Scaffold(
   backgroundColor: Colors.white,
   appBar: AppBar(
     backgroundColor: Colors.transparent,
     elevation: 0,
     leading: IconButton(
       icon: Icon(Icons.arrow_back, color:Colors.lightBlue),
        onPressed: (){
          // passing this root to our root
      Navigator.of(context).pop();
        },
       ),

   ),
   body: Center(
     child: SingleChildScrollView(
       child: Container(
         color: Colors.white,
         child: Padding(
           padding: const EdgeInsets.all(36.0),
           child: Form(
             key: _formKey,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               SizedBox(
                 height: 200,
                 child: Image.asset(
                   "assets/logo.jpg", 
                   fit: BoxFit.contain,
                   ), ),
                   SizedBox(height: 45),
                   firstNameField,
                   SizedBox(height: 20),
                   secondNameField,
                   SizedBox(height: 20),
                   emailField,
                   SizedBox(height: 20),
                   passwordField,
                   SizedBox(height: 20),
                   ConfirmPasswordField,
                   SizedBox(height: 20),
                   signUpButton,
                   SizedBox(height: 15), 
             ],
             ),
       ),
     ),
   ),
 )));
  }
  void signup(String email, String password) async
  {
    if(_formKey.currentState!.validate())
    {
     await _auth.createUserWithEmailAndPassword(email: email, password: password)
       .then((value) => {
         postDetailsToFirestore()
       }).catchError((e)
       {
         Fluttertoast.showToast(msg: e!.message);
       });
    }
  }

  postDetailsToFirestore() async
  {
    //calling our firestore
    //calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
   // writing all the values
   userModel.email = user!.email;
   userModel.uid = user.uid;
   userModel.firstName = firstNameEditingConttroller.text;
   userModel.secondName = secondNameEditingConttroller.text; 
  
  await firebaseFirestore
    .collection("users")
    .doc(user.uid)
    .set(userModel.toMap());
  Fluttertoast.showToast(msg: "Account created successfully :) ");

  Navigator.pushAndRemoveUntil(
    (context), 
    MaterialPageRoute(builder: (context) => Dashboard()),
   (route) => false);
  }
}