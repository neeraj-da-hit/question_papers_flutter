class PaperModel {
  final String id;
  final String subjectId;
  final String subjectName;
  final int year;
  final String pdfUrl;
  final String? masterPdfUrl; // optional
  final String? ytUrl; // optional
  final int v;

  PaperModel({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.year,
    required this.pdfUrl,
    this.masterPdfUrl,
    this.ytUrl,
    required this.v,
  });

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    return PaperModel(
      id: json['_id'] ?? '',
      subjectId: json['subject']?['_id'] ?? '',
      subjectName: json['subject']?['name'] ?? '',
      year: json['year'] ?? 0,
      pdfUrl: json['pdfUrl'] ?? '',
      masterPdfUrl: json['masterPdfUrl'], // may be null
      ytUrl: json['ytUrl'], // may be null
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'subject': {'_id': subjectId, 'name': subjectName},
      'year': year,
      'pdfUrl': pdfUrl,
      if (masterPdfUrl != null) 'masterPdfUrl': masterPdfUrl,
      if (ytUrl != null) 'ytUrl': ytUrl,
      '__v': v,
    };
  }

  static List<PaperModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => PaperModel.fromJson(json)).toList();
  }
}
