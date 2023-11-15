class User {
  int id;
  String name;
  String lastname;
  String email;
  String password;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, lastname: $lastname, email: $email, password: $password}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }

  //empty user
  static User empty() {
    return User(
      id: 0,
      name: '',
      lastname: '',
      email: '',
      password: '',
    );
  }

}
