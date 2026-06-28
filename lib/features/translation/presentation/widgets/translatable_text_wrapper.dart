import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_buddy/core/services/injection_container.dart' as di;

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../manager/translation_bloc.dart';
import '../manager/translation_event.dart';
import '../manager/translation_state.dart';

class TranslatableTextWrapper extends StatefulWidget {
  final Widget child;
  final String targetLang;

  const TranslatableTextWrapper({
    super.key,
    required this.child,
    this.targetLang = 'ar',
  });

  @override
  State<TranslatableTextWrapper> createState() =>
      _TranslatableTextWrapperState();
}

class _TranslatableTextWrapperState extends State<TranslatableTextWrapper> {
  Offset? _lastPointerPosition;

  void _onSelectionChanged(
    BuildContext context,
    String? selectedText,
  ) async {
    final trimmed = selectedText?.trim() ?? '';
    if (trimmed.isEmpty) return;
    final prefs = di.sl<SharedPreferences>();
    final targetLang = prefs.getString('TRANSLATION_TARGET_LANG') ?? 'ar';
    context.read<TranslationBloc>().add(
          TranslateSelected(text: trimmed, targetLang: targetLang),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => _lastPointerPosition = event.position,
      onPointerMove: (event) => _lastPointerPosition = event.position,
      child: SelectionArea(
        onSelectionChanged: (value) =>
            _onSelectionChanged(context, value?.plainText),
        child: Stack(
          children: [
            widget.child,
            BlocBuilder<TranslationBloc, TranslationState>(
              builder: (context, state) {
                if (state is TranslationInitial) return const SizedBox.shrink();

                final screenHeight = MediaQuery.of(context).size.height;
                final pointerY = _lastPointerPosition?.dy ?? (screenHeight / 2);
                final showAtBottom = pointerY < screenHeight / 2;

                return _TranslationPopup(
                  state: state,
                  showAtBottom: showAtBottom,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslationPopup extends StatelessWidget {
  final TranslationState state;
  final bool showAtBottom;

  const _TranslationPopup({
    required this.state,
    required this.showAtBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: showAtBottom ? 100 : null,
      top: showAtBottom ? null : 100,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: _PopupCard(
          state: state,
          showAtBottom: showAtBottom,
        ),
      ),
    );
  }
}

class _PopupCard extends StatelessWidget {
  final TranslationState state;
  final bool showAtBottom;

  const _PopupCard({
    required this.state,
    required this.showAtBottom,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      alignment: showAtBottom ? Alignment.bottomCenter : Alignment.topCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Divider(height: 1, color: AppColors.border),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          Icon(Icons.translate_rounded, color: AppColors.primaryBlue, size: 18),
          const SizedBox(width: 8),
          Text(
            loc.translationTitle,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close_rounded,
                color: AppColors.textSecondary, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () =>
                context.read<TranslationBloc>().add(const ClearTranslation()),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (state is TranslationLoading) {
      final loading = state as TranslationLoading;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loading.originalText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is TranslationError) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                (state as TranslationError).message,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    if (state is TranslationLoaded) {
      final loaded = state as TranslationLoaded;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loaded.translation.originalText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              loaded.translation.translatedText,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                height: 1.55,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
