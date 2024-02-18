import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/city.dart';
import 'package:salsel_express/model/country.dart';
import 'package:salsel_express/service/awb_service.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/widget/general_widgets.dart';

class CreateAwbView extends StatefulWidget {
  const CreateAwbView({Key? key}) : super(key: key);

  @override
  State<CreateAwbView> createState() => _CreateAwbState();
}

class _CreateAwbState extends State<CreateAwbView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late Future<List<Country>> countriesFuture;
  late Future<List<City>> citiesFuture;
  String? originCountryValue;
  String? originCityValue;
  String? destinationCountryValue;
  String? destinationCityValue;
  String? productTypeValue;
  String? serviceTypeValue;
  String? currencyValue;
  String? requestTypeValue;
  String? dutyAndTaxesBillToValue;

  final TextEditingController shipperNameController = TextEditingController();
  final TextEditingController shipperContactNumberController =
      TextEditingController();
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController pickupStreetNameController =
      TextEditingController();
  final TextEditingController pickupDistrictController =
      TextEditingController();
  final TextEditingController shipperRefNumberController =
      TextEditingController();
  final TextEditingController recipientsNameController =
      TextEditingController();
  final TextEditingController recipientsContactNumberController =
      TextEditingController();
  final TextEditingController deliveryAddressController =
      TextEditingController();
  final TextEditingController deliveryStreetNameController =
      TextEditingController();
  final TextEditingController deliveryDistrictController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();
  final TextEditingController piecesController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController emailFlagController = TextEditingController();
  final TextEditingController awbUrlController = TextEditingController();
  final TextEditingController awbStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countriesFuture = fetchCountries("true");
  }

  Future<List<Country>> fetchCountries(String status) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<Country> fetchedCountries = await getCountries(status, token);
      return fetchedCountries;
    } catch (error) {
      debugPrint('Error fetching countries: $error');
      rethrow;
    }
  }

    Future<List<City>> fetchCitiesByCountry(int id) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<City> fetchedCites = await getCities(id, token);
      return fetchedCites;
    } catch (error) {
      debugPrint('Error fetching cities: $error');
      rethrow;
    }
  }

  @override
  void dispose() {
    shipperNameController.dispose();
    shipperContactNumberController.dispose();
    pickupAddressController.dispose();
    pickupStreetNameController.dispose();
    pickupDistrictController.dispose();
    shipperRefNumberController.dispose();
    recipientsNameController.dispose();
    recipientsContactNumberController.dispose();
    deliveryAddressController.dispose();
    deliveryStreetNameController.dispose();
    deliveryDistrictController.dispose();
    accountNumberController.dispose();
    assignedToController.dispose();
    pickupDateController.dispose();
    pickupTimeController.dispose();
    piecesController.dispose();
    contentController.dispose();
    weightController.dispose();
    amountController.dispose();
    statusController.dispose();
    emailFlagController.dispose();
    awbUrlController.dispose();
    awbStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create AWB'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Themes.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                children: [
                  buildInputField(
                    'Shipper Name',
                    Icons.person,
                    shipperNameController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Contact Number',
                    Icons.phone,
                    shipperContactNumberController,
                  ),
                  const SizedBox(height: 16),
                  // buildDropdownField(
                  //   'Origin Country',
                  //   Icons.flag,
                  //   ['Pakistan', 'India', 'Saudi'],
                  //   originCountryValue,
                  //   (newValue) {
                  //     setState(() {
                  //       originCountryValue = newValue!;
                  //     });
                  //   },
                  // ),
                  FutureBuilder<List<Country>>(
                    future: countriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<String> countryNames = snapshot.data!
                            .map((country) => country.name!)
                            .toList();
                        return buildDropdownField(
                          'Origin Country',
                          Icons.flag,
                          countryNames,
                          originCountryValue,
                          (newValue) {
                            setState(() {
                              originCountryValue = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // buildDropdownField(
                  //   'Origin City',
                  //   Icons.location_city,
                  //   ['Karachi', 'Lahore', 'Islamabad'],
                  //   originCityValue,
                  //   (newValue) {
                  //     setState(() {
                  //       originCityValue = newValue!;
                  //     });
                  //   },
                  // ),

                  const SizedBox(height: 16),
                  buildInputField(
                    'Pickup Address',
                    Icons.location_on,
                    pickupAddressController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Street Name',
                    Icons.location_city,
                    pickupStreetNameController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'District',
                    Icons.location_city,
                    pickupDistrictController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Shipper Ref Number',
                    Icons.confirmation_number,
                    shipperRefNumberController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Recipient Name',
                    Icons.person,
                    recipientsNameController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Recipient Contact Number',
                    Icons.phone,
                    recipientsContactNumberController,
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    'Destination Country',
                    Icons.flag,
                    ['Pakistan', 'India', 'Saudi'],
                    destinationCountryValue,
                    (newValue) {
                      setState(() {
                        destinationCountryValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    'Destination City',
                    Icons.location_city,
                    ['Karachi', 'Lahore', 'Islamabad'],
                    destinationCityValue,
                    (newValue) {
                      setState(() {
                        destinationCityValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Delivery Address',
                    Icons.location_on,
                    deliveryAddressController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Street Name',
                    Icons.location_city,
                    deliveryStreetNameController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'District',
                    Icons.location_city,
                    deliveryDistrictController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Account Number',
                    Icons.account_balance_wallet,
                    accountNumberController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Assigned To',
                    Icons.person,
                    assignedToController,
                  ),
                  const SizedBox(height: 16),
                  buildDateField(
                    'Pickup Date',
                    Icons.calendar_today,
                    pickupDateController,
                    context,
                  ),
                  const SizedBox(height: 16),
                  buildTimeField(
                    'Pickup Time',
                    Icons.access_time,
                    pickupTimeController,
                    context,
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    'Product Type',
                    Icons.local_shipping,
                    ['Product 1', 'Product 2', 'Product 3'],
                    productTypeValue,
                    (newValue) {
                      setState(() {
                        productTypeValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    'Service Type',
                    Icons.local_shipping,
                    ['Service 1', 'Service 2', 'Service 3'],
                    serviceTypeValue,
                    (newValue) {
                      setState(() {
                        serviceTypeValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    'Request Type',
                    Icons.swap_horiz,
                    ['Pickup', 'Dropff'],
                    requestTypeValue,
                    (newValue) {
                      setState(() {
                        requestTypeValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Pieces',
                    Icons.layers,
                    piecesController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Content',
                    Icons.description,
                    contentController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Weight',
                    Icons.line_weight,
                    weightController,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Amount',
                    Icons.monetization_on,
                    amountController,
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    'Currency',
                    Icons.attach_money,
                    ['Pickup', 'Dropff'],
                    currencyValue,
                    (newValue) {
                      setState(() {
                        currencyValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    'Duty and Taxes Bill To',
                    Icons.account_balance_wallet,
                    ['bill Shipper', 'Bill Consignee'],
                    dutyAndTaxesBillToValue,
                    (newValue) {
                      setState(() {
                        dutyAndTaxesBillToValue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_fbKey.currentState!.saveAndValidate()) {
                        // Extract data from the form
                        var formData = _fbKey.currentState!.value;

                        // Create an Awb object using the form data
                        Awb newAwb = Awb(
                          shipperName: shipperNameController.text,
                          shipperContactNumber:
                              shipperContactNumberController.text,
                          originCountry: originCountryValue,
                          originCity: originCityValue,
                          pickupAddress: pickupAddressController.text,
                          pickupStreetName: pickupStreetNameController.text,
                          pickupDistrict: pickupDistrictController.text,
                          shipperRefNumber: shipperRefNumberController.text,
                          recipientsName: recipientsNameController.text,
                          recipientsContactNumber:
                              recipientsContactNumberController.text,
                          destinationCountry: destinationCountryValue,
                          destinationCity: destinationCityValue,
                          deliveryAddress: deliveryAddressController.text,
                          deliveryStreetName: deliveryStreetNameController.text,
                          deliveryDistrict: deliveryDistrictController.text,
                          accountNumber: accountNumberController.text,
                          assignedTo: assignedToController.text,
                          pickupDate: DateTime.parse(pickupDateController
                              .text), // Assuming pickupDate is DateTime
                          pickupTime: TimeOfDay(
                            hour: int.parse(pickupTimeController.text
                                .split(':')[0]), // Extract hour
                            minute: int.parse(pickupTimeController.text
                                .split(':')[1]), // Extract minute
                          ),
                          productType: productTypeValue,
                          serviceType: serviceTypeValue,
                          requestType: requestTypeValue,
                          pieces: double.parse(piecesController.text),
                          content: contentController.text,
                          weight: double.parse(weightController.text),
                          amount: double.parse(amountController.text),
                          currency: currencyValue,
                          dutyAndTaxesBillTo: dutyAndTaxesBillToValue,
                        );

                        // Make the API call to create AWB
                        try {
                          // Replace 'yourToken' with the actual token you have
                          String token =
                              Provider.of<TokenProvider>(context, listen: false)
                                  .token;
                          var createdAwb =
                              await createAirWayBill(newAwb, token);
                          // Handle the created Awb object as needed
                          debugPrint('Created AWB: ${createdAwb.toJson()}');
                        } catch (e) {
                          // Handle any exceptions that occur during the API call
                          debugPrint('API Error: $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primarySwatch[500],
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      String labelText, IconData prefixIcon, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: primarySwatch),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildDropdownField(
    String labelText,
    IconData prefixIcon,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: primarySwatch),
          border: InputBorder.none,
        ),
        value: selectedValue,
        onChanged: onChanged,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        icon: const SizedBox(
          height: double.infinity,
          child: Icon(Icons.arrow_drop_down),
        ),
        // Wrap the DropdownButtonFormField in an Expanded widget
        // to prevent overflow
        isExpanded: true,
      ),
    );
  }
}