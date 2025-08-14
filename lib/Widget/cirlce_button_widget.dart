import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final bool? isLike;
  const CircleIcon({required this.icon, this.isLike});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 28,
        backgroundColor: const Color(0xFF0057B8),
        child: Icon(icon, color: isLike == true ? Colors.red : Colors.white, size: 28));
  }
}
