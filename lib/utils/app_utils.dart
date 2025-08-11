import 'package:connectivity_plus/connectivity_plus.dart';

class AppUtils {
  AppUtils._();

  static Future<bool> checkInternet() async {
    // Get the connectivity result (Wi-Fi, mobile data, or none)
    var connectivityResult = await Connectivity().checkConnectivity();

    // Check if the connection is mobile data or Wi-Fi
    print('connectivityResult ==> ${connectivityResult}');
    if (connectivityResult.any((item) => (item == ConnectivityResult.mobile) || (item == ConnectivityResult.wifi))) {
      print('connectivityResult1 ==> ${connectivityResult}');
      return true;
    }

    print('connectivityResult2 ==> ${connectivityResult}');
    // If there's no connection (ConnectivityResult.none)
    return false;
  }

  static bool validateEmail(String value) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern, caseSensitive: false);  // Ensuring case insensitivity

    return regex.hasMatch(value);
  }



  static bool isValidMobileNumber(String phoneNumber) {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedNumber.length != 10 || !RegExp(r'^\d{10}$').hasMatch(cleanedNumber)) {
      return true;
    }
    if (RegExp(r'(\d)\1{9}').hasMatch(cleanedNumber)) {
      return true;
    }
    return false;
  }
}
