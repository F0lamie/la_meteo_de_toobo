import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la_meteo_de_toobo/WeatherBloc.dart';

import 'api/WeatherModel.dart';
import 'WeatherRepo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.green[900],
          body: BlocProvider(
            create: (context) => WeatherBloc(WeatherRepo()),
            child: MyHomePage(),
          ),
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("La météo de Toobo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Center(
            child: Container(
              child: Image.asset('assets/images/toobo.jpeg'),
              height: 300,
              width: 300,
            ),
          ),



          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state){
              if (state is WeatherIsNotSearched)
                return Container(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    children: <Widget>[
                      Text('Search Weather', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),),
                      Text('Instantly', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w200),),
                      SizedBox(height: 24,),
                      TextFormField(
                        controller: cityController,

                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(style: BorderStyle.solid)
                          ),

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid)
                          ),

                          hintText: "City Name",
                        ),
                      ),

                      SizedBox(height: 20,),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            weatherBloc.add(FetchWeather(cityController.text));
                          },
                          color: Colors.lightBlue,
                          child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16),),
                        ),
                      ),

                      SizedBox(height: 20,),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            weatherBloc.add(FetchLocationWeather());
                          },
                          color: Colors.lightBlue,
                          child: Text("My Location Weather", style: TextStyle(color: Colors.white, fontSize: 16),),
                        ),
                      )
                    ],
                  ),
                );
              else if (state is WeatherIsLoading)
                return Center(child: CircularProgressIndicator(),);
              else if (state is WeatherIsLoaded)
                return ShowWeather(state.getWeather, cityController.text);
              else if (state is WeatherLocationIsLoaded)
                return ShowLocationWeather(state.getWeather);

              return Container(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Column(
                  children: <Widget>[
                    Text('Search Weather', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),),
                    Text('There was an error, try again', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w200),),
                    SizedBox(height: 24,),
                    TextFormField(
                      controller: cityController,

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(style: BorderStyle.solid)
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.blue, style: BorderStyle.solid)
                        ),

                        hintText: "City Name",
                      ),
                    ),

                    SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                        color: Colors.lightBlue,
                        child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          weatherBloc.add(FetchLocationWeather());
                        },
                        color: Colors.lightBlue,
                        child: Text("My Location Weather", style: TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Container(
      padding: EdgeInsets.only(right: 32, left: 32, top: 10),
      child: Column(
        children: <Widget>[
          Text(city,style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),

          Text(weather.getTemp.round().toString() + "C", style: TextStyle(fontSize: 50)),
          Text("Temperature", style: TextStyle(fontSize: 14)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(weather.getMinTemp.round().toString() + "C", style: TextStyle(fontSize: 30),),
                  Text("Min Temprature",style: TextStyle(fontSize: 14),),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(weather.getMaxTemp.round().toString() + "C", style: TextStyle(fontSize: 30),),
                  Text("Max Temprature",style: TextStyle(fontSize: 14),),
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                weatherBloc.add(ResetWeather());
              },
              color: Colors.lightBlue,
              child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16),),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                weatherBloc.add(FetchLocationWeather());
              },
              color: Colors.lightBlue,
              child: Text("My Location Weather", style: TextStyle(color: Colors.white, fontSize: 16),),
            ),
          )
        ],
      ),
    );
  }
}

class ShowLocationWeather extends StatelessWidget {
  WeatherLocationModel weather;

  ShowLocationWeather(this.weather);

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Container(
      padding: EdgeInsets.only(right: 32, left: 32, top: 10),
      child: Column(
        children: <Widget>[
          Text("Your location weather is",style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),

          Text(weather.getTemp.round().toString() + "C", style: TextStyle(fontSize: 50)),
          Text("Temperature", style: TextStyle(fontSize: 14)),
          SizedBox(height: 20,),

          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                weatherBloc.add(ResetWeather());
              },
              color: Colors.lightBlue,
              child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 16),),
            ),
          )
        ],
      ),
    );
  }
}