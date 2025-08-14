import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Widget/webview_widget.dart';
import '../DrawerScreen/drawer_screen.dart';

/// ✅ Mission Screen
class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mission Statement',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18, fontFamily: "Poppins_Bold"),
        ),
      ),
      body: const CustomWebView(url: "https://www.edco.com/mission"),
    );
  }
}

/// ✅ Privacy Screen
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18, fontFamily: "Poppins_Bold"),
        ),
      ),
      body: const CustomWebView(url: "https://www.edco.com/privacyinfo"),
    );
  }
}

/// ✅ About Screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Our Company',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18, fontFamily: "Poppins_Bold"),
        ),
      ),
      body: const CustomWebView(url: "https://www.edco.com/aboutus"),
    );
  }
}

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Contact Us',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18, fontFamily: "Poppins_Bold"),
        ),
      ),
      body: const CustomWebView(url: "https://www.edco.com/contactus"),
    );
  }
}

class AccountDelete extends StatelessWidget {
  const AccountDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Account Delete',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18, fontFamily: "Poppins_Bold"),
        ),
      ),
      body: const CustomWebView(url: "https://docs.google.com/forms/d/e/1FAIpQLSfMTLBW0muDJH-dKjgR_c5o4H36mnYaikJYzAxLnTM55b51yw/viewform"),
    );
  }
}
