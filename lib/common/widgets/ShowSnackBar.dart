import 'package:flutter/material.dart';
import 'package:sathiclub/constants/themeColors.dart';

void showSnackBar({required BuildContext context, required String content }){
  final sContent=  content.split('] ');


  ScaffoldMessenger.of(context).
  showSnackBar(
      SnackBar(
        content: Text(sContent.last),
      ),
  );
}