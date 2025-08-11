import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData icon;
  const CircleIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: 28, backgroundColor: const Color(0xFF0057B8), child: Icon(icon, color: Colors.white, size: 28));
  }
}
