import 'package:study_buddy/features/home/domain/entities/study_material.dart';

abstract class HomeRepository {
  Future<List<StudyMaterial>> getRecentFiles();
}
