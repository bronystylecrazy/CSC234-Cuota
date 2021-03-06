import 'package:dio/dio.dart';

class DioManager {
  static late Dio dio;
  static const baseUrl = 'https://cuota.devsirawit.com';
  static void register() async {
    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    try {
      dio = Dio(options);
    } catch (e) {
      print(e.toString());
    }
  }
}
