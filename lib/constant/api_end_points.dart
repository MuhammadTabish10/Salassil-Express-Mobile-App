const String baseURL = 'http://192.168.1.228:8080/api/';
String loginUrl = '${baseURL}login';

String getAllTicketsUrl(bool status) {
  return '${baseURL}ticket?status=$status';
}

