
class Config {

  //GLOBAL COMPONENTS
  //TEXT
  static const String appName = '___NEWS APP___';

  //PAGINATION
  static const pageSize = 15;

  //API ADDRESS
  static const String apiKey = 'apiKey=e65ee0938a2a43ebb15923b48faed18d',
    apiUrl = 'https://newsapi.org/v2/',
    headlines = 'top-headlines?',
    everything = 'everything?';

  //TIMEOUT
  static const int sendTimeout = 35000,
      receiveTimeout = 25000;

  //DATETIME
  static const String pattern = 'dd.MM.y - H:mm';

  //OTHER
  static const double padding = 8.0;
}
