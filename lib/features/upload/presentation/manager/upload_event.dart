import 'dart:io';

import '../../domain/entities/upload_action.dart';

abstract class UploadEvent {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

class PickFileEvent extends UploadEvent {
  final File file;

  const PickFileEvent(this.file);

  @override
  List<Object?> get props => [file];
}

class RemoveFileEvent extends UploadEvent {}

class SelectActionEvent extends UploadEvent {
  final UploadAction action;

  const SelectActionEvent(this.action);

  @override
  List<Object?> get props => [action];
}
class ProcessFileEvent extends UploadEvent {}
class ResetUploadEvent extends UploadEvent {}