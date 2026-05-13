import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  const PdfGenerator();

  Future<Uint8List> createFromImages(List<Uint8List> images) async {
    final document = pw.Document();

    for (final imageBytes in images) {
      final image = pw.MemoryImage(imageBytes);

      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) {
            return pw.Center(
              child: pw.Image(
                image,
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
    }

    return document.save();
  }
}