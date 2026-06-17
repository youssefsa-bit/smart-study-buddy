import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../manager/translation_bloc.dart';
import '../manager/translation_event.dart';
import '../manager/translation_state.dart';

/// Wraps [child] and shows a dynamic translation popup when text is selected.
///
/// Place this around any text-bearing subtree in the summary screen.
/// [targetLang] defaults to 'ar' but can be driven from user settings.
class TranslatableTextWrapper extends StatelessWidget {
  final Widget child;
  final String targetLang;

  const TranslatableTextWrapper({
    super.key,
    required this.child,
    this.targetLang = 'ar',
  });

  void _onSelectionChanged(
    BuildContext context,
    String? selectedText,
  ) {
    final trimmed = selectedText?.trim() ?? '';
    if (trimmed.isEmpty) return;

    context.read<TranslationBloc>().add(
          TranslateSelected(text: trimmed, targetLang: targetLang),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      onSelectionChanged: (value) =>
          _onSelectionChanged(context, value?.plainText),
      child: Stack(
        children: [
          child,
          BlocBuilder<TranslationBloc, TranslationState>(
            builder: (context, state) {
              if (state is TranslationInitial) return const SizedBox.shrink();
              return _TranslationPopup(state: state);
            },
          ),
        ],
      ),
    );
  }
}

class _TranslationPopup extends StatelessWidget {
  final TranslationState state;

  const _TranslationPopup({required this.state});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: _PopupCard(state: state),
      ),
    );
  }
}

class _PopupCard extends StatelessWidget {
  final TranslationState state;

  const _PopupCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      alignment: Alignment.bottomCenter,
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
            const Divider(height: 1, color: Colors.white10),
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
          const Icon(Icons.translate_rounded,
              color: AppColors.primaryBlue, size: 18),
          const SizedBox(width: 8),
          Text(
            loc.translationTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: Colors.white54, size: 20),
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
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
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
            // Original snippet
            Text(
              loaded.translation.originalText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            // Translated result
            Text(
              loaded.translation.translatedText,
              style: const TextStyle(
                color: Colors.white,
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
