import 'package:salsel_express/model/product_type.dart';

class ServiceType {
  int? id;
  String? code;
  String? name;
  bool? status;
  ProductType? productType;

  ServiceType({
    this.id,
    this.code,
    this.name,
    this.status,
    this.productType,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      status: json['status'],
      productType: json['productType'] != null
          ? ProductType.fromJson(json['productType'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'status': status,
      'productType': productType?.toJson()
    };
  }
}
