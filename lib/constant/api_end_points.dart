const String baseURL = 'http://192.168.0.104:8080/api/';
const String loginUrl = '${baseURL}login';
const String createAwbUrl = '${baseURL}awb';

String getAllTicketsUrl(String status) {
  return '${baseURL}ticket/ticket-status/$status';
}

String getTicketByIdUrl(String id) {
  return '${baseURL}ticket/$id';
}

String updateAwbStatusByScanUrl(int uniqueNumber, String status) {
  return '${baseURL}awb/awb-status/$status/unique-number/$uniqueNumber';
}

String getAllCountriesUrl(String status) {
  return '${baseURL}country?status=$status';
}

String getAllCitiesByCountryUrl(int id) {
  return '${baseURL}city/country/$id';
}

String getAllProductFieldValuesByProductFieldUrl(String productField) {
  return '${baseURL}product-field/productFieldValues?productField=$productField';
}

String getAwbByUniqueNumberUrl(int uniqueNumber) {
  return '${baseURL}awb/unique-number/$uniqueNumber';
}

