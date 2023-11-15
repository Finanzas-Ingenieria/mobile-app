class Client {
  int id;
  String name;
  String lastname;

  Client({
    required this.id,
    required this.name,
    required this.lastname,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastname': lastname,
      };

  @override
  String toString() {
    return 'Client{id: $id, name: $name, lastname: $lastname}';
  }

  //empty client
  static Client empty() {
    return Client(
      id: 0,
      name: '',
      lastname: '',
    );
  }
}
