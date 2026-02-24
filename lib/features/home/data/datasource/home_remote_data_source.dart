import 'package:study_buddy/features/home/data/models/study_material_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<StudyMaterialModel>> getRecentFiles();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override

  // will be changed later once api are come
  Future<List<StudyMaterialModel>> getRecentFiles() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      StudyMaterialModel(
        id: '1',
        title: 'Machine Learning Basics',
        subject: 'Computer Science',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        type: 'pdf',
      ),
      StudyMaterialModel(
        id: '2',
        title: 'Organic Chemistry Ch.4',
        subject: 'Chemistry',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        type: 'quiz',
      ),
    ];
  }
}
