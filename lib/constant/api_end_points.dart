const String baseURL = 'http://192.168.0.105:8080/api/';
// const String baseURL = 'https://api.salassilexpress.com/api/';
const String loginUrl = '${baseURL}login';
const String loginAppUrl = '${baseURL}login-app';
const String createAwbUrl = '${baseURL}awb';
const String getLoggedInUserUrl = '${baseURL}user/current-user';
const String getAwbCountByAssignedUserUrl = '${baseURL}awb/count/assigned-user';
const String getTicketCountUrl = '${baseURL}ticket/count';

String getAllTicketsUrl(String status) {
  return '${baseURL}ticket/ticket-status/$status';
}

String getAllTicketsWithAllStatusUrl() {
  return '${baseURL}ticket?status=true';
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

String getAwbByAssignedUserAndAwbStatusUrl(int userId, String status) {
  return '${baseURL}awb/assigned-user/status?status=$status&userId=$userId';
}

String getAllAwbByAssignedUserUrl(int userId) {
  return '${baseURL}awb/assigned-user/id?id=$userId';
}

String getAllProductTypeUrl(String status) {
  return '${baseURL}product-type?status=$status';
}

String getAllServiceTypeByProductTypeUrl(int id) {
  return '${baseURL}service-type/product-type/$id';
}

String downloadAwbUrl(int id) {
  return '${baseURL}awb/pdf/awb_$id/$id';
}

String getLatestAwbHistoryByAwbUrl(int id) {
  return '${baseURL}awb-shipping-history/awb/$id';
}

String updateAwbStatusWithCommentUrl(String status, int uniqueNumber, String comment){
    return '${baseURL}awb/awb-status/unique-number/comment?comment=$comment&status=$status&uniqueNumber=$uniqueNumber';
}

String updateCommentInAwbHistoryUrl(int awbId, String comment){
    return '${baseURL}awb-shipping-history/update-comment?comment=$comment&awbId=$awbId';
}