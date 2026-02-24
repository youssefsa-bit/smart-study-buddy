import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/features/home/domain/usecase/get_recent_files.dart';
import 'package:study_buddy/features/home/presentation/manager/home_event.dart';
import 'package:study_buddy/features/home/presentation/manager/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetRecentFilesUseCase getRecentFilesUseCase;

  HomeBloc({required this.getRecentFilesUseCase}) : super(HomeInitial()) {
    on<LoadRecentFilesEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final files = await getRecentFilesUseCase.call();
        emit(HomeLoaded(recentFiles: files));
      } catch (e) {
        emit(const HomeError(
            message: "Failed to load recent activity. Please try again."));
      }
    });
  }
}
