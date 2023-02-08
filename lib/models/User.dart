import 'package:flutter/cupertino.dart';

class Profil {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;

  Profil(
      {@required this.id,
      @required this.firstName,
      this.lastName,
      @required this.phoneNumber,
      @required this.address});

  Profil.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        phoneNumber = json['phoneNumber'],
        address = json['address'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address
      };

  static toJsonMap(Object data) {}
}
