import 'package:animate_do/animate_do.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:joke_app/Repository/Repository.dart';
// ignore: must_be_immutable
class More extends StatefulWidget {
  String tagHero;
  String value;
  int indexColor;
  More({this.value,this.indexColor});
  @override
  _MoreState createState() => _MoreState();
}
Color getPefsColor(int indexPrefsColor){
  if(indexPrefsColor == 0){
    return Colors.black;
  }else if(indexPrefsColor == 1){
    return Colors.deepPurpleAccent;
  }else if(indexPrefsColor == 2){
    return Colors.deepPurple;
  }else if(indexPrefsColor == 3){
    return  Colors.blue;
  }else if(indexPrefsColor == 4){
    return Colors.blueAccent;
  }else if(indexPrefsColor == 5){
    return Colors.indigo;
  }else if(indexPrefsColor == 6){
    return Colors.indigoAccent;
  }else if(indexPrefsColor == 7){
    return Colors.purpleAccent;
  }else if(indexPrefsColor == 8){
    return Colors.pink;
  }else if(indexPrefsColor == 9){
    return Colors.redAccent;
  }else if(indexPrefsColor == 10){
    return Colors.orange;
  }else if(indexPrefsColor == 11){
    return Colors.amberAccent;
  }
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:"jokeMore",
      child: Scaffold(
        extendBodyBehindAppBar:false,
        backgroundColor:getPefsColor(widget.indexColor),
        body:SingleChildScrollView(
          child:Center(
            child:ElasticInDown(
              delay:Duration(seconds:1),
              child: Container(
                width:MediaQuery.of(context).size.width,
                margin:EdgeInsets.only(left:12,right:12,top:MediaQuery.of(context).size.height/2/2-40),
                child:Text(widget.value,textAlign:TextAlign.center,style:GoogleFonts.poppins(
                  fontSize:34,fontWeight:FontWeight.bold,color:Colors.white,
                ),),
              ),
            ),
          )
        ),
        appBar:AppBar(
          elevation:0.0,
          backgroundColor:Colors.transparent,
          leading:GestureDetector(
              onTap:(){
                Navigator.pop(context);
              },
              child: Icon(Ionicons.close,color:Colors.white)),
          actions: [
            GestureDetector(
                onTap:(){
                  FlutterClipboard.copy(widget.value).then(( value ){
                    Flushbar(
                      backgroundColor:getPefsColor(widget.indexColor),
                      margin: EdgeInsets.only(left:12,right:12,bottom:30),
                      message:  "Copied !",
                      duration:  Duration(milliseconds:900),
                      borderRadius: BorderRadius.circular(8),
                    )..show(context);
                  });
                },
                child: Icon(Ionicons.copy_outline,color:Colors.white,)),
            SizedBox(width:23,),
          ],
        ),
      ),
    );
  }
}
