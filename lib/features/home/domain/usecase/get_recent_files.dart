import 'package:study_buddy/features/home/domain/entities/study_material.dart';
import 'package:study_buddy/features/home/domain/repositories/home_repository.dart';

class GetRecentFilesUseCase {
  final HomeRepository repository;

  GetRecentFilesUseCase(this.repository);

  Future<List<StudyMaterial>> call() async {
    return await repository.getRecentFiles();
  }
}
