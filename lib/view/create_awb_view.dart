// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/city.dart';
import 'package:salsel_express/model/country.dart';
import 'package:salsel_express/model/product_field_values.dart';
import 'package:salsel_express/model/product_type.dart';
import 'package:salsel_express/model/service_type.dart';
import 'package:salsel_express/model/user.dart';
import 'package:salsel_express/service/awb_service.dart';
import 'package:salsel_express/service/home_service.dart';
import 'package:salsel_express/util/custom_toast.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/view/home_view.dart';
import 'package:salsel_express/widget/general_widgets.dart';

class CreateAwbView extends StatefulWidget {
  const CreateAwbView({Key? key}) : super(key: key);

  @override
  State<CreateAwbView> createState() => _CreateAwbState();
}

class _CreateAwbState extends State<CreateAwbView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late User user;
  bool isLoading = false;

  late Future<List<Country>> originCountriesFuture;
  late Future<List<Country>> destinationCountriesFuture;
  late Future<List<ProductType>> productTypeFuture;
  late Future<List<ProductFieldValues>> currenciesFuture;
  late Future<List<ProductFieldValues>> dutyAndTaxesBillToFuture;
  late Future<List<ProductFieldValues>> requestTypeFuture;
  late Future<List<String>> accountsFuture;
  late Country? originCountry;
  late Country? destinationCountry;
  late ProductType? productType;

  String? originCountryValue;
  String? originCityValue;
  String? destinationCountryValue;
  String? destinationCityValue;
  String? productTypeValue;
  String? serviceTypeValue;
  String? currencyValue;
  String? requestTypeValue;
  String? dutyAndTaxesBillToValue;
  String? accountNumberValue;
  String? serviceTypeCodeValue;

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
    initializeData();
  }

  Future<void> initializeData() async {
    originCountry = null;
    destinationCountry = null;
    productType = null;
    accountsFuture = fetchAccounts("true");
    originCountriesFuture = fetchCountries("true");
    destinationCountriesFuture = fetchCountries("true");
    productTypeFuture = fetchProductTypes("true");
    currenciesFuture = fetchCurrencies("Currency");
    dutyAndTaxesBillToFuture = fetchDutyAndTaxesBillTo("Duty And Tax Billing");
    requestTypeFuture = fetchRequestTypes("Request Type");
    user = await fetchLoggedInUser();
  }

  Future<User> fetchLoggedInUser() async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      User loggedInUser = await getLoggedInUser(token);
      return loggedInUser;
    } catch (error) {
      debugPrint('Error fetching User: $error');
      rethrow;
    }
  }

  Future<List<String>> fetchAccounts(String status) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<Map<String, dynamic>> fetchedAccounts =
          await getAccountsWithCustomer(status, token);

      // Mapping fetched accounts to the desired format
      List<String> accountList = fetchedAccounts.map((account) {
        return '${account["accountNumber"]}, ${account["customerName"]}';
      }).toList();

      return accountList;
    } catch (error) {
      debugPrint('Error fetching accounts: $error');
      rethrow;
    }
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

  Future<List<ProductType>> fetchProductTypes(String status) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<ProductType> fetchedProductTypes =
          await getAllProductType(status, token);
      return fetchedProductTypes;
    } catch (error) {
      debugPrint('Error fetching productTypes: $error');
      rethrow;
    }
  }

  Future<List<ServiceType>> fetchServiceTypesByProductType(int id) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<ServiceType> fetchedServiceTypes =
          await getAllServiceType(id, token);
      return fetchedServiceTypes;
    } catch (error) {
      debugPrint('Error fetching ServiceTypes: $error');
      rethrow;
    }
  }

  Future<List<ProductFieldValues>> fetchCurrencies(String productFeild) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<ProductFieldValues> fetchedCurrencies =
          await getProductFieldValues(productFeild, token);
      return fetchedCurrencies;
    } catch (error) {
      debugPrint('Error fetching currencies: $error');
      rethrow;
    }
  }

  Future<List<ProductFieldValues>> fetchDutyAndTaxesBillTo(
      String productFeild) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<ProductFieldValues> fetchedDutyAndTaxesBillTo =
          await getProductFieldValues(productFeild, token);
      return fetchedDutyAndTaxesBillTo;
    } catch (error) {
      debugPrint('Error fetching dutyAndTaxesBillTo: $error');
      rethrow;
    }
  }

  Future<List<ProductFieldValues>> fetchRequestTypes(
      String productFeild) async {
    try {
      String token = Provider.of<TokenProvider>(context, listen: false).token;
      List<ProductFieldValues> fetchedRequestTypes =
          await getProductFieldValues(productFeild, token);
      return fetchedRequestTypes;
    } catch (error) {
      debugPrint('Error fetching RequestTypes: $error');
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
        title: const Text(
          'Create AWB',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  FutureBuilder<List<String>>(
                    future: accountsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<String> accounts = snapshot.data!;
                        return buildDropdownField(
                          'Account Number',
                          Icons.account_balance_wallet,
                          accounts,
                          accountNumberValue,
                          (newValue) {
                            setState(() {
                              accountNumberValue = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Shipper Name',
                    Icons.person,
                    shipperNameController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Contact Number',
                    Icons.phone,
                    shipperContactNumberController,
                    true,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Country>>(
                    future: originCountriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<Country> countries = snapshot.data!;
                        List<String> countryNames =
                            countries.map((country) => country.name!).toList();
                        return buildDropdownField(
                          'Origin Country',
                          Icons.flag,
                          countryNames,
                          originCountryValue,
                          (newValue) {
                            setState(() {
                              originCountryValue = newValue;
                              originCountry = countries.firstWhere(
                                  (country) => country.name == newValue);
                              // Reset city value when country changes
                              originCityValue = null;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<City>>(
                    future: originCountry != null
                        ? fetchCitiesByCountry(originCountry!.id!)
                        : Future.value([]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<String> cityNames =
                            snapshot.data!.map((city) => city.name!).toList();
                        return buildDropdownField(
                          'Origin City',
                          Icons.location_city,
                          cityNames,
                          originCityValue,
                          (newValue) {
                            setState(() {
                              originCityValue = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Pickup Address',
                    Icons.location_on,
                    pickupAddressController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Street Name',
                    Icons.location_city,
                    pickupStreetNameController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'District',
                    Icons.location_city,
                    pickupDistrictController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Shipper Ref Number',
                    Icons.confirmation_number,
                    shipperRefNumberController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Recipient Name',
                    Icons.person,
                    recipientsNameController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Recipient Contact Number',
                    Icons.phone,
                    recipientsContactNumberController,
                    true,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Country>>(
                    future: destinationCountriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<Country> countries = snapshot.data!;
                        List<String> countryNames =
                            countries.map((country) => country.name!).toList();
                        return buildDropdownField(
                          'Destination Country',
                          Icons.flag,
                          countryNames,
                          destinationCountryValue,
                          (newValue) {
                            setState(() {
                              destinationCountryValue = newValue;
                              destinationCountry = countries.firstWhere(
                                  (country) => country.name == newValue);
                              // Reset city value when country changes
                              destinationCityValue = null;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<City>>(
                    future: destinationCountry != null
                        ? fetchCitiesByCountry(destinationCountry!.id!)
                        : Future.value([]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<String> cityNames =
                            snapshot.data!.map((city) => city.name!).toList();
                        return buildDropdownField(
                          'Destination City',
                          Icons.location_city,
                          cityNames,
                          destinationCityValue,
                          (newValue) {
                            setState(() {
                              destinationCityValue = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Delivery Address',
                    Icons.location_on,
                    deliveryAddressController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Street Name',
                    Icons.location_city,
                    deliveryStreetNameController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'District',
                    Icons.location_city,
                    deliveryDistrictController,
                    false,
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
                  FutureBuilder<List<ProductType>>(
                    future: productTypeFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<ProductType> productTypes = snapshot.data!;
                        List<String> productTypesNames = productTypes
                            .map((productType) => productType.name!)
                            .toList();
                        return buildDropdownField(
                          'Product Type',
                          Icons.local_shipping,
                          productTypesNames,
                          productTypeValue,
                          (newValue) {
                            setState(() {
                              productTypeValue = newValue;
                              productType = productTypes.firstWhere(
                                  (productType) =>
                                      productType.name == newValue);
                              serviceTypeValue = null;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<ServiceType>>(
                    future: productType != null
                        ? fetchServiceTypesByProductType(productType!.id!)
                        : Future.value([]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<ServiceType> serviceTypes = snapshot.data!;
                        List<String> serviceTypeNames = serviceTypes
                            .map((service) => service.name!)
                            .toList();
                        return buildDropdownField(
                          'Service Type',
                          Icons.local_shipping,
                          serviceTypeNames,
                          serviceTypeValue,
                          (newValue) {
                            // Find the selected service type by its name
                            ServiceType selectedServiceType =
                                serviceTypes.firstWhere(
                                    (service) => service.name == newValue,
                                    orElse: () => ServiceType());

                            setState(() {
                              serviceTypeValue = newValue;
                              // Set the serviceTypeCodeValue to the code of the selected service type
                              serviceTypeCodeValue = selectedServiceType.code;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<ProductFieldValues>>(
                    future: requestTypeFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<ProductFieldValues> requestTypeList =
                            snapshot.data!;
                        List<String> requestTypeNames = requestTypeList
                            .map((requestType) => requestType.name!)
                            .toList();
                        return buildDropdownField(
                          'Request Type',
                          Icons.swap_horiz,
                          requestTypeNames,
                          requestTypeValue,
                          (newValue) {
                            setState(() {
                              requestTypeValue = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Pieces',
                    Icons.layers,
                    piecesController,
                    true,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Content',
                    Icons.description,
                    contentController,
                    false,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Weight',
                    Icons.line_weight,
                    weightController,
                    true,
                  ),
                  const SizedBox(height: 16),
                  buildInputField(
                    'Amount',
                    Icons.monetization_on,
                    amountController,
                    true,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<ProductFieldValues>>(
                    future: currenciesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<ProductFieldValues> currencies = snapshot.data!;
                        List<String> currenciesNames = currencies
                            .map((currency) => currency.name!)
                            .toList();
                        return buildDropdownField(
                          'Currency',
                          Icons.attach_money,
                          currenciesNames,
                          currencyValue,
                          (newValue) {
                            setState(() {
                              currencyValue = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<ProductFieldValues>>(
                    future: dutyAndTaxesBillToFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: primarySwatch),
                        );
                      } else if (snapshot.hasError) {
                        CustomToast.showAlert(
                            context, 'Error: ${snapshot.error}');
                        return const SizedBox();
                      } else {
                        List<ProductFieldValues> dutyAndTaxesBillToList =
                            snapshot.data!;
                        List<String> dutyAndTaxesBillToNames =
                            dutyAndTaxesBillToList
                                .map((dutyAndTaxesBillTo) =>
                                    dutyAndTaxesBillTo.name!)
                                .toList();
                        return buildDropdownField(
                          'Duty And Taxes Bill To',
                          Icons.account_balance_wallet,
                          dutyAndTaxesBillToNames,
                          dutyAndTaxesBillToValue,
                          (newValue) {
                            setState(() {
                              dutyAndTaxesBillToValue = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (!_fbKey.currentState!.saveAndValidate()) {
                              // Form is not valid, show error message
                              CustomToast.showAlert(context,
                                  'Please fill in all required fields.');
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }

                            // Check for null values in individual fields
                            if (accountNumberValue == null ||
                                originCountryValue == null ||
                                originCityValue == null ||
                                destinationCountryValue == null ||
                                destinationCityValue == null ||
                                productTypeValue == null ||
                                serviceTypeValue == null ||
                                requestTypeValue == null ||
                                piecesController.text.isEmpty ||
                                contentController.text.isEmpty ||
                                weightController.text.isEmpty ||
                                amountController.text.isEmpty ||
                                currencyValue == null ||
                                dutyAndTaxesBillToValue == null) {
                              CustomToast.showAlert(context,
                                  'Please fill in all required fields.');
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }
                            // Create an Awb object using the form data
                            Awb newAwb = createAwbFromTextControllers();
                            try {
                              String token = Provider.of<TokenProvider>(context,
                                      listen: false)
                                  .token;
                              var createdAwb =
                                  await createAirWayBill(newAwb, token);
                              // Handle the created Awb object as needed
                              debugPrint('Created AWB: ${createdAwb.toJson()}');

                              // Pop the current page
                              Navigator.of(context).pop();

                              // Push the page again to reload and render
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()),
                              );
                            } catch (e) {
                              // Handle any exceptions that occur during the API call
                              debugPrint('API Error: $e');
                              CustomToast.showAlert(context, 'Awb not created');
                            } finally {
                              // Set loading state to false
                              setState(() {
                                isLoading = false;
                              });
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
                      child: Center(
                        child: isLoading
                            ? const SpinKitSpinningLines(
                                color: primarySwatch) // Show loader
                            : const Text(
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

  Widget buildInputField(String labelText, IconData prefixIcon,
      TextEditingController controller, bool numeric) {
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
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
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

  Awb createAwbFromTextControllers() {
    DateTime pickupDate =
        DateFormat('yyyy-MM-dd').parse(pickupDateController.text);
    DateTime pickupDateTime =
        DateFormat('h:mm a').parse(pickupTimeController.text);
    TimeOfDay pickupTime = TimeOfDay.fromDateTime(pickupDateTime);
    return Awb(
      shipperName: shipperNameController.text,
      shipperContactNumber: shipperContactNumberController.text,
      originCountry: originCountryValue,
      originCity: originCityValue,
      pickupAddress: pickupAddressController.text,
      pickupStreetName: pickupStreetNameController.text,
      pickupDistrict: pickupDistrictController.text,
      shipperRefNumber: shipperRefNumberController.text,
      recipientsName: recipientsNameController.text,
      createdBy: user.email,
      serviceTypeCode: serviceTypeCodeValue,
      assignedToUser: user.name,
      recipientsContactNumber: recipientsContactNumberController.text,
      destinationCountry: destinationCountryValue,
      destinationCity: destinationCityValue,
      deliveryAddress: deliveryAddressController.text,
      deliveryStreetName: deliveryStreetNameController.text,
      deliveryDistrict: deliveryDistrictController.text,
      accountNumber: accountNumberValue!.split(',')[0].trim(),
      pickupDate: pickupDate,
      pickupTime: pickupTime,
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
  }
}
