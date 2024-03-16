import 'package:dio/dio.dart';

import '../../models/place.dart';
import '../../res/config.dart';

class SearchApi {
  static Future<List<Place>> search({required String text}) async {
    var dio = Dio();
    var res =
        await dio.get('$searchHost?lang=ru_RU&apikey=$searchApiKey&text=$text');
    List<Place> list = [];
    for (var json in (res.data['features'] as List<dynamic>)) {
      Place place = Place.fromJson(json as Map<String, dynamic>);
      list.add(place);
    }
    return list;
  }
}
