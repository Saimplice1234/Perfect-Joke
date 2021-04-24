import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:joke_app/ui/More.dart';
import 'package:joke_app/ui/Settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'Repository/Repository.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory=await getApplicationDocumentsDirectory();
  await Hive.init(directory.path);
  Repository.bloc.fetchJoke();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> emoji=[
    "😂","😍","🤣","😆"
  ];
  PageController _pageControl=PageController();
  // ignore: missing_return
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

  void addStreamColor() async{
    var box = await Hive.openBox('UserColor');
    if(box.containsKey('UserColorIndex')) {
      Repository.blocColor.initColor(box.get("UserColorIndex"));
    }else{
      Repository.blocColor.initColor(0);
    }
  }


  @override
  void initState(){
    super.initState();
    addStreamColor();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor:Colors.white,
     body:Column(
       children: [
         Container(
           margin:EdgeInsets.only(left:38),
             child:FadeIn(
                  delay:Duration(milliseconds:600),
                 child: Text("Change your mood 😂",style:GoogleFonts.poppins(fontSize:34,fontWeight:FontWeight.bold)))),
         SizedBox(height:19,),
         StreamBuilder(
           stream:Repository.bloc.stream,
           builder: (context, snapshot) {
             print(snapshot.connectionState);
             if(snapshot.hasData){
               return ElasticInDown(
                 child: Container(
                   height:365,
                   child:PageView.builder(
                     controller:_pageControl,
                     physics:BouncingScrollPhysics(),
                     scrollDirection:Axis.horizontal,
                     itemCount:snapshot.data.length,
                     itemBuilder: (BuildContext context, int index) {
                     return PhysicalModel(
                       elevation:23,
                       color:Colors.transparent,
                       shadowColor:Colors.transparent,
                       child: GestureDetector(
                         child:StreamBuilder(
                           stream:Repository.blocColor.stream,
                           builder: (BuildContext context, snapshotColor) {
                           return GestureDetector(
                             onTap:(){
                               Navigator.push(context,PageRouteBuilder(
                                   transitionDuration:Duration(milliseconds:400),
                                   pageBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                    return More(value:snapshot.data[index]["value"],indexColor:snapshotColor.data,);
                                }
                               ));
                             },
                             child: Hero(
                               tag:"jokeMore",
                               child: Container(
                                 margin:EdgeInsets.only(left:28,right:23,top:12,bottom:12),
                                 width:MediaQuery.of(context).size.width-80,
                                 height:365,
                                 decoration:BoxDecoration(
                                     color:getPefsColor(snapshotColor.data),
                                     borderRadius:BorderRadius.all(Radius.circular(8))
                                 ),
                                 child:Container(
                                     width:MediaQuery.of(context).size.width,
                                     height:MediaQuery.of(context).size.height-12,
                                     margin:EdgeInsets.only(left:12,right:12),
                                     child: Center(
                                         child:FadeIn(
                                           delay:Duration(milliseconds:500),
                                           child:Container(
                                             child:AutoSizeText(
                                                 snapshot.data[index]["value"].toString(),
                                                 textAlign:TextAlign.center,
                                                 maxLines:6,
                                                 maxFontSize:18,
                                                 minFontSize:18,
                                                 overflow:TextOverflow.ellipsis,
                                                 style:GoogleFonts.poppins(color:Colors.white,fontWeight:FontWeight.bold)
                                             ),
                                           ),
                                         )
                                     )
                                 ),
                               ),
                             ),
                           );
                         },
                         )
                       ),
                     );
                   },),
                 ),
               );
             }else{
               return Container(
                 height:315,
                 child:Center(
                   child:SpinKitWave(color:Colors.grey.withOpacity(0.3),size:20,),
                 ),
               );
             }
           }
         ),
         SizedBox(height:22,),
         FadeIn(
           delay:Duration(seconds:1),
           child: Container(
             height:10,
             child:StreamBuilder(
               stream: Repository.blocColor.stream,
               builder: (context, snapshot) {
                 return SmoothPageIndicator(
                 controller: _pageControl,
                 count:23,
                 axisDirection: Axis.horizontal,
                 effect:  SlideEffect(
                     spacing: 4.0,
                     radius:  4.0,
                     dotWidth:2.0,
                     dotHeight:2.0,
                     dotColor:  Colors.grey.withOpacity(0.2),
                     activeDotColor:getPefsColor(snapshot.data)
                 ),
            );
               }
             ),

           ),
         ),
         SizedBox(height:0,),
       ],
     ),
     appBar:AppBar(
       title:Container(
           padding:EdgeInsets.only(left:26),
           child: Text("Perfect Joke",style:GoogleFonts.poppins(color:Colors.grey,fontWeight:FontWeight.bold))),
       elevation:0.0,
       backgroundColor:Colors.white,
       actions: [
         GestureDetector(
             onTap:(){
               Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                 return SettingPage();
               }));
             },
             child: Icon(Ionicons.settings_outline,color:Colors.grey,size:18)),
         SizedBox(width:19)
       ],
     ),
   );
  }
  @override
  void dispose() {
    super.dispose();
    Repository.bloc.dispose();
  }
}
