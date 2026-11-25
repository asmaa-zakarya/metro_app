import 'package:flutter/foundation.dart';

/// App-wide language state. It keeps the selected language while navigating
/// between screens during the current app session.
class AppLanguage {
  AppLanguage._();

  static final ValueNotifier<bool> isArabic = ValueNotifier<bool>(true);
}
