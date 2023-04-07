import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fluttertoast/fluttertoast.dart';

class registration_screen extends StatefulWidget {
  const registration_screen({Key? key}) : super(key: key);
  static const String pageid='registration_screen';

  @override
  State<registration_screen> createState() => _registration_screenState();
}

class _registration_screenState extends State<registration_screen> {
  bool _saving=false;
  late var errormessage;


  final auth=FirebaseAuth.instance;
  late String email;
  late String password;
  bool clicked=false;
  @override
  Widget build(BuildContext context) {
    return
      Container(

        //constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(

        image: DecorationImage(
        image: AssetImage('images/design.png'), fit: BoxFit.fitWidth,alignment: Alignment.bottomLeft),
    color: Color(0xff4a5963),),
      child:Scaffold(
      backgroundColor: Colors.transparent,
      body:
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 80,),
              Center(child: Text('We Connect You',style: GoogleFonts.quicksand(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.white),)),
              SizedBox(height: 90,),
              Hero(
                tag: 'logo',
                child: Container(
                  child:Image.asset('images/edited.png',fit: BoxFit.fitWidth,width: 334,height: 254,),



                ),
              ),
              SizedBox(height:50.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value){
                    email=value;

                  },
                    style: TextStyle(color: Colors.white),decoration: InputDecoration(filled:true,fillColor: Colors.black,labelText:"Email Address",labelStyle:TextStyle(color: Colors.white),prefixIcon: Icon(Icons.email_outlined,color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color:Colors.black,width:3.0)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color:Colors.black,width: 3.0 ))

                ) ),
              ),
              SizedBox(height: 10.0,),
              Padding(padding: EdgeInsets.all(8.0),
              child: TextField(

                onChanged: (value){
                  password=value;
                },
                obscureText: true,
                  style: TextStyle(color: Colors.white),decoration: InputDecoration(filled:true,fillColor:Colors.black,labelText:"Password",labelStyle:TextStyle(color: Colors.white),prefixIcon: Icon(Icons.password_outlined,color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color:Colors.black,width:3.0)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color:Colors.black,width: 3.0 ))

              ) ),),

              SizedBox(height:40.0),
              clicked?CircularProgressIndicator():ElevatedButton(onPressed: () async {
                setState(() {
                  _saving=true;
                  clicked=true;
                });
                try{
                  final newuser=await auth.createUserWithEmailAndPassword(email: email, password: password);
                  if(newuser!=null){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>chat_screen()), (route) => false);
                  }
                }on FirebaseAuthException
                catch(e){
                  AnimatedSnackBar.material(
                    e.message.toString(),
                    type: AnimatedSnackBarType.error,
                  ).show(context);
                  setState(() {
                    clicked=false;
                  });

                }


              },



                child: Text('Register'),style: ElevatedButton.styleFrom(
                      primary: Colors.black, //background color of button
                      side: BorderSide(width:1, color:Colors.black,), //border width and color
                      elevation: 3, //elevation of button
                      shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: EdgeInsets.only(right:50.0,left:50.0,top:20.0,bottom:20.0) //content padding inside button
                  )


              )

            ],
          ),
        )
      ));
  }
}
