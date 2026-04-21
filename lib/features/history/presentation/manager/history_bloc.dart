import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;

  HistoryBloc({required this.getHistoryUseCase}) : super(HistoryInitial()) {
    on<LoadHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        final items = await getHistoryUseCase.call();
        emit(HistoryLoaded(items));
      } catch (e) {
        emit(HistoryError("Failed to load history"));
      }
    });
  }
}
