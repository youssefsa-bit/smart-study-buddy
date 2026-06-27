import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/translate_text_usecase.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final TranslateTextUseCase translateTextUseCase;

  CancelToken? _cancelToken;

  TranslationBloc({required this.translateTextUseCase})
      : super(const TranslationInitial()) {
    on<TranslateSelected>(_onTranslateSelected);
    on<ClearTranslation>(_onClearTranslation);
  }

  Future<void> _onTranslateSelected(
    TranslateSelected event,
    Emitter<TranslationState> emit,
  ) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    emit(TranslationLoading(originalText: event.text));
    try {
      final translation = await translateTextUseCase(
        text: event.text,
        targetLang: event.targetLang,
        cancelToken: _cancelToken,
      );
      emit(TranslationLoaded(translation: translation));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      emit(TranslationError(message: e.message ?? 'Network error'));
    } catch (e) {
      emit(TranslationError(message: e.toString()));
    }
  }

  void _onClearTranslation(
    ClearTranslation event,
    Emitter<TranslationState> emit,
  ) {
    _cancelToken?.cancel();
    _cancelToken = null;
    emit(const TranslationInitial());
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
