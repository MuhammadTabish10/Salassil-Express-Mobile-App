import 'package:salsel_express/model/ticket_attachment.dart';

class Ticket {
  int? id;
  DateTime? createdAt;
  String? shipperName;
  String? shipperContactNumber;
  String? pickupAddress;
  String? shipperRefNumber;
  String? recipientName;
  String? recipientContactNumber;
  String? deliveryAddress;
  String? deliveryStreetName;
  String? deliveryDistrict;
  String? pickupStreetName;
  String? pickupDistrict;
  String? name;
  String? weight;
  String? email;
  String? phone;
  String? airwayNumber;
  String? ticketType;
  String? ticketUrl;
  DateTime? pickupDate;
  String? pickupTime;
  String? textarea;
  String? category;
  String? ticketFlag;
  String? assignedTo;
  String? originCountry;
  String? originCity;
  String? destinationCountry;
  String? destinationCity;
  String? createdBy;
  String? department;
  String? departmentCategory;
  String? ticketStatus;
  bool? status;
  List<TicketAttachment>? attachments;

  Ticket({
    this.id,
    this.createdAt,
    this.shipperName,
    this.shipperContactNumber,
    this.pickupAddress,
    this.shipperRefNumber,
    this.recipientName,
    this.recipientContactNumber,
    this.deliveryAddress,
    this.deliveryStreetName,
    this.deliveryDistrict,
    this.pickupStreetName,
    this.pickupDistrict,
    this.name,
    this.weight,
    this.email,
    this.phone,
    this.airwayNumber,
    this.ticketType,
    this.ticketUrl,
    this.pickupDate,
    this.pickupTime,
    this.textarea,
    this.category,
    this.ticketFlag,
    this.assignedTo,
    this.originCountry,
    this.originCity,
    this.destinationCountry,
    this.destinationCity,
    this.createdBy,
    this.department,
    this.departmentCategory,
    this.ticketStatus,
    this.status,
    this.attachments,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      shipperName: json['shipperName'],
      shipperContactNumber: json['shipperContactNumber'],
      pickupAddress: json['pickupAddress'],
      shipperRefNumber: json['shipperRefNumber'],
      recipientName: json['recipientName'],
      recipientContactNumber: json['recipientContactNumber'],
      deliveryAddress: json['deliveryAddress'],
      deliveryStreetName: json['deliveryStreetName'],
      deliveryDistrict: json['deliveryDistrict'],
      pickupStreetName: json['pickupStreetName'],
      pickupDistrict: json['pickupDistrict'],
      name: json['name'],
      weight: json['weight'],
      email: json['email'],
      phone: json['phone'],
      airwayNumber: json['airwayNumber'],
      ticketType: json['ticketType'],
      ticketUrl: json['ticketUrl'],
      pickupDate: json['pickupDate'] != null ? DateTime.parse(json['pickupDate']) : null,
      pickupTime: json['pickupTime'],
      textarea: json['textarea'],
      category: json['category'],
      ticketFlag: json['ticketFlag'],
      assignedTo: json['assignedTo'],
      originCountry: json['originCountry'],
      originCity: json['originCity'],
      destinationCountry: json['destinationCountry'],
      destinationCity: json['destinationCity'],
      createdBy: json['createdBy'],
      department: json['department'],
      departmentCategory: json['departmentCategory'],
      ticketStatus: json['ticketStatus'],
      status: json['status'],
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((attachment) => TicketAttachment.fromJson(attachment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'shipperName': shipperName,
      'shipperContactNumber': shipperContactNumber,
      'pickupAddress': pickupAddress,
      'shipperRefNumber': shipperRefNumber,
      'recipientName': recipientName,
      'recipientContactNumber': recipientContactNumber,
      'deliveryAddress': deliveryAddress,
      'deliveryStreetName': deliveryStreetName,
      'deliveryDistrict': deliveryDistrict,
      'pickupStreetName': pickupStreetName,
      'pickupDistrict': pickupDistrict,
      'name': name,
      'weight': weight,
      'email': email,
      'phone': phone,
      'airwayNumber': airwayNumber,
      'ticketType': ticketType,
      'ticketUrl': ticketUrl,
      'pickupDate': pickupDate?.toIso8601String(),
      'pickupTime': pickupTime,
      'textarea': textarea,
      'category': category,
      'ticketFlag': ticketFlag,
      'assignedTo': assignedTo,
      'originCountry': originCountry,
      'originCity': originCity,
      'destinationCountry': destinationCountry,
      'destinationCity': destinationCity,
      'createdBy': createdBy,
      'department': department,
      'departmentCategory': departmentCategory,
      'ticketStatus': ticketStatus,
      'status': status,
      'attachments': attachments?.map((attachment) => attachment.toJson()).toList(),
    };
  }
}