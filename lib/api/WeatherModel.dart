class WeatherModel{
  final temp;
  final pressure;
  final humidity;
  final temp_max;
  final temp_min;


  double get getTemp => temp - 272.5;
  double get getMaxTemp => temp_max - 272.5;
  double get getMinTemp=> temp_min - 272.5;

  WeatherModel(this.temp, this.pressure, this.humidity, this.temp_max, this.temp_min);

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    return WeatherModel(
        json["main"]["temp"],
        json["main"]["pressure"],
        json["main"]["humidity"],
        json["main"]["temp_max"],
        json["main"]["temp_min"]
    );
  }
}

class WeatherLocationModel{
  final temp;
  final pressure;
  final humidity;

  double get getTemp => temp - 272.5;

  WeatherLocationModel(this.temp, this.pressure, this.humidity);

  factory WeatherLocationModel.fromJson(Map<String, dynamic> json){
    return WeatherLocationModel(
      json["current"]["temp"],
      json["current"]["pressure"],
      json["current"]["humidity"],
    );
  }
}