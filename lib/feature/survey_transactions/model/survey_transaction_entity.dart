class SurveyTransactionEntity {
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
  final List<SurveyTransactionAnswerEntity> surveyAnswers;
  final List<String> surveyAttechment;

  const SurveyTransactionEntity({
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

  /// نفس شكل الـ item الراجع من GetSurvayById بالظبط،
  /// بس هنا جوه list مغلّفة بالـ pagination.
  factory SurveyTransactionEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return SurveyTransactionEntity(
      id: _asInt(map['id']),
      note: _asString(map['note']),
      status: _asString(map['status']),
      createdAt: _asString(map['createdAt']),
      updatedAt: _asString(map['updatedAt']),
      isFingerPrint: _asBool(map['isFingerPrint']),
      fingerprintDate: _asString(map['fingerprintDate']),
      companyName: _asString(map['companyName']),
      brandName: _asString(map['brandName']),
      mobileSerial: _asString(map['mobileSerial']),
      userId: _asString(map['userId']),
      representativeName: _asString(map['representativeName']),
      areaCode: _asString(map['areaCode']),
      surveyAnswers: _asList(map['surveyAnswers'])
          .map(SurveyTransactionAnswerEntity.fromJson)
          .toList(growable: false),
      surveyAttechment:
          _asList(map['surveyAttechment'] ?? map['surveyAttachment'])
              .map(_asString)
              .where((item) => item.trim().isNotEmpty)
              .toList(growable: false),
    );
  }

  bool get hasData => id > 0;

  /// السيرفر بيرجع 0001-01-01 لما ميكونش فيه تاريخ بصمة فعلي.
  bool get hasFingerprintDate =>
      fingerprintDate.isNotEmpty && !fingerprintDate.startsWith('0001-01-01');

  int get answersCount => surveyAnswers.length;

  bool get hasAttachments => surveyAttechment.isNotEmpty;
}

class SurveyTransactionAnswerEntity {
  final int id;
  final String title;
  final bool answer;
  final int questionId;

  const SurveyTransactionAnswerEntity({
    required this.id,
    required this.title,
    required this.answer,
    required this.questionId,
  });

  factory SurveyTransactionAnswerEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return SurveyTransactionAnswerEntity(
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
