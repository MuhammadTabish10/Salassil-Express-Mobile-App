class ProductType {
  int? id;
  String? code;
  String? name;
  bool? status;

  ProductType({
    this.id,
    this.code,
    this.name,
    this.status,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'status': status,
    };
  }
}
