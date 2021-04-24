import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class ColorUserBloc extends Bloc{
  // ignore: missing_return
  Future initColor(int data){
    sink.add(data);
  }
  final _streamController=BehaviorSubject<int>();
  Sink<int> get sink=>_streamController.sink;
  Stream<int> get stream=>_streamController.stream;

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}