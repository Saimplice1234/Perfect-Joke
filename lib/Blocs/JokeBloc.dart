import 'dart:async';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class JokeBloc extends Bloc{

  Future fetchJoke() async{
    List<dynamic> data=[];
    try {
      for(var i=0;i<23;i++){
        var response = await Dio().get("https://api.chucknorris.io/jokes/random");
        data.add(response.data);
        print(data);
        sink.add(data);
        Dio().close();
      }
    } catch (e) {
      print(e);
    }
  }
  final _streamController=BehaviorSubject<List<dynamic>>();
  Sink<List<dynamic>> get sink=>_streamController.sink;
  Stream<List<dynamic>> get stream=>_streamController.stream;

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}