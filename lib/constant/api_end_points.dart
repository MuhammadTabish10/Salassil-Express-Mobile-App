const String baseURL = 'http://192.168.0.105:8080/api/';
String loginUrl = '${baseURL}login';

String getAllTicketsUrl(String status) {
  return '${baseURL}ticket/ticket-status/$status';
}

