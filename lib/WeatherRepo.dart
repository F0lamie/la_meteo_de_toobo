import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:la_meteo_de_toobo/api/WeatherModel.dart';
import 'package:la_meteo_de_toobo/api/api.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

class WeatherRepo {
  final logger = Logger();
  Future<WeatherModel> getWeather(String city) async {
    final dio = Dio();
    final client = RestClient(dio);

    print("Oui");
    final retrofitResult = await client.getWeather(city: city, apikey: "fdf0ad68f5686d35a103744ee1275ced");
    print("Non");
    return retrofitResult;
  }

  Future<WeatherLocationModel> getLocationWeather() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception();
      }
    }

    _locationData = await location.getLocation();

    final dio = Dio();
    final client = RestClient(dio);
    final result = await client.getLocationWeather(lat: _locationData.latitude.toString(), lon: _locationData.longitude.toString(), apikey: "fdf0ad68f5686d35a103744ee1275ced");
    return result;
  }

  WeatherModel parsedJson(final response) {
    final jsonDecoded = json.decode(response);
    final jsonWeather = jsonDecoded["main"];

    return WeatherModel.fromJson(jsonWeather);
  }
}