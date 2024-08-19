import 'package:flutter/material.dart';
import 'package:get/get.dart';

void ErrorMessage(err, message) {
    Get.snackbar(
      err,
      message,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
      borderWidth: 3,
      borderColor: err == "error" ? Colors.red : Colors.green,
    );
  }