class Country {
  int? id;
  int? code;
  String? alphaCode;
  String? name;
  bool? status;

  Country({
    this.id,
    this.code,
    this.alphaCode,
    this.name,
    this.status,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      code: json['code'],
      alphaCode: json['alphaCode'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'alphaCode': alphaCode,
      'name': name,
      'status': status,
    };
  }
}
