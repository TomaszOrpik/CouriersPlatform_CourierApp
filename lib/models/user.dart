class User {
  final String id;
  final num phoneNumber;
  final String firstName;
  final String lastName;
  final String street;
  final String postCode;
  final String city;

  User(
      {required this.id,
      required this.phoneNumber,
      required this.firstName,
      required this.lastName,
      required this.street,
      required this.postCode,
      required this.city});
}
