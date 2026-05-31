class GetSurveyByIdResponse {
  final int id;
  final String note;
  final String status;
  final String createdAt;
  final String updatedAt;
  final bool isFingerPrint;
  final String fingerprintDate;
  final String companyName;
  final String brandName;
  final String mobileSerial;
  final String userId;
  final String representativeName;
  final String areaCode;
  final List<GetSurveyByIdAnswerEntity> surveyAnswers;
  final List<String> surveyAttechment;

  const GetSurveyByIdResponse({
    required this.id,
    required this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isFingerPrint,
    required this.fingerprintDate,
    required this.companyName,
    required this.brandName,
    required this.mobileSerial,
    required this.userId,
    required this.representativeName,
    required this.areaCode,
    required this.surveyAnswers,
    required this.surveyAttechment,
  });

  factory GetSurveyByIdResponse.fromJson(dynamic json) {
    final map = _asMap(json);
    final data = _asMap(
      map['data'] ??
          map['survey'] ??
          map['survay'] ??
          map['item'] ??
          map['result'] ??
          json,
    );

    return GetSurveyByIdResponse(
      id: _asInt(data['id']),
      note: _asString(data['note']),
      status: _asString(data['status']),
      createdAt: _asString(data['createdAt']),
      updatedAt: _asString(data['updatedAt']),
      isFingerPrint: _asBool(data['isFingerPrint']),
      fingerprintDate: _asString(data['fingerprintDate']),
      companyName: _asString(data['companyName']),
      brandName: _asString(data['brandName']),
      mobileSerial: _asString(data['mobileSerial']),
      userId: _asString(data['userId']),
      representativeName: _asString(data['representativeName']),
      areaCode: _asString(data['areaCode']),
      surveyAnswers: _asList(data['surveyAnswers'])
          .map(GetSurveyByIdAnswerEntity.fromJson)
          .toList(growable: false),
      surveyAttechment: _asList(data['surveyAttechment'] ?? data['surveyAttachment'])
          .map(_asString)
          .where((item) => item.trim().isNotEmpty)
          .toList(growable: false),
    );
  }

  bool get hasData => id > 0;
}

class GetSurveyByIdAnswerEntity {
  final int id;
  final String title;
  final bool answer;
  final int questionId;

  const GetSurveyByIdAnswerEntity({
    required this.id,
    required this.title,
    required this.answer,
    required this.questionId,
  });

  factory GetSurveyByIdAnswerEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return GetSurveyByIdAnswerEntity(
      id: _asInt(map['id']),
      title: _asString(map['title']),
      answer: _asBool(map['answer']),
      questionId: _asInt(map['questionId']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return const [];
}

String _asString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is num) return value.toInt() == 1;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }
  return false;
}
