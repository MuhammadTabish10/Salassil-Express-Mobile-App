import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:salsel_express/constant/api_end_points.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/awb_history.dart';
import 'package:salsel_express/model/city.dart';
import 'package:salsel_express/model/country.dart';
import 'package:salsel_express/model/product_type.dart';
import 'package:salsel_express/model/service_type.dart';

Future<Awb> createAirWayBill(Awb awb, String token) async {
  final Uri uri = Uri.parse(createAwbUrl);

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(awb.toJson()),
  );

  if (response.statusCode == 200) {
    return Awb.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create AWB: ${response.statusCode}');
  }
}

Future<List<Country>> getCountries(String status, String token) async {
  String apiUrl = getAllCountriesUrl(status);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Country.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Countries');
  }
}

Future<List<City>> getCities(int id, String token) async {
  String apiUrl = getAllCitiesByCountryUrl(id);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => City.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Cities');
  }
}

Future<List<Awb>> getAllAwbByAssignedUser(
    int userId, String status, String token) async {
  String apiUrl = getAwbByAssignedUserAndAwbStatusUrl(userId, status);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Awb.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load awbs');
  }
}

Future<List<Awb>> getAllAwbByAssignedUserId(
    int userId, String token) async {
  String apiUrl = getAllAwbByAssignedUserUrl(userId);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Awb.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load awbs');
  }
}

Future<void> downloadAwbPdf(int awbId) async {
  try {
    if (!(await Permission.storage.isGranted)) {
      // Request the WRITE_EXTERNAL_STORAGE permission if it has not been granted yet
      var status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Permission denied for storage');
      }
    }

    String downloadsFolderPath = "/storage/emulated/0/Download";

    String fileName = 'awb_$awbId.pdf'; // Initial name of the file to be saved
    int counter = 0;
    File file = File('$downloadsFolderPath/$fileName');

    // Check if the file already exists
    while (await file.exists()) {
      counter++;
      // If the file already exists, increment the counter and append it to the file name
      fileName = 'awb_$awbId($counter).pdf';
      file = File('$downloadsFolderPath/$fileName');
    }

    String apiUrl = downloadAwbUrl(awbId);
    final Uri uri = Uri.parse(apiUrl);
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      await file.writeAsBytes(bytes);
      print('PDF downloaded successfully at: ${file.path}');
    } else {
      print('Failed to download PDF. Status Code: ${response.statusCode}');
      throw Exception('Failed to download PDF');
    }
  } catch (e) {
    print('Exception occurred: $e');
    throw Exception('Failed to download PDF');
  }
}

// Future<void> downloadAwbPdf(int awbId) async {
//   try {
//     if (!(await Permission.storage.isGranted)) {
//       // Request the WRITE_EXTERNAL_STORAGE permission if it has not been granted yet
//       var status = await Permission.storage.request();
//       if (status != PermissionStatus.granted) {
//         throw Exception('Permission denied for storage');
//       }
//     }

//     String downloadsFolderPath = "/storage/emulated/0/Download";

//     String fileName = 'awb_$awbId.pdf'; // Name of the file to be saved
//     File file = File('$downloadsFolderPath/$fileName');

//     String apiUrl = downloadAwbUrl(awbId);
//     final Uri uri = Uri.parse(apiUrl);
//     final response = await http.get(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final bytes = response.bodyBytes;
//       await file.writeAsBytes(bytes);
//       print('PDF downloaded successfully at: ${file.path}');
//     } else {
//       print('Failed to download PDF. Status Code: ${response.statusCode}');
//       throw Exception('Failed to download PDF');
//     }
//   } catch (e) {
//     print('Exception occurred: $e');
//     throw Exception('Failed to download PDF');
//   }
// }

Future<Awb> getAwbById(String awbId, String token) async {
  final String apiUrl = getAwbByIdUrl(awbId);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final dynamic jsonData = json.decode(response.body);
    return Awb.fromJson(jsonData);
  } else {
    throw Exception('Failed to load Awb');
  }
}

Future<List<ProductType>> getAllProductType(String status, String token) async {
  String apiUrl = getAllProductTypeUrl(status);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => ProductType.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load all ProductType');
  }
}

Future<List<ServiceType>> getAllServiceType(int id, String token) async {
  String apiUrl = getAllServiceTypeByProductTypeUrl(id);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => ServiceType.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load all Service Type');
  }
}

Future<List<Map<String, dynamic>>> getAccountsWithCustomer(
    String status, String token) async {
  String apiUrl = getAccountNumberWithCustomerUrl(status);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    List<Map<String, dynamic>> accountList = jsonResponse.map((json) {
      return {
        'accountNumber': json['accountNumber'].toString(),
        'customerName': json['customerName'],
      };
    }).toList();

    return accountList;
  } else {
    throw Exception('Failed to load accounts');
  }
}


Future<AwbHistory> getAwbHistoryWithComment(int id, String token) async {
  String apiUrl = getLatestAwbHistoryByAwbUrl(id);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final dynamic jsonResponse = json.decode(response.body);
    return AwbHistory.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to awbHistory');
  }
}

Future<void> updateAwbStatusWithComment(
    int uniqueNumber, String status, String comment, String token) async {
  String apiUrl = updateAwbStatusWithCommentUrl(status, uniqueNumber, comment);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.put(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print(response);
  } else {
    throw Exception('Failed to update AWB Status: ${response.statusCode}');
  }
}

Future<void> updateComment(int id, String comment, String token) async {
  String apiUrl = updateCommentInAwbHistoryUrl(id, comment);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.put(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print(response);
  } else {
    throw Exception('Failed to update AWB Comment: ${response.statusCode}');
  }
}