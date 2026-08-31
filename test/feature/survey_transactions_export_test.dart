import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackingapp/feature/export_surveys/model/export_surveys_response.dart';
import 'package:trackingapp/feature/survey_transactions/model/get_all_transactions_response.dart';

void main() {
  group('GetAllTransactionsResponse', () {
    test('يقرأ غلاف الـ pagination والـ answers الراجعين من الـ API', () {
      final json = jsonDecode(
        '{"data":[{"id":1,"note":"test","status":"استلام",'
        '"createdAt":"2026-08-03T09:47:17.9658125",'
        '"updatedAt":"2026-08-03T09:47:17.9657","isFingerPrint":false,'
        '"fingerprintDate":"0001-01-01T00:00:00","companyName":"Wagd_Nestle",'
        '"brandName":"Gesr Elsuez","mobileSerial":"RK8TB02XACR",'
        '"userId":"d4bca919-bf33-4a4b-a3e4-0a97798fe9b7",'
        '"representativeName":"احمد راضى","areaCode":"CGC008",'
        '"surveyAnswers":[{"id":1,"title":"سؤال","answer":true,'
        '"questionId":1}],"surveyAttechment":[]}],'
        '"currentPage":1,"pageSize":1,"totalCount":40,"totalPages":40,'
        '"hasPrevious":false,"hasNext":true}',
      );

      final response = GetAllTransactionsResponse.fromJson(json);

      expect(response.count, 1);
      expect(response.currentPage, 1);
      expect(response.totalCount, 40);
      expect(response.totalPages, 40);
      expect(response.hasNext, isTrue);

      final transaction = response.transactions.first;
      expect(transaction.id, 1);
      expect(transaction.status, 'استلام');
      expect(transaction.companyName, 'Wagd_Nestle');
      expect(transaction.brandName, 'Gesr Elsuez');
      expect(transaction.mobileSerial, 'RK8TB02XACR');
      expect(transaction.areaCode, 'CGC008');
      expect(transaction.isFingerPrint, isFalse);
      // 0001-01-01 معناها مفيش تاريخ بصمة فعلي.
      expect(transaction.hasFingerprintDate, isFalse);
      expect(transaction.answersCount, 1);
      expect(transaction.surveyAnswers.first.answer, isTrue);
      expect(transaction.hasAttachments, isFalse);
    });

    test('يتعامل مع List من غير غلاف pagination', () {
      final json = jsonDecode('[{"id":3,"note":"n","status":"تسليم"}]');

      final response = GetAllTransactionsResponse.fromJson(json);

      expect(response.count, 1);
      expect(response.transactions.first.status, 'تسليم');
      expect(response.hasNext, isFalse);
    });

    test('يرجع فاضي لو الشكل مش متوقع', () {
      expect(GetAllTransactionsResponse.fromJson(null).isEmpty, isTrue);
      expect(GetAllTransactionsResponse.fromJson(const {}).isEmpty, isTrue);
    });
  });

  group('ExportSurveysResponse.parseFileName', () {
    test('يفضّل filename* على filename', () {
      final name = ExportSurveysResponse.parseFileName(
        contentDisposition:
            "attachment; filename=Survays.xlsx; filename*=UTF-8''Survays.xlsx",
        fallback: 'fallback.xlsx',
      );

      expect(name, 'Survays.xlsx');
    });

    test('ياخد filename العادية لو مفيش filename*', () {
      final name = ExportSurveysResponse.parseFileName(
        contentDisposition: 'attachment; filename=Report.xlsx',
        fallback: 'fallback.xlsx',
      );

      expect(name, 'Report.xlsx');
    });

    test('يرجع الـ fallback لو الهيدر مش موجود أو فاضي', () {
      expect(
        ExportSurveysResponse.parseFileName(
          contentDisposition: null,
          fallback: 'Survays.xlsx',
        ),
        'Survays.xlsx',
      );
      expect(
        ExportSurveysResponse.parseFileName(
          contentDisposition: '   ',
          fallback: 'Survays.xlsx',
        ),
        'Survays.xlsx',
      );
    });

    test('يشيل أي مسار جاي مع الاسم', () {
      final name = ExportSurveysResponse.parseFileName(
        contentDisposition: r'attachment; filename=C:\temp\Survays.xlsx',
        fallback: 'fallback.xlsx',
      );

      expect(name, 'Survays.xlsx');
    });
  });
}
