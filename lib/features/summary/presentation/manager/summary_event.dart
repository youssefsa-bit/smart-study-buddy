import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/summary_entity.dart';

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

class FetchExistingSummary extends SummaryEvent {
  final int resultId;
  const FetchExistingSummary(this.resultId);
}

class DownloadSummaryPdf extends SummaryEvent {
  final String pdfId;
  final SummaryEntity summary;
  final String fileName;
  final AppLocalizations loc;
  const DownloadSummaryPdf(
      {required this.pdfId, required this.summary, required this.fileName, required this.loc});
  @override
  List<Object?> get props => [pdfId, summary, fileName];
}
