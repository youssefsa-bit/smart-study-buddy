import 'package:dio/dio.dart';

class NetworkService{
  NetworkService._(){
    init();
  }
  //singleton
  static NetworkService? _instance;
  factory NetworkService(){
    _instance??=NetworkService._();
    return _instance!;
  }
  late Dio dio;
  void init(){
    dio=Dio(
      BaseOptions(
        baseUrl: "",
        followRedirects: false,
        validateStatus: (status){
          if(status!=null){
            if(status<=300){
              return true;
            }
            else if(status==401){
              return false;
            }
            else{
              return false;
            }
          }
          else{
            return false;
          }
        },
      ),
    );
  }
}