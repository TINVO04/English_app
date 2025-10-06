import 'package:flutter/widgets.dart';

/// Khoảng cách chuẩn toàn app
class AppSpacing {
  static const s4  = 4.0;
  static const s6  = 6.0;
  static const s8  = 8.0;
  static const s10 = 10.0;
  static const s12 = 12.0;
  static const s14 = 14.0;
  static const s16 = 16.0;
  static const s18 = 18.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
}

/// Bán kính bo góc
class AppRadius {
  static const r10 = 10.0;
  static const r12 = 12.0;
  static const r14 = 14.0;
  static const r16 = 16.0;
  static const pill = 999.0;
}

/// Một số EdgeInsets hay dùng
class Insets {
  static const all16 = EdgeInsets.all(AppSpacing.s16);
  static const h16 = EdgeInsets.symmetric(horizontal: AppSpacing.s16);
  static const v16 = EdgeInsets.symmetric(vertical: AppSpacing.s16);
  static const section = EdgeInsets.fromLTRB(AppSpacing.s16, 12, AppSpacing.s16, 0);
}
