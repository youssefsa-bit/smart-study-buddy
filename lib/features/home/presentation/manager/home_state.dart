import 'package:equatable/equatable.dart';

import '../../domain/entities/study_material.dart';

abstract class HomeState extends Equatable{
  const HomeState();
  List<Object>get props => [];
}
class HomeInitial extends HomeState{}
class HomeLoading extends HomeState{}
class HomeLoaded extends HomeState{
  final List<StudyMaterial> recentFiles;
  const HomeLoaded({required this.recentFiles});
  List<Object> get props => [recentFiles];
}
class HomeError extends HomeState{
  final String message;
  const HomeError({required this.message});
  List<Object> get props => [message];
}