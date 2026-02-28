import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  const SummaryEvent();
  @override
  List<Object?> get props => [];
}

class LoadSummary extends SummaryEvent {
  final String pdfId;
  const LoadSummary(this.pdfId);
  @override
  List<Object?> get props => [pdfId];
}
