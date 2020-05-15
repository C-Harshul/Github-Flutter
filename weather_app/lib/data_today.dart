class WeatherData {
  final DateTime date;
  final String name;
  final double temp;
  final String main;
  final String icon;
  final double tempMax;
  final double tempMin;
  final double feelsLike;
  final double wind;
  final int humidity;

  WeatherData({this.date, this.name, this.temp, this.main, this.icon, this.tempMax, this.tempMin, this.feelsLike, this.wind, this.humidity});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: new DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000,
          isUtc: false),
      name: json['name'],
      temp: json['main']['temp'].toDouble(),
      main: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      tempMax : json['main']['temp_max'].toDouble(),
      tempMin : json['main']['temp_min'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      wind: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
    );
  }
}
