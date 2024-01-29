import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:salsel_express/util/themes.dart';

class CreateAwbView extends StatefulWidget {
  const CreateAwbView({Key? key}) : super(key: key);

  @override
  State<CreateAwbView> createState() => _CreateAwbState();
}

class _CreateAwbState extends State<CreateAwbView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

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
                  buildStyledFormField(
                    'Shipper Name',
                    'shipperName',
                    FormBuilderValidators.required(),
                    Icons.person,
                    'Enter shipper name',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Contact Number',
                    'shipperContactNumber',
                    FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(10),
                      FormBuilderValidators.maxLength(15),
                    ]),
                    Icons.phone,
                    'Enter a valid contact number',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Pickup Address',
                    'pickupAddress',
                    FormBuilderValidators.required(),
                    Icons.location_on,
                    'Enter pickup address',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Street Name',
                    'pickupStreetName',
                    FormBuilderValidators.required(),
                    Icons.location_city,
                    'Enter street name',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'District',
                    'pickupDistrict',
                    FormBuilderValidators.required(),
                    Icons.location_city,
                    'Enter district',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Shipper Ref Number',
                    'shipperRefNumber',
                    FormBuilderValidators.required(),
                    Icons.confirmation_number,
                    'Enter shipper reference number',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Origin Country',
                    'originCountry',
                    ['Pakistan', 'India', 'Saudi'],
                    FormBuilderValidators.required(),
                    Icons.flag,
                    'Select origin country',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Origin City',
                    'originCity',
                    ['Karachi', 'Lahore', 'Islamabad'],
                    FormBuilderValidators.required(),
                    Icons.location_city,
                    'Select origin city',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Recipient Name',
                    'recipientName',
                    FormBuilderValidators.required(),
                    Icons.person,
                    'Enter recipient name',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Recipient Contact Number',
                    'recipientContactNumber',
                    FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(10),
                      FormBuilderValidators.maxLength(15),
                    ]),
                    Icons.phone,
                    'Enter a valid contact number',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Delivery Address',
                    'deliveryAddress',
                    FormBuilderValidators.required(),
                    Icons.location_on,
                    'Enter delivery address',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Street Name',
                    'deliveryStreetName',
                    FormBuilderValidators.required(),
                    Icons.location_city,
                    'Enter street name',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'District',
                    'deliveryDistrict',
                    FormBuilderValidators.required(),
                    Icons.location_city,
                    'Enter district',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Destination Country',
                    'destinationCountry',
                    ['Pakistan', 'India', 'Saudi'],
                    FormBuilderValidators.required(),
                    Icons.flag,
                    'Select destination country',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Destination City',
                    'destinationCity',
                    ['Karachi', 'Lahore', 'Islamabad'],
                    FormBuilderValidators.required(),
                    Icons.location_city,
                    'Select destination city',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDateTimePickerFormField(
                    'Pickup Date',
                    'pickupDate',
                    InputType.date,
                    'yyyy-MM-dd',
                    FormBuilderValidators.required(),
                    Icons.calendar_today,
                    'Select pickup date',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDateTimePickerFormField(
                    'Pickup Time',
                    'pickupTime',
                    InputType.time,
                    'HH:mm:ss a',
                    FormBuilderValidators.required(),
                    Icons.access_time,
                    'Select pickup time',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Product Type',
                    'productType',
                    ['International Services', 'Domestic Services'],
                    FormBuilderValidators.required(),
                    Icons.local_shipping,
                    'Select product type',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Service Type',
                    'serviceType',
                    ['DG Parcel', 'DG Domestic'],
                    FormBuilderValidators.required(),
                    Icons.local_shipping,
                    'Select service type',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Pieces',
                    'pieces',
                    FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(1),
                    ]),
                    Icons.layers,
                    'Enter number of pieces',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Weight',
                    'weight',
                    FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(0.1),
                    ]),
                    Icons.line_weight,
                    'Enter weight',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Content',
                    'content',
                    FormBuilderValidators.required(),
                    Icons.description,
                    'Enter content description',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Currency',
                    'currency',
                    ['PKR', 'USD'],
                    FormBuilderValidators.required(),
                    Icons.attach_money,
                    'Select currency',
                  ),
                  const SizedBox(height: 16),
                  buildStyledFormField(
                    'Amount',
                    'amount',
                    FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(0.1),
                    ]),
                    Icons.monetization_on,
                    'Enter amount',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Duty and Taxes Bill To',
                    'dutyAndTaxesBillTo',
                    ['Bill Shipper', 'Bill Consignee'],
                    FormBuilderValidators.required(),
                    Icons.account_balance_wallet,
                    'Select duty and taxes bill to',
                  ),
                  const SizedBox(height: 16),
                  buildStyledDropdownFormField(
                    'Request Type',
                    'requestType',
                    ['Pick-up', 'Drop-off'],
                    FormBuilderValidators.required(),
                    Icons.swap_horiz,
                    'Select request type',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_fbKey.currentState!.saveAndValidate()) {
                        // Handle form submission
                        var formData = _fbKey.currentState!.value;
                        // Perform actions with formData
                        debugPrint(formData.toString());
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

  Widget buildStyledFormField(
    String labelText,
    String fieldName,
    FormFieldValidator validator,
    IconData prefixIcon,
    String errorText,
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
      child: FormBuilderTextField(
        name: fieldName,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: primarySwatch),
          border: InputBorder.none,
          errorMaxLines: 2,
        ),
        validator: validator,
      ),
    );
  }

  Widget buildStyledDropdownFormField(
    String labelText,
    String fieldName,
    List<String> items,
    FormFieldValidator validator,
    IconData prefixIcon,
    String errorText,
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
      child: FormBuilderDropdown(
        name: fieldName,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: primarySwatch),
          border: InputBorder.none,
          errorMaxLines: 2,
        ),
        items: items
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
            .toList(),
        validator: validator,
      ),
    );
  }

  Widget buildStyledDateTimePickerFormField(
    String labelText,
    String fieldName,
    InputType inputType,
    String format,
    FormFieldValidator validator,
    IconData prefixIcon,
    String errorText,
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
      child: FormBuilderDateTimePicker(
        name: fieldName,
        inputType: inputType,
        format: DateFormat(format),
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: primarySwatch),
          border: InputBorder.none,
          errorMaxLines: 2,
        ),
        validator: validator,
      ),
    );
  }
}
