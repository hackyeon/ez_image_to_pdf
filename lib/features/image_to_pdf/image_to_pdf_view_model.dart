import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';

import '../../core/pdf/pdf_generator.dart';
import 'models/selected_image.dart';

class ImageToPdfViewModel extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  final PdfGenerator _pdfGenerator = const PdfGenerator();

  final List<SelectedImage> _images = [];

  bool _isLoading = false;

  List<SelectedImage> get images => List.unmodifiable(_images);

  bool get isLoading => _isLoading;

  bool get canCreatePdf => _images.isNotEmpty && !_isLoading;

  Future<void> pickImages() async {
    final pickedFiles = await _imagePicker.pickMultiImage();

    if (pickedFiles.isEmpty) return;

    for (final file in pickedFiles) {
      final bytes = await file.readAsBytes();

      _images.add(
        SelectedImage(
          name: file.name,
          bytes: bytes,
        ),
      );
    }

    notifyListeners();
  }

  Future<void> addImagesFromFiles(List<XFile> files) async {
    if (files.isEmpty) return;

    for (final file in files) {
      final bytes = await file.readAsBytes();

      _images.add(
        SelectedImage(
          name: file.name,
          bytes: bytes,
        ),
      );
    }

    notifyListeners();
  }

  void removeImage(int index) {
    if (index < 0 || index >= _images.length) return;

    _images.removeAt(index);
    notifyListeners();
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final image = _images.removeAt(oldIndex);
    _images.insert(newIndex, image);

    notifyListeners();
  }

  Future<void> createPdf() async {
    if (_images.isEmpty || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final imageBytesList = _images.map((image) => image.bytes).toList();

      final Uint8List pdfBytes = await _pdfGenerator.createFromImages(
        imageBytesList,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'ez_image_to_pdf.pdf',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}