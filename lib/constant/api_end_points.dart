const String baseURL = 'http://192.168.0.105:8080/api/';
const String loginUrl = '${baseURL}login';
const String createAwbUrl = '${baseURL}awb';
const String getLoggedInUserUrl = '${baseURL}user/current-user';

String getAllTicketsUrl(String status) {
  return '${baseURL}ticket/ticket-status/$status';
}

String getAccountNumberWithCustomerUrl(String status) {
  return '${baseURL}account/customer-name?status=$status';
}

String getTicketByIdUrl(String id) {
  return '${baseURL}ticket/$id';
}

String getAwbByIdUrl(String id) {
  return '${baseURL}awb/$id';
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

String getAwbByAssignedUserUrl(String user, bool status) {
  return '${baseURL}awb/assigned-user?status=$status&user=$user';
}

String getAllProductTypeUrl(String status) {
  return '${baseURL}product-type?status=$status';
}

String getAllServiceTypeByProductTypeUrl(int id) {
  return '${baseURL}service-type/product-type/$id';
}
