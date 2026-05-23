import 'dart:convert';

import 'package:dio/dio.dart';

import 'survey_answer_request.dart';
import 'survey_attachment_request.dart';

class CreateSurveyRequest {
  static final DateTime fixedSurveyDate = DateTime.utc(2026, 5, 23, 6, 36, 23, 928);

  final int id;
  final String note;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// From GetNextTickets response: companyId
  final int companyId;

  /// Swagger field is BrandId.
  /// In current ticket response you can pass ticket.branchId here.
  final int brandId;

  /// From GetMobilesSerials response: id
  final int mobileId;

  /// From SharedPreferences key: userId, or pass it manually.
  final String userId;

  /// From GetNextTickets response: representativeId
  final int representativeId;

  /// From GetAreaCode response: id
  final int areaId;

  /// From GetNextTickets response: id
  final int ticketId;

  /// Sent twice:
  /// 1) SurvayJson as a JSON string, exactly like Swagger spelling.
  /// 2) surveyAnswers[index].field, so ASP.NET multipart model binding
  ///    receives the array items and does not return "items are missing".
  final List<SurveyAnswerRequest> surveyAnswers;

  /// Files selected by image_picker. Uses bytes instead of MultipartFile.fromFile,
  /// so it works on Flutter Web and mobile/desktop.
  final List<SurveyAttachmentRequest> surveyAttachments;

  CreateSurveyRequest({
    this.id = 0,
    this.note = '',
    this.status = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.companyId,
    required this.brandId,
    required this.mobileId,
    required this.userId,
    required this.representativeId,
    required this.areaId,
    required this.ticketId,
    required this.surveyAnswers,
    this.surveyAttachments = const [],
  })  : createdAt = createdAt ?? fixedSurveyDate,
        updatedAt = updatedAt ?? fixedSurveyDate;

  /// Helper for the common flow:
  /// - ticket fields from GetNextTickets
  /// - areaId from GetAreaCode
  /// - mobileId from GetMobilesSerials
  CreateSurveyRequest.fromFlow({
    this.id = 0,
    this.note = '',
    this.status = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.companyId,
    required this.brandId,
    required this.mobileId,
    required this.userId,
    required this.representativeId,
    required this.areaId,
    required this.ticketId,
    required this.surveyAnswers,
    this.surveyAttachments = const [],
  })  : createdAt = createdAt ?? fixedSurveyDate,
        updatedAt = updatedAt ?? fixedSurveyDate;

  String get survayJson {
    return jsonEncode(
      surveyAnswers.map((answer) => answer.toJson()).toList(),
    );
  }

  Future<FormData> toFormData({String? overrideUserId}) async {
    final effectiveUserId = (overrideUserId ?? userId).trim();
    final formData = FormData();

    // Main survey data.
    // مهم: Swagger كاتب SurvayJson و SurvayAttachment بحرف a مش Survey.
    formData.fields.addAll([
      MapEntry('Id', id.toString()),
      MapEntry('Note', note),
      MapEntry('Status', status),
      MapEntry('CreatedAt', _formatDate(createdAt)),
      MapEntry('UpdatedAt', _formatDate(updatedAt)),
      MapEntry('CompanyId', companyId.toString()),
      MapEntry('BrandId', brandId.toString()),
      MapEntry('MobileId', mobileId.toString()),
      MapEntry('UserId', effectiveUserId),
      MapEntry('RepresentativeId', representativeId.toString()),
      MapEntry('AreaId', areaId.toString()),
      MapEntry('TicketId', ticketId.toString()),
      MapEntry('SurvayJson', survayJson),
    ]);

    // Important: Swagger has a separate surveyAnswers array.
    // Sending only SurvayJson can make the API return:
    // "survay data or items are missing."
    for (var i = 0; i < surveyAnswers.length; i++) {
      final answer = surveyAnswers[i];
      formData.fields.addAll([
        MapEntry('surveyAnswers[$i].id', answer.id.toString()),
        MapEntry('surveyAnswers[$i].title', answer.title),
        MapEntry('surveyAnswers[$i].answer', answer.answer.toString()),
        MapEntry('surveyAnswers[$i].questionId', answer.questionId.toString()),
      ]);
    }

    // Do not use MultipartFile.fromFile here.
    // fromFile needs dart:io and crashes on Flutter Web.
    for (final attachment in surveyAttachments) {
      if (attachment.bytes.isEmpty) continue;
      formData.files.add(
        MapEntry(
          'SurvayAttachment',
          MultipartFile.fromBytes(
            attachment.bytes,
            filename: attachment.fileName,
          ),
        ),
      );
    }

    return formData;
  }

  List<String> findMissingFields({String? overrideUserId}) {
    final effectiveUserId = (overrideUserId ?? userId).trim();
    final missing = <String>[];

    if (companyId <= 0) missing.add('CompanyId');
    if (brandId <= 0) missing.add('BrandId');
    if (mobileId <= 0) missing.add('MobileId');
    if (effectiveUserId.isEmpty) missing.add('UserId');
    if (representativeId <= 0) missing.add('RepresentativeId');
    if (areaId <= 0) missing.add('AreaId');
    if (ticketId <= 0) missing.add('TicketId');
    if (survayJson.trim().isEmpty || surveyAnswers.isEmpty) {
      missing.add('SurvayJson / surveyAnswers');
    }

    for (var i = 0; i < surveyAnswers.length; i++) {
      final answer = surveyAnswers[i];
      if (answer.questionId <= 0) {
        missing.add('surveyAnswers[$i].questionId');
      }
      if (answer.title.trim().isEmpty) {
        missing.add('surveyAnswers[$i].title');
      }
    }

    // لو الصور إجبارية في الباك إند، السطر ده هيظهرها كناقص.
    if (surveyAttachments.isEmpty) missing.add('SurvayAttachment');

    return missing;
  }

  String _formatDate(DateTime value) {
    return value.toUtc().toIso8601String();
  }

  Map<String, dynamic> toDebugJson({String? overrideUserId}) {
    return {
      'Id': id,
      'Note': note,
      'Status': status,
      'CreatedAt': _formatDate(createdAt),
      'UpdatedAt': _formatDate(updatedAt),
      'CompanyId': companyId,
      'BrandId': brandId,
      'MobileId': mobileId,
      'UserId': (overrideUserId ?? userId).trim(),
      'RepresentativeId': representativeId,
      'AreaId': areaId,
      'TicketId': ticketId,
      'SurvayJson': survayJson,
      'surveyAnswers': surveyAnswers.map((answer) => answer.toJson()).toList(),
      'SurvayAttachment': surveyAttachments.map((file) => file.fileName).toList(),
    };
  }
}
