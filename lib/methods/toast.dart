import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

toastError(GlobalKey<ScaffoldState> key, dynamic e) {
  String message = 'unknown error';
  if (e is PlatformException) message = e.message;
  final snackBar = SnackBar(content: Text(message));
  key.currentState.showSnackBar(snackBar);  
}