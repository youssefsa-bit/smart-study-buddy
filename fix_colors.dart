import 'dart:io';

void main() {
  final Map<RegExp, String> replacements = {
    RegExp(r'const\s+Color\(0xFF101828\)', caseSensitive: false): 'AppColors.surface',
    RegExp(r'Color\(0xff111216\)', caseSensitive: false): 'AppColors.background',
    RegExp(r'const\s+Color\(0xFF2E8CFF\)', caseSensitive: false): 'AppColors.primaryBlue',
    RegExp(r'Color\(0xFF2E8CFF\)', caseSensitive: false): 'AppColors.primaryBlue',
    RegExp(r'const\s+Color\(0xFF23303F\)', caseSensitive: false): 'AppColors.border',
    RegExp(r'Color\(0xFF23303F\)', caseSensitive: false): 'AppColors.border',
    RegExp(r'const\s+Color\(0xFF1A1F26\)', caseSensitive: false): 'AppColors.surfaceHighlight',
    RegExp(r'const\s+Color\(0xFF3A4655\)', caseSensitive: false): 'AppColors.border',
    RegExp(r'const\s+Color\(0xFF0F141A\)', caseSensitive: false): 'AppColors.background',
    RegExp(r'const\s+Color\(0xFF1A283A\)', caseSensitive: false): 'AppColors.surfaceHighlight',
    RegExp(r'Color\(0xFF6B7684\)', caseSensitive: false): 'AppColors.textSecondary',
    RegExp(r'const\s+Color\(0xff002f4d\)', caseSensitive: false): 'AppColors.surfaceHighlight',
    RegExp(r'const\s+Color\(0xff181b20\)', caseSensitive: false): 'AppColors.surface',
    RegExp(r'const\s+Color\(0xff0f85dc\)', caseSensitive: false): 'AppColors.primaryBlue',
    RegExp(r'const\s+Color\(0xff7c7f84\)', caseSensitive: false): 'AppColors.textSecondary',
    RegExp(r'const\s+Color\(0xFF0D1F16\)', caseSensitive: false): 'AppColors.flashcardImg',
    RegExp(r'const\s+Color\(0xFF143021\)', caseSensitive: false): 'AppColors.flashcardImg',
    RegExp(r'Color\(0xFF00C853\)', caseSensitive: false): 'AppColors.flashcardGreen',
  };

  final dir = Directory('lib');
  for (final file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = file.readAsStringSync();
      bool changed = false;
      
      // 1. Map Hex Colors to AppColors
      replacements.forEach((regex, replacement) {
        if (regex.hasMatch(content)) {
          content = content.replaceAll(regex, replacement);
          changed = true;
        }
      });
      
      // 2. Strip 'const' from widgets that now use AppColors
      if (changed) {
        final pattern = RegExp(r'\bconst\s+([A-Z][a-zA-Z0-9_<>]*(\.[a-zA-Z0-9_]+)?\s*\([^)]*AppColors\.)', dotAll: true);
        while (pattern.hasMatch(content)) {
          content = content.replaceAllMapped(pattern, (m) => m.group(1)!);
        }
        
        // Ensure AppColors is imported
        if (!content.contains('core/constants/app_colors.dart') && !content.contains('AppColors')) {
          content = "import 'package:study_buddy/core/constants/app_colors.dart';\n" + content;
        }
        
        file.writeAsStringSync(content);
        print('Fixed \${file.path}');
      }
    }
  }
}
