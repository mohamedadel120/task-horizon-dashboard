import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_dashboard/core/helpers/api_constants.dart';
import 'package:task_dashboard/core/networking/api_client.dart';

class PdfDownloader {
  final ApiClient apiClient;

  PdfDownloader(this.apiClient);

  Future<String> downloadContractPdf(int contractId) async {
    try {
      final directory = await _getDownloadDirectory();
      final fileName = 'contract_$contractId.pdf';
      final filePath = '${directory.path}/$fileName';

      final pdfEndpoint = ApiConstants.contractPdf(contractId);

      await apiClient.download(
        pdfEndpoint,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      return filePath;
    } catch (e) {
      throw Exception('Failed to download PDF: ${e.toString()}');
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      try {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final basePath = externalDir.path.split('/Android')[0];
          final downloadsPath = '$basePath/Download';
          final downloadDir = Directory(downloadsPath);

          if (await downloadDir.exists()) {
            return downloadDir;
          }

          try {
            await downloadDir.create(recursive: true);
            return downloadDir;
          } catch (e) {
            final altPath = '/storage/emulated/0/Download';
            final altDir = Directory(altPath);
            if (await altDir.exists()) {
              return altDir;
            }
            try {
              await altDir.create(recursive: true);
              return altDir;
            } catch (_) {
              final directory = await getApplicationDocumentsDirectory();
              final fallbackDir = Directory('${directory.path}/Downloads');
              if (!await fallbackDir.exists()) {
                await fallbackDir.create(recursive: true);
              }
              return fallbackDir;
            }
          }
        }
      } catch (e) {
        final directory = await getApplicationDocumentsDirectory();
        final downloadDir = Directory('${directory.path}/Downloads');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadDir;
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${directory.path}/Downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }
}
