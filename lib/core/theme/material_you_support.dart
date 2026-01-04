import 'package:dynamic_color/dynamic_color.dart';

final class MaterialYouSupport {
  const MaterialYouSupport._();

  static Future<bool> isSupported() async {
    try {
      final palette = await DynamicColorPlugin.getCorePalette();
      return palette != null;
    } catch (_) {
      return false;
    }
  }
}
