
import 'package:question_papers_flutter/constant/app_constants.dart';
import 'package:question_papers_flutter/helpers/network_manager.dart';
import 'package:question_papers_flutter/presentations/main/subject/model/subject_model.dart';

class SubjectService {
  final NetworkManager _network = NetworkManager();

  Future<List<SubjectModel>> fetchSubjects(String subjectId) async {
    final url = AppConstants.subject + "/" + subjectId;

    try {
      final response = await _network.getRequest(url);
      print(url);

      // API return a list : [{...},{...}]
      final List dataList = response["data"] ?? response;

      // convert each JSON object into SubjectModel
      return dataList.map((e) => SubjectModel.fromJson(e)).toList();
    } catch(e) {
      rethrow;
    }
  }
}