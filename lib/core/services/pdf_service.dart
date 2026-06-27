import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../features/summary/domain/entities/summary_entity.dart';

class PdfService {
  Future<String> saveSummaryAsPdf(
      {required SummaryEntity summary,
      required String fileName,
      required AppLocalizations loc}) async {
    final Uint8List bytes =
        await _buildPdf(summary: summary, fileName: fileName, loc: loc);

    final docsDir = await getApplicationDocumentsDirectory();
    final summariesDir = Directory('${docsDir.path}/Summaries');
    if (!summariesDir.existsSync()) {
      summariesDir.createSync(recursive: true);
    }

    final safeName = _sanitize(fileName);
    final file = _uniqueFile(summariesDir, '${safeName}_generated_summary');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  File _uniqueFile(Directory dir, String baseName) {
    var file = File('${dir.path}/$baseName.pdf');
    if (!file.existsSync()) return file;
    var counter = 1;
    while (true) {
      file = File('${dir.path}/${baseName}_$counter.pdf');
      if (!file.existsSync()) return file;
      counter++;
    }
  }

  Future<Uint8List> _buildPdf(
      {required SummaryEntity summary,
      required String fileName,
      required AppLocalizations loc}) async {
    final doc = pw.Document();
    final ttf = await PdfGoogleFonts.cairoRegular();
    final ttfBold = await PdfGoogleFonts.cairoBold();
    final isRtl = loc.localeName == 'ar';

    const bgColor = PdfColor.fromInt(0xFF0D0D0D);
    const surfaceColor = PdfColor.fromInt(0xFF1A1C20);
    const blueColor = PdfColor.fromInt(0xFF246BFD);
    const highlightBg = PdfColor.fromInt(0xFF12203A);
    const highlightBdr = PdfColor.fromInt(0xFF2A4A9A);
    const white = PdfColors.white;
    const grey = PdfColor.fromInt(0xFFB0B0B0);

    final titleStyle = pw.TextStyle(
        font: ttfBold, fontSize: 13, color: white);
    final bodyStyle = pw.TextStyle(
        font: ttf, fontSize: 10, color: grey, lineSpacing: 2, height: 1.4);
    final h1Style = pw.TextStyle(
        font: ttfBold, fontSize: 20, color: white);
    final subStyle = pw.TextStyle(
        font: ttf, fontSize: 11, color: grey);
    final brandStyle = pw.TextStyle(
        font: ttf, fontSize: 9, color: blueColor, fontStyle: pw.FontStyle.italic);

    pw.Widget bullet(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 4,
              height: 4,
              margin: const pw.EdgeInsets.only(top: 5, right: 8),
              decoration: const pw.BoxDecoration(
                color: blueColor,
                shape: pw.BoxShape.circle,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                text.replaceAll('**', '').trim(),
                style: bodyStyle,
              ),
            ),
          ],
        ),
      );
    }

    List<pw.Widget> cardItems({
      required String title,
      required List<pw.Widget> children,
      bool highlight = false,
    }) {
      final color = highlight ? highlightBg : surfaceColor;
      final border =
          highlight ? pw.Border.all(color: highlightBdr, width: 1) : null;

      final List<pw.Widget> result = [];

      result.add(
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.only(
              left: 14, right: 14, top: 14, bottom: 10),
          decoration: pw.BoxDecoration(
            color: color,
            borderRadius:
                const pw.BorderRadius.vertical(top: pw.Radius.circular(8)),
            border: border,
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                width: 3,
                height: 13,
                decoration: pw.BoxDecoration(
                  color: blueColor,
                  borderRadius: pw.BorderRadius.circular(2),
                ),
              ),
              pw.SizedBox(width: 7),
              pw.Text(title, style: titleStyle),
            ],
          ),
        ),
      );

      for (int i = 0; i < children.length; i++) {
        final isLast = i == children.length - 1;
        result.add(
          pw.Container(
            width: double.infinity,
            padding: pw.EdgeInsets.only(
              left: 14,
              right: 14,
              bottom: isLast ? 14 : 0,
            ),
            decoration: pw.BoxDecoration(
              color: color,
              borderRadius: isLast
                  ? const pw.BorderRadius.vertical(
                      bottom: pw.Radius.circular(8))
                  : pw.BorderRadius.zero,
              border: border,
            ),
            child: children[i],
          ),
        );
      }

      result.add(pw.SizedBox(height: 14));
      return result;
    }

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 40),
          textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          buildBackground: (_) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: bgColor),
          ),
        ),
        build: (_) => [
          pw.Container(
            width: double.infinity,
            margin: const pw.EdgeInsets.only(bottom: 18),
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFF111D30),
              borderRadius: pw.BorderRadius.circular(12),
              border: pw.Border.all(
                  color: const PdfColor.fromInt(0xFF1E3A6E), width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(loc.pdfStudySummary, style: h1Style),
                pw.SizedBox(height: 4),
                pw.Text(fileName, style: subStyle),
                pw.SizedBox(height: 4),
                pw.Text(loc.pdfGeneratedBy, style: brandStyle),
              ],
            ),
          ),

          ...cardItems(
            title: loc.summaryMainTopic,
            highlight: true,
            children: [pw.Text(summary.mainTopic, style: bodyStyle)],
          ),
          ...cardItems(
            title: loc.summaryKeyConcepts,
            children: summary.keyConcepts.map(bullet).toList(),
          ),
          ...cardItems(
            title: loc.summaryImportantDetails,
            children: summary.importantDetails.map(bullet).toList(),
          ),
          ...cardItems(
            title: loc.summaryConclusion,
            children: [pw.Text(summary.conclusion, style: bodyStyle)],
          ),
        ],
      ),
    );

    return doc.save();
  }

  String _sanitize(String name) =>
      name.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(' ', '_');
}
