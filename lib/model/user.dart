class User {
  final int? id;
  final DateTime? createdAt;
  final String? employeeId;
  final String? name;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? email;
  final String? password;
  final bool? status;
  // final Set<Role>? roles;

  User({
    this.id,
    this.createdAt,
    this.employeeId,
    this.name,
    this.firstname,
    this.lastname,
    this.phone,
    this.email,
    this.password,
    this.status,
    // this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      employeeId: json['employee_id'],
      name: json['name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      status: json['status'],
      // roles: (json['roles'] as List<dynamic>?)
      //         ?.map((role) => Role.fromJson(role))
      //         .toSet() ??
      //     {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toString(),
      'employee_id': employeeId,
      'name': name,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      'password': password,
      'status': status,
      // 'roles': roles?.map((role) => role.toJson()).toList(),
    };
  }
}
