import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:connect_crowd/chat_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);
  static const String pageid='login_screen';



  @override

  State<login_screen> createState() => _login_screenState();
}


class _login_screenState extends State<login_screen> {
  //late SharedPreferences logindata;
  //late bool newuser;
  bool _saving=false;
  final _auth=FirebaseAuth.instance;
  late String email;
  late String password;
  var errormessage;
  bool clicked=false;
  TextEditingController username=TextEditingController();
  TextEditingController passtext=TextEditingController();
  // void initState() {
  //   // TODO: implement initState
  //   check_if_login();
  //   super.initState();
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    passtext.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Container(

        //constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(

        image: DecorationImage(
        image: AssetImage('images/design.png'), fit: BoxFit.fitWidth,alignment: Alignment.bottomLeft),
    color: Color(0xff4a5963),),
      child:Scaffold(
      backgroundColor: Colors.transparent,

      body: SingleChildScrollView(

        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80,),
            Center(child: Text('We Connect You',style: GoogleFonts.quicksand(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.white),)),
            SizedBox(height: 90,),
            Hero(
              tag: 'logo',
              child: Container(

                child:Image.asset('images/edited.png',fit: BoxFit.fitWidth,width: 334,height: 254,),
              ),
            ),
            SizedBox(height: 50.0),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: username,
                keyboardType: TextInputType.emailAddress,
                  onChanged: (value){
                  email=value;

                  },

                  style: const TextStyle(color: Colors.white),decoration: const InputDecoration(filled: true,fillColor: Colors.black,labelText:"Email Address",labelStyle:TextStyle(color: Colors.white),prefixIcon: Icon(Icons.email_outlined,color: Colors.white),

                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 3.0),borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),


                  focusedBorder: OutlineInputBorder(

                    borderSide:
                    BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )

              ),
                  cursorColor: Colors.red



              ),

            ),
      SizedBox(height: 10.0,),
       Padding(
    padding: EdgeInsets.all(8.0),
    child: TextField(
      controller: passtext,
      obscureText: true,
      onChanged: (value){
        password=value;
      },
      style: const TextStyle(color: Colors.white),decoration: const InputDecoration(filled:true,fillColor: Colors.black,labelText:"Password",labelStyle:TextStyle(color: Colors.white),prefixIcon: Icon(Icons.password_outlined,color: Colors.white),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 3.0),borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
      focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      )
    ),
      cursorColor: Colors.red,),
      ),
            SizedBox(height:40.0),
            clicked?CircularProgressIndicator():ElevatedButton(onPressed: () async {
              setState(() {
                clicked=true;
              });

              try {
                final user = await _auth.signInWithEmailAndPassword(
                    email: username.text, password: passtext.text);
                _saving=true;
                if(user!=null) {
                  final pref= await SharedPreferences.getInstance();
                  pref.setBool('isLoggedIn', true);



                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>chat_screen()), (route) => false);
                  //logindata.setBool('login', false);
                  //logindata.setString('email', email);
                  setState(() {
                    clicked:false;
                  });


                }
              } on FirebaseAuthException
              catch(e){
                AnimatedSnackBar.material(
                  e.message.toString(),
                  type: AnimatedSnackBarType.error,
                ).show(context);
                setState(() {
                  clicked=false;
                });





              }



            },child: Text('Login',style: GoogleFonts.quicksand(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 19),),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, //background color of button
                    side: BorderSide(width:1, color:Colors.black,), //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder( //to set border radius to button
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.only(right:50.0,left:50.0,top:20.0,bottom:20.0) //content padding inside button
                )

            ),




          ],
        ),
      ),
      )
    );
  }
  // void check_if_login() async {
  //   logindata = await SharedPreferences.getInstance();
  //
  //   newuser = (logindata.getBool('login') ?? true);
  //   if (newuser == false) {
  //     Navigator.pushNamed(context, chat_screen.id);
  //   }
  // }



}
