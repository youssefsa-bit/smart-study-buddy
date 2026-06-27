import 'package:equatable/equatable.dart';

abstract class McqEvent extends Equatable {
  const McqEvent();
  @override
  List<Object?> get props => [];
}

class GenerateMcqEvent extends McqEvent {
  final String pdfId;
  const GenerateMcqEvent(this.pdfId);

  @override
  List<Object?> get props => [pdfId];
}

class GetExistingMCQ extends McqEvent {
  final int resultId;
  const GetExistingMCQ(this.resultId);

  @override
  List<Object?> get props => [resultId];
}
