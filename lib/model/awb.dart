import 'package:flutter/material.dart';

class Awb {
  final int? id;
  final DateTime? createdAt;
  final int? uniqueNumber;
  final String? shipperName;
  final String? shipperContactNumber;
  final String? originCountry;
  final String? originCity;
  final String? pickupAddress;
  final String? pickupStreetName;
  final String? pickupDistrict;
  final String? shipperRefNumber;
  final String? recipientsName;
  final String? recipientsContactNumber;
  final String? destinationCountry;
  final String? destinationCity;
  final String? deliveryAddress;
  final String? deliveryStreetName;
  final String? deliveryDistrict;
  final String? accountNumber;
  final String? serviceTypeCode;
  final String? createdBy;
  final String? assignedTo;
  final String? assignedToUser;
  final DateTime? pickupDate;
  final TimeOfDay? pickupTime;
  final String? productType;
  final String? serviceType;
  final String? requestType;
  final double? pieces;
  final String? content;
  final double? weight;
  final double? amount;
  final String? currency;
  final String? dutyAndTaxesBillTo;
  final bool? status;
  final bool? emailFlag;
  final String? awbUrl;
  final String? awbStatus;

  const Awb({
    this.id,
    this.createdAt,
    this.uniqueNumber,
    this.shipperName,
    this.shipperContactNumber,
    this.originCountry,
    this.originCity,
    this.pickupAddress,
    this.pickupStreetName,
    this.pickupDistrict,
    this.shipperRefNumber,
    this.recipientsName,
    this.recipientsContactNumber,
    this.destinationCountry,
    this.destinationCity,
    this.deliveryAddress,
    this.deliveryStreetName,
    this.deliveryDistrict,
    this.accountNumber,
    this.serviceTypeCode,
    this.createdBy,
    this.assignedTo,
    this.assignedToUser,
    this.pickupDate,
    this.pickupTime,
    this.productType,
    this.serviceType,
    this.requestType,
    this.pieces,
    this.content,
    this.weight,
    this.amount,
    this.currency,
    this.dutyAndTaxesBillTo,
    this.status,
    this.emailFlag,
    this.awbUrl,
    this.awbStatus,
  });

  factory Awb.fromJson(Map<String, dynamic> json) {
    return Awb(
      id: json['id'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      uniqueNumber: json['uniqueNumber'],
      shipperName: json['shipperName'],
      shipperContactNumber: json['shipperContactNumber'],
      originCountry: json['originCountry'],
      originCity: json['originCity'],
      pickupAddress: json['pickupAddress'],
      pickupStreetName: json['pickupStreetName'],
      pickupDistrict: json['pickupDistrict'],
      shipperRefNumber: json['shipperRefNumber'],
      recipientsName: json['recipientsName'],
      recipientsContactNumber: json['recipientsContactNumber'],
      destinationCountry: json['destinationCountry'],
      destinationCity: json['destinationCity'],
      deliveryAddress: json['deliveryAddress'],
      deliveryStreetName: json['deliveryStreetName'],
      deliveryDistrict: json['deliveryDistrict'],
      accountNumber: json['accountNumber'],
      serviceTypeCode: json['serviceTypeCode'],
      createdBy: json['createdBy'],
      assignedTo: json['assignedTo'],
      assignedToUser: json['assignedToUser'],
      pickupDate: json['pickupDate'] != null
          ? DateTime.parse(json['pickupDate'])
          : null,
      pickupTime: _parseTimeOfDay(json['pickupTime']), // Parse pickupTime
      productType: json['productType'],
      serviceType: json['serviceType'],
      requestType: json['requestType'],
      pieces: json['pieces']?.toDouble(),
      content: json['content'],
      weight: json['weight']?.toDouble(),
      amount: json['amount']?.toDouble(),
      currency: json['currency'],
      dutyAndTaxesBillTo: json['dutyAndTaxesBillTo'],
      status: json['status'],
      emailFlag: json['emailFlag'],
      awbUrl: json['awbUrl'],
      awbStatus: json['awbStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'uniqueNumber': uniqueNumber,
      'shipperName': shipperName,
      'shipperContactNumber': shipperContactNumber,
      'originCountry': originCountry,
      'originCity': originCity,
      'pickupAddress': pickupAddress,
      'pickupStreetName': pickupStreetName,
      'pickupDistrict': pickupDistrict,
      'shipperRefNumber': shipperRefNumber,
      'recipientsName': recipientsName,
      'recipientsContactNumber': recipientsContactNumber,
      'destinationCountry': destinationCountry,
      'destinationCity': destinationCity,
      'deliveryAddress': deliveryAddress,
      'deliveryStreetName': deliveryStreetName,
      'deliveryDistrict': deliveryDistrict,
      'accountNumber': accountNumber,
      'serviceTypeCode': serviceTypeCode,
      'createdBy': createdBy,
      'assignedTo': assignedTo,
      'assignedToUser': assignedToUser,
      'pickupDate': pickupDate?.toIso8601String(),
      'pickupTime': pickupTime != null
          ? '${pickupTime!.hour.toString().padLeft(2, '0')}:${pickupTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'productType': productType,
      'serviceType': serviceType,
      'requestType': requestType,
      'pieces': pieces,
      'content': content,
      'weight': weight,
      'amount': amount,
      'currency': currency,
      'dutyAndTaxesBillTo': dutyAndTaxesBillTo,
      'status': status,
      'emailFlag': emailFlag,
      'awbUrl': awbUrl,
      'awbStatus': awbStatus,
    };
  }

  static TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    List<String> parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
