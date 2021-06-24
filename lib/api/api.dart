import 'package:http/http.dart';
import 'package:la_meteo_de_toobo/api/WeatherModel.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org")
abstract class RestClient{
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/data/2.5/weather")
  Future<WeatherModel> getWeather({
    @Query('q') String city = "Lille",
    @Query('appid') String apikey = "fdf0ad68f5686d35a103744ee1275ced"});

  @GET("/data/2.5/onecall")
  Future<WeatherLocationModel> getLocationWeather({
  @Query('lat') String lat = "50.6329700",
  @Query('lon') String lon = "3.0585800",
  @Query('appid') String apikey = "fdf0ad68f5686d35a103744ee1275ced"});
}