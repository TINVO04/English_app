import 'package:flutter/material.dart';

class AppButton {
  /// Nút chính: nền đen (#0B0F1A), chữ trắng, full width
  static Widget primary({
    required String text,
    required VoidCallback? onPressed,
    double height = 44,
    BorderRadiusGeometry radius = const BorderRadius.all(Radius.circular(12)),
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// Nút viền mảnh: nền trắng, viền #E5E7EB, full width
  static Widget outlined({
    required String text,
    required VoidCallback onPressed,
    double height = 44,
    BorderRadiusGeometry radius = const BorderRadius.all(Radius.circular(12)),
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: radius),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
