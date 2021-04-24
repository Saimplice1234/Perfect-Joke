import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:joke_app/Repository/Repository.dart';
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Color> data=[
    Colors.black,
    Colors.deepPurpleAccent,
    Colors.deepPurple,
    Colors.blue,
    Colors.blueAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.purpleAccent,
    Colors.pink,
    Colors.redAccent,
    Colors.orange,
    Colors.amberAccent
  ];
  int _currentIndex;

  @override
  void initState(){
    super.initState();
    getIndexColor();
  }
  void getIndexColor() async{
    var box = await Hive.openBox('UserColor');
    if(box.containsKey('UserColorIndex')) {
      setState(() {
        _currentIndex = box.get("UserColorIndex");
      });
    }else{
      box.put("UserColorIndex",0);
      setState(() {
        _currentIndex = box.get("UserColorIndex");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        physics:NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height:80),
            Row(
              children: [
                SizedBox(width:19),
                Container(
                    child:ElasticInDown(
                        delay:Duration(milliseconds:200),
                        child: Text("Settings 😂",style:GoogleFonts.poppins(fontSize:34,fontWeight:FontWeight.bold)))),
              ],
            ),
            Row(
             children: [
               SizedBox(width:19),
               Text("Select your favorite color",style:GoogleFonts.poppins())
             ],
           ),
            Container(
              height:500,
              margin:EdgeInsets.all(12),
              child:AnimationLimiter(
                child: GridView.builder(
                  physics:NeverScrollableScrollPhysics(),
                  itemCount:12,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,crossAxisSpacing:19,mainAxisSpacing:19), itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredGrid(
                        columnCount:3,
                        duration: const Duration(milliseconds:475),
                        position:index,
                        child:ScaleAnimation(
                          child:GestureDetector(
                            onTap:() async{
                              setState((){
                                _currentIndex=index;
                              });
                              var box = await Hive.openBox('UserColor');
                              box.put('UserColorIndex',_currentIndex);
                              Repository.blocColor.initColor(box.get("UserColorIndex"));
                            },
                            child: AnimatedContainer(
                              duration:Duration(seconds:1),
                              decoration:BoxDecoration(
                                  color:data[index],
                                  borderRadius:BorderRadius.all(Radius.circular(5))
                              ),
                              child:_currentIndex == index?Icon(Icons.check,color:Colors.white):Text("")
                            ),
                          ),
                        )
                    );
                },
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
