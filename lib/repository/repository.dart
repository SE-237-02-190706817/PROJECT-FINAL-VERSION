import 'package:crypto_application/models/fetchCoins_models/fetch_coins_models.dart';
import 'package:dio/dio.dart';

class Repository {
  static String mainUrl = "https://pro-api.coinmarketcap.com/v1/";
  final String apiKey = "566e2002-fb31-42d0-99f0-5b5c7bad19b5";
  var currencyListingAPI = '${mainUrl}cryptocurrency/listings/latest';
  Dio _dio = Dio();
  Future<BigDataModel> getCoins() async {
    try {
      _dio.options.headers["X-CMC_PRO_API_KEY"] = apiKey;
      Response response = await _dio.get(currencyListingAPI);
      return BigDataModel.fromJson((response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BigDataModel.withError("error");
    }
  }
}
