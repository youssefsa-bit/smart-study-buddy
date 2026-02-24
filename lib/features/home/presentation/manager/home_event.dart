import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable{
  const HomeEvent();
  List<Object>get props=> [];
}
class LoadRecentFilesEvent extends HomeEvent{}