import 'package:flutter/material.dart';
import 'package:salsel_express/util/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppUtils {
  static Future<void> launchWhatsApp(String phoneNumber, BuildContext context) async {
    final whatsappUrl = 'https://wa.me/$phoneNumber';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      CustomToast.showAlert(context, 'Could not launch WhatsApp.');
    }
  }
}
