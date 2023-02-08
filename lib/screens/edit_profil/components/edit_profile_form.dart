import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/firestoreService/userService.dart';
import 'package:shop_app/helper/response.dart';
import 'package:shop_app/models/User.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String firstName;
  String lastName;
  String phoneNumber;
  String address;
  String userId;
  // Profil profil;
  bool isLoading = false;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void setLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;
    setState(() {
      userId = user.uid;
    });
    loadProfil(userId);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    addressController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> loadProfil(userId) async {
    Profil resp =  getUser(userId) as Profil;
    setState(() {
      firstName = resp.firstName;
      lastName = resp.lastName;
      phoneNumber = resp.phoneNumber;
      address = resp.address;
      firstNameController.text = resp.firstName;
    });
  }

  Future<void> openDialog() async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        children: [
          Container(
              height: 260,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('Votre compte a été mofifié avec succès'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: DefaultButton(
                      text: "Ok",
                      press: () => Navigator.pop(context, true),
                    ),
                  )
                ]),
              ))
        ],
      ),
    )) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildfirstNameFormField(firstName),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(lastName),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(phoneNumber),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(address),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Modifier",
            isLoading: isLoading,
            press: () async {
              setLoading();
              if (_formKey.currentState.validate()) {
                Response resp = await updateProfil(userId, {
                  'id': userId,
                  'first_name': firstName,
                  'last_name': lastName,
                  'phoneNumber': phoneNumber,
                  'address': address
                });
                if (resp?.status == 200) {
                  openDialog();
                  setLoading();
                }
              }
              setLoading();
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField(addressValue) {
    return TextFormField(
      initialValue: addressValue,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) => setState(() {
        address = value;
      }),
      validator: (value) {
        if (value.isEmpty) {
          addError(error: " le champ adresse est vide");
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Adresse",
        hintText: addressValue != null ? addressValue : "Entrer l'adresse",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(phone) {
    return TextFormField(
      initialValue: phone,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) => setState(() {
        phoneNumber = value;
      }),
      decoration: InputDecoration(
        labelText: "Numéro",
        hintText: phone != null ? phone : "Enter le numéro de téléphone",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "entré un numéro de téléphone");
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        return null;
      },
    );
  }

  TextFormField buildLastNameFormField(lastNameValue) {
    return TextFormField(
      initialValue: lastNameValue,
      onChanged: (value) => setState(() {
        lastName = value;
      }),
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "le champ prénom est vide");
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Prénom",
        hintText: lastNameValue != null ? lastNameValue : "Entrer le prénom",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildfirstNameFormField(name) {
    return TextFormField(
      controller: firstNameController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            firstName = value;
          });
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        } else if (!wordValidatorRegExp.hasMatch(value)) {
          addError(error: "Certaines valeurs ne sont pas valides");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Noms",
        hintText: name != null ? name : "Entrer le nom",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
