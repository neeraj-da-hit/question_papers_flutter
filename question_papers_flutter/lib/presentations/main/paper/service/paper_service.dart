import 'package:question_papers_flutter/helpers/network_manager.dart';
import 'package:question_papers_flutter/presentations/main/paper/model/paper_model.dart';
import 'package:question_papers_flutter/constant/app_constants.dart';

class PaperService {
  final NetworkManager _network = NetworkManager();

  /// Fetch papers for a specific subject
  Future<List<PaperModel>> fetchPapers(String subjectId) async {
    final url = "${AppConstants.paper}/$subjectId";

    try {
      final response = await _network.getRequest(url);
      print("Fetching papers from: $url");

      // API returns: { success: true, count: 4, papers: [...] }
      final List dataList = response["papers"] ?? [];

      return dataList.map((e) => PaperModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
