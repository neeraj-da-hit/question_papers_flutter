import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:question_papers_flutter/presentations/paper/model/paper_model.dart';
import 'package:question_papers_flutter/presentations/paper/service/paper_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PaperController extends GetxController {
  final PaperService _service = PaperService();

  var papers = <PaperModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Load papers for a specific subject
  Future<void> loadPapers(String subjectId) async {
    try {
      isLoading.value = true;
      final data = await _service.fetchPapers(subjectId);
      papers.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
      try {
        Get.snackbar("Error", e.toString());
      } catch (_) {
        debugPrint("Snackbar failed: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Open a PDF file (question paper or master paper)
  Future<void> openPdf(String url) async {
    try {
      await OpenFile.open(url);
    } catch (e) {
      Get.snackbar("Error", "Cannot open PDF: $e");
    }
  }

  /// Open a YouTube link in external browser or YouTube app
  Future<void> openYoutube(String url) async {
    try {
      Uri uri = Uri.parse(url);

      if (!uri.isAbsolute) {
        throw "Invalid YouTube URL";
      }

      // Try to open in external app
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw "Could not launch $url";
      }
    } catch (e) {
      Get.snackbar("Error", "Cannot open YouTube link: $e");
    }
  }
}
