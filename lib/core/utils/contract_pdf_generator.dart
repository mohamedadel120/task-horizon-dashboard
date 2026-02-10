// import 'dart:io';
// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:task_dashboard/core/utils/pdf_localized_strings.dart';
// import 'package:task_dashboard/features/home/data/models/advertisements_model.dart';
// import 'package:task_dashboard/features/outgoing_contract/data/models/outgoing_contract_details_model.dart';

/// Generates a PDF that matches exactly the 3 pages shown on screen
class ContractPdfGenerator {
  /*
  static late pw.Font _regularFont;
  static late pw.Font _boldFont;
  static late PdfLocalizedStrings _strings;
  static const _orange = PdfColor.fromInt(0xFFFF9800);
  static const _grey = PdfColor.fromInt(0xFFE0E0E0);
  static const _greyDark = PdfColor.fromInt(0xFF757575);

  /// Generate and save PDF from contract data
  static Future<String> generateAndSave(
    OutgoingContractDetails contract,
    PdfLocalizedStrings strings,
  ) async {
    _strings = strings;

    // Load Arabic fonts
    final regularFontData = await rootBundle.load(
      'assets/fonts/Changa/static/Changa-Regular.ttf',
    );
    final boldFontData = await rootBundle.load(
      'assets/fonts/Changa/static/Changa-Bold.ttf',
    );
    _regularFont = pw.Font.ttf(regularFontData);
    _boldFont = pw.Font.ttf(boldFontData);

    // Download images
    final imageBytes = await _downloadImages(contract.advertisement.media);

    final pdf = pw.Document();

    // Page 1: Contract Details
    pdf.addPage(_buildContractDetailsPage(contract));

    // Page 2: Images
    pdf.addPage(_buildImagesPage(imageBytes));

    // Page 3: Terms
    pdf.addPage(_buildTermsPage());

    // Save PDF
    final directory = await _getDownloadDirectory();
    final fileName =
        'contract_${contract.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  /// Download all images from URLs
  static Future<List<Uint8List>> _downloadImages(List<Media> media) async {
    final images = <Uint8List>[];
    final urls = media.take(4).map((m) => m.url).toList();

    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    for (final url in urls) {
      try {
        if (kDebugMode) {
          debugPrint('Downloading image: $url');
        }

        final response = await dio.get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        if (response.statusCode == 200 && response.data != null) {
          images.add(Uint8List.fromList(response.data!));
          if (kDebugMode) {
            debugPrint(
              'Image downloaded successfully: ${response.data!.length} bytes',
            );
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Failed to download image: $url - Error: $e');
        }
        // Skip failed images
      }
    }

    dio.close();
    return images;
  }

  // ... (rest of the code omitted for brevity but commented out)
  */
}
