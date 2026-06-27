import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/services/injection_container.dart' as di;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class TranslationLanguageScreen extends StatefulWidget {
  const TranslationLanguageScreen({super.key});

  @override
  State<TranslationLanguageScreen> createState() =>
      _TranslationLanguageScreenState();
}

class _TranslationLanguageScreenState extends State<TranslationLanguageScreen> {
  String _selectedLangCode = 'ar';

  final List<Map<String, String>> _languages = [
    {'code': 'ar', 'name': 'Arabic (العربية)', 'flag': '🇸🇦'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'es', 'name': 'Spanish (Español)', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French (Français)', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German (Deutsch)', 'flag': '🇩🇪'},
    {'code': 'zh', 'name': 'Chinese (中文)', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': 'Japanese (日本語)', 'flag': '🇯🇵'},
    {'code': 'ru', 'name': 'Russian (Русский)', 'flag': '🇷🇺'},
    {'code': 'hi', 'name': 'Hindi (हिन्दी)', 'flag': '🇮🇳'},
    {'code': 'pt', 'name': 'Portuguese (Português)', 'flag': '🇵🇹'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() {
    final prefs = di.sl<SharedPreferences>();
    setState(() {
      _selectedLangCode = prefs.getString('TRANSLATION_TARGET_LANG') ?? 'ar';
    });
  }

  void _setLanguage(String code) async {
    final prefs = di.sl<SharedPreferences>();
    print(code);
    await prefs.setString('TRANSLATION_TARGET_LANG', code);
    setState(() {
      _selectedLangCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(loc.translationLanguageTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final lang = _languages[index];
          final isSelected = lang['code'] == _selectedLangCode;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: AppColors.primaryBlue, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading:
              Text(lang['flag']!, style: const TextStyle(fontSize: 28)),
              title: Text(
                lang['name']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle_rounded,
                  color: AppColors.primaryBlue, size: 28)
                  : const SizedBox.shrink(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              onTap: () => _setLanguage(lang['code']!),
            ),
          );
        },
      ),
    );
  }
}