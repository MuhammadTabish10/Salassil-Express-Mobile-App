const String baseURL = 'http://192.168.0.105:8080/api/';
const String loginUrl = '${baseURL}login';

String getAllTicketsUrl(String status) {
  return '${baseURL}ticket/ticket-status/$status';
}

String getTicketByIdUrl(String id) {
  return '${baseURL}ticket/$id';
}
