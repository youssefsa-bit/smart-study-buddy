import 'dart:io';

void main() {
  final errors = '''
  error - Invalid constant value - lib/features/auth/presentation/pages/login_page.dart:115:42 - invalid_constant
  error - Invalid constant value - lib/features/auth/presentation/pages/register_page.dart:146:40 - invalid_constant
  error - Invalid constant value - lib/features/auth/presentation/pages/register_page.dart:178:44 - invalid_constant
  error - Invalid constant value - lib/features/flashcards/presentation/widgets/flashcard_view.dart:94:28 - invalid_constant
  error - Invalid constant value - lib/features/history/presentation/pages/history_screen.dart:122:40 - invalid_constant
  error - Invalid constant value - lib/features/history/presentation/pages/history_screen.dart:202:36 - invalid_constant
  error - Invalid constant value - lib/features/history/presentation/pages/history_screen.dart:220:50 - invalid_constant
  error - Invalid constant value - lib/features/history/presentation/pages/history_screen.dart:226:42 - invalid_constant
  error - Invalid constant value - lib/features/history/presentation/pages/history_screen.dart:255:38 - invalid_constant
  error - Invalid constant value - lib/features/home/presentation/pages/home_screen.dart:56:34 - invalid_constant
  error - Invalid constant value - lib/features/home/presentation/pages/upper_home.dart:41:32 - invalid_constant
  error - Invalid constant value - lib/features/home/presentation/widgets/upload_material_card.dart:33:24 - invalid_constant
  error - Invalid constant value - lib/features/mcq/presentation/pages/quiz_view.dart:80:30 - invalid_constant
  error - Invalid constant value - lib/features/profile/presentation/pages/change_password_screen.dart:119:38 - invalid_constant
  error - Invalid constant value - lib/features/profile/presentation/pages/edit_profile_screen.dart:111:38 - invalid_constant
  error - Invalid constant value - lib/features/profile/presentation/pages/edit_profile_screen.dart:150:32 - invalid_constant
  error - Invalid constant value - lib/features/profile/presentation/pages/profile_screen.dart:193:40 - invalid_constant
  error - Invalid constant value - lib/features/summary/presentation/pages/summary_screen.dart:380:34 - invalid_constant
  error - Invalid constant value - lib/features/translation/presentation/widgets/translatable_text_wrapper.dart:153:22 - invalid_constant
  error - Invalid constant value - lib/features/translation/presentation/widgets/translatable_text_wrapper.dart:202:26 - invalid_constant
  error - Invalid constant value - lib/features/upload/presentation/pages/upload_screen.dart:133:34 - invalid_constant
  error - Invalid constant value - lib/features/upload/presentation/pages/upload_screen.dart:152:36 - invalid_constant
  error - Invalid constant value - lib/features/upload/presentation/pages/upload_screen.dart:160:36 - invalid_constant
  error - Invalid constant value - lib/features/upload/presentation/pages/upload_screen.dart:185:40 - invalid_constant
  error - Invalid constant value - lib/features/upload/presentation/pages/upload_screen.dart:263:38 - invalid_constant
  error - Invalid constant value - lib/features/upload/presentation/widgets/action_card.dart:83:30 - invalid_constant
  error - Invalid constant value - lib/features/upload/presentation/widgets/action_card.dart:92:30 - invalid_constant
  error - Invalid constant value - lib/main.dart:62:26 - invalid_constant
  ''';
  
  final regex = RegExp(r' - (lib[/\\][^:]+):(\d+):(\d+) - invalid_constant');
  for (final match in regex.allMatches(errors)) {
    final file = File(match.group(1)!.replaceAll('\\', '/'));
    if (!file.existsSync()) {
      print('File not found: \${file.path}');
      continue;
    }
    final lineNum = int.parse(match.group(2)!) - 1;
    final lines = file.readAsLinesSync();
    if (lines[lineNum].contains('const')) {
      lines[lineNum] = lines[lineNum].replaceFirst('const ', '');
      lines[lineNum] = lines[lineNum].replaceFirst('const', '');
      file.writeAsStringSync(lines.join('\n'));
      print('Fixed \${file.path}:\${lineNum+1}');
    }
  }
}
