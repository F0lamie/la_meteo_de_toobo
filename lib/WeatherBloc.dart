import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:la_meteo_de_toobo/api/WeatherModel.dart';

import 'WeatherRepo.dart';

class WeatherEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class FetchWeather extends WeatherEvent{
  final _city;

  FetchWeather(this._city);

  @override
  List<Object> get props => [_city];
}

class FetchLocationWeather extends WeatherEvent{
}

class ResetWeather extends WeatherEvent{

}

class WeatherState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class WeatherIsNotSearched extends WeatherState{

}

class WeatherIsLoading extends WeatherState{

}

class WeatherIsLoaded extends WeatherState{
  final _weather;

  WeatherIsLoaded(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class WeatherLocationIsLoaded extends WeatherState{
  final _weather;

  WeatherLocationIsLoaded(this._weather);

  WeatherLocationModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class WeatherIsNotLoaded extends WeatherState{

}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState>{

  WeatherRepo weatherRepo;

  WeatherBloc(this.weatherRepo) : super(WeatherIsNotSearched());

  @override
  WeatherState get initialState => WeatherIsNotSearched();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchWeather){
      yield WeatherIsLoading();

      try {
        WeatherModel weather = await weatherRepo.getWeather(event._city);
        print("Je suis un test");
        yield WeatherIsLoaded(weather);
      } catch(_) {
        yield WeatherIsNotLoaded();
      }
    }else if (event is FetchLocationWeather){
      yield WeatherIsLoading();

      try {
        WeatherLocationModel weather = await weatherRepo.getLocationWeather();
        yield WeatherLocationIsLoaded(weather);
      } catch(_) {
        yield WeatherIsNotLoaded();
      }
    } else if (event is ResetWeather) {
      yield WeatherIsNotSearched();
    }
  }

}