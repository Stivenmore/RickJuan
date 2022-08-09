// ignore_for_file: file_names

class Person {
  final String? name;
  final String? email;
  final String? uid;

  Person({required this.name, required this.email, required this.uid});

  factory Person.fromJson(Map<String, dynamic>? map) {
    if (map != null) {
      return Person(
          name: map['Name'] as String? ?? " ",
          email: map["Email"] as String? ?? " ",
          uid: map['UID'] as String? ?? " ");
    }
    return Person(name: '', email: '', uid: '');
  }
}
 