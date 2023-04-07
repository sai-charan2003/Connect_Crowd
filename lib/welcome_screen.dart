// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class welcome_screen extends StatefulWidget {
  const welcome_screen({Key? key}) : super(key: key);
  static const String pageid='welcome_screen';

  @override
  State<welcome_screen> createState() => _welcome_screenState();
}

class _welcome_screenState extends State<welcome_screen> with SingleTickerProviderStateMixin {
  @override
  late AnimationController controller;
  late Animation animation;
  @override
  List<MaterialColor> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

   TextStyle colorizeTextStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold
    //fontFamily: 'Horizon',
  );
  void initState() {
    // TODO: implement initState
    controller=AnimationController(vsync: this,duration: Duration(seconds: 1));
    //animation= CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation=ColorTween(begin: Colors.blue[300],end: Colors.white).animate(controller);



    controller.forward();

    controller.addListener(() { setState(() {
      animation.value;

    });});
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


      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 80,),

             Center(child: Text('We Connect You',style: GoogleFonts.quicksand(fontSize: 20,fontWeight: FontWeight.w900,color: Colors.white),)),
          SizedBox(height: 90,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Hero(
                tag: 'logo',
                child: Container(
                  alignment: Alignment.center,





                    child: Image.asset('images/edited.png',fit: BoxFit.fitWidth,width: 334,height: 254,),


                ),
              ),
              //SizedBox(width: 20.0,),
              AnimatedTextKit( animatedTexts: [
                ColorizeAnimatedText(
                '',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
                )
  ]

              ),
            ],
          ),
          SizedBox(height: 78.0,),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0),
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>login_screen()));

            }, child: Text('Login',style: GoogleFonts.quicksand(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 19),),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, //background color of button
                    side: BorderSide(width:3, color:Colors.black), //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder( //to set border radius to button
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.all(20) //content padding inside button
                )

            ),
          ),
          SizedBox(height: 50.0,),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0),
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>registration_screen()));

            }, child: Text('Register',style: GoogleFonts.quicksand(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 19),),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, //background color of button
                    side: BorderSide(width:3, color:Colors.black), //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder( //to set border radius to button
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.all(20) //content padding inside button
                )

            ),
          )

      ],)
      )
    );
  }
}
