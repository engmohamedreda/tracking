import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackingapp/feature/excel_area_codes/model/get_excel_area_codes_response.dart';
import 'package:trackingapp/feature/excel_mobile_serials/model/get_excel_mobile_serials_response.dart';
import 'package:trackingapp/feature/representative/model/get_representative_response.dart';

void main() {
  group('GetExcelAreaCodesResponse', () {
    test('يقرأ غلاف الـ pagination الراجع من الـ API', () {
      final json = jsonDecode(
        '{"data":[{"id":1,"code":"CGC001","companyName":"Wagd_Nestle",'
        '"branchName":"Gesr Elsuez"},{"id":2,"code":"CGC002",'
        '"companyName":"Wagd_Nestle","branchName":"Gesr Elsuez"}],'
        '"currentPage":1,"pageSize":2,"totalCount":106,"totalPages":53,'
        '"hasPrevious":false,"hasNext":true}',
      );

      final response = GetExcelAreaCodesResponse.fromJson(json);

      expect(response.count, 2);
      expect(response.currentPage, 1);
      expect(response.pageSize, 2);
      expect(response.totalCount, 106);
      expect(response.totalPages, 53);
      expect(response.hasPrevious, isFalse);
      expect(response.hasNext, isTrue);
      expect(response.areaCodes.first.code, 'CGC001');
      expect(response.areaCodes.first.companyName, 'Wagd_Nestle');
      expect(response.areaCodes.first.branchName, 'Gesr Elsuez');
    });

    test('يتعامل مع List من غير غلاف pagination', () {
      final json = jsonDecode('[{"id":5,"code":"CGC005"}]');

      final response = GetExcelAreaCodesResponse.fromJson(json);

      expect(response.count, 1);
      expect(response.currentPage, 1);
      expect(response.totalCount, 1);
      expect(response.totalPages, 1);
      expect(response.hasNext, isFalse);
    });

    test('يرجع فاضي لو الشكل مش متوقع', () {
      expect(GetExcelAreaCodesResponse.fromJson(null).isEmpty, isTrue);
      expect(GetExcelAreaCodesResponse.fromJson(const {}).isEmpty, isTrue);
    });
  });

  group('GetExcelMobileSerialsResponse', () {
    test('يقرأ غلاف الـ pagination الراجع من الـ API', () {
      final json = jsonDecode(
        '{"data":[{"id":1,"serial":"rk8y40015mt","areaCode":"CGC001"},'
        '{"id":2,"serial":"RK8x801hypl","areaCode":"CGC002"}],'
        '"currentPage":1,"pageSize":2,"totalCount":97,"totalPages":49,'
        '"hasPrevious":false,"hasNext":true}',
      );

      final response = GetExcelMobileSerialsResponse.fromJson(json);

      expect(response.count, 2);
      expect(response.totalCount, 97);
      expect(response.totalPages, 49);
      expect(response.hasNext, isTrue);
      expect(response.mobileSerials.first.serial, 'rk8y40015mt');
      expect(response.mobileSerials.first.areaCode, 'CGC001');
    });

    test('يرجع فاضي لو الشكل مش متوقع', () {
      expect(GetExcelMobileSerialsResponse.fromJson(null).isEmpty, isTrue);
    });
  });

  group('GetRepresentativeResponse', () {
    test('يقرأ غلاف الـ pagination الراجع من الـ API', () {
      final json = jsonDecode(
        '{"data":[{"id":1,"name":"احمد راضى","fingerPrint":"16146",'
        '"phone":"01124090080","companyName":"Wagd_Nestle",'
        '"branchName":"Gesr Elsuez"}],"currentPage":1,"pageSize":2,'
        '"totalCount":89,"totalPages":45,"hasPrevious":false,"hasNext":true}',
      );

      final response = GetRepresentativeResponse.fromJson(json);

      expect(response.count, 1);
      expect(response.totalCount, 89);
      expect(response.representatives.first.name, 'احمد راضى');
      expect(response.representatives.first.fingerPrint, '16146');
      expect(response.representatives.first.phone, '01124090080');
    });

    test('يرجع فاضي لو الشكل مش متوقع', () {
      expect(GetRepresentativeResponse.fromJson(null).isEmpty, isTrue);
    });
  });
}
