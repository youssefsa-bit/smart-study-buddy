import 'package:equatable/equatable.dart';

import '../../domain/entities/summary_entity.dart';

abstract class SummaryState extends Equatable {
  const SummaryState();
  @override
  List<Object?> get props => [];
}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {
  final int stepIndex;
  const SummaryLoading({this.stepIndex = 0});
  @override
  List<Object?> get props => [stepIndex];
}

class SummaryLoaded extends SummaryState {
  final SummaryEntity summary;
  const SummaryLoaded(this.summary);
  @override
  List<Object?> get props => [summary];
}

class SummaryError extends SummaryState {
  final String message;
  const SummaryError(this.message);
  @override
  List<Object?> get props => [message];
}

class SummaryPdfDownloading extends SummaryState {
  final SummaryEntity summary;
  const SummaryPdfDownloading(this.summary);
  @override
  List<Object?> get props => [summary];
}

class SummaryPdfDownloaded extends SummaryState {
  final SummaryEntity summary;
  final String savedPath;
  const SummaryPdfDownloaded(this.summary, this.savedPath);
  @override
  List<Object?> get props => [summary, savedPath];
}

class SummaryPdfDownloadError extends SummaryState {
  final SummaryEntity summary;
  final String message;
  const SummaryPdfDownloadError(this.summary, this.message);
  @override
  List<Object?> get props => [summary, message];
}
