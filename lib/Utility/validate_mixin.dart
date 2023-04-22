import 'package:flutter/material.dart'; 


class ValidationMixin {

  String? validateTextField(BuildContext context, String value) {
    if (value.isEmpty) {
      return  "this_field_cannot_be_empty" ;//AppLocalizations.of(context).this_field_cannot_be_empty;
    }
    return null;
  }
  String? validateEmail(BuildContext context, String value) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value);

    if(emailValid == false){
      return  "enter_valid_email";//AppLocalizations.of(context).enter_valid_email;
    }
    // if (!value.contains('@')) {
    //   return 'Please Enter a Valid Email Address';
    // }
    return null;
  }

  String? validatePassword(BuildContext context, String value) {
    if (value.length < 8) {
      return  "password_length_at_least_eight";//AppLocalizations.of(context).password_length_at_least_eight;
    }
    return null;
  }

  String? validatePhoneNumber(BuildContext context, String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return  "enter_phone";//AppLocalizations.of(context).enter_phone;
    }else if (!regExp.hasMatch(value)) {
      return  "enter_valid_phone";//AppLocalizations.of(context).enter_valid_phone;
    }
    return null;
  }

  String? validateUserField(BuildContext context, String value) {
    if (value.isEmpty) {
      return  "this_field_cannot_be_empty";//AppLocalizations.of(context).this_field_cannot_be_empty;
    }
    if (value.length < 2) {
      return  "user_name_at_least_three";//AppLocalizations.of(context).user_name_at_least_three;
    }
    if (value.contains(' ')) {
      return  "remove_whitespace";//AppLocalizations.of(context).remove_whitespace;
    }
    return null;
  }

}
