import 'package:dio/dio.dart';
import 'package:pagination_vs_sms_fill/data/models/tendr_model.dart';


class ApiService {
  static Future<Tendr> getOrdersList() async {
    Dio dio = Dio();

    final Response response =
        await dio.get('https://tenders.guru/api/pl/tenders');

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      Tendr orders = Tendr.fromJson(response.data);
      return orders;
    } else {
      throw Exception();
    }
  }
}
