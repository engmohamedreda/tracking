import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackingapp/feature/branch/model/get_branch_response.dart';
import 'package:trackingapp/feature/company/model/get_company_response.dart';

void main() {
  group('GetCompanyResponse', () {
    test('يقرأ الـ List الراجعة من الـ API مباشرة', () {
      final json = jsonDecode('[{"id":1,"name":"Wagd_Nestle"}]');

      final response = GetCompanyResponse.fromJson(json);

      expect(response.count, 1);
      expect(response.isEmpty, isFalse);
      expect(response.companies.first.id, 1);
      expect(response.companies.first.name, 'Wagd_Nestle');
    });

    test('يقرأ الـ List لو جت مغلّفة في data', () {
      final json = jsonDecode('{"data":[{"id":2,"name":"Other"}]}');

      final response = GetCompanyResponse.fromJson(json);

      expect(response.count, 1);
      expect(response.companies.first.name, 'Other');
    });

    test('يرجع لستة فاضية لو الشكل مش متوقع', () {
      expect(GetCompanyResponse.fromJson(null).isEmpty, isTrue);
      expect(GetCompanyResponse.fromJson('unexpected').isEmpty, isTrue);
      expect(GetCompanyResponse.fromJson({'foo': 'bar'}).isEmpty, isTrue);
    });

    test('يستبعد العناصر الفاضية', () {
      final json = jsonDecode('[{"id":0,"name":""},{"id":1,"name":"Valid"}]');

      final response = GetCompanyResponse.fromJson(json);

      expect(response.count, 1);
      expect(response.companies.first.name, 'Valid');
    });
  });

  group('GetBranchResponse', () {
    test('يقرأ الـ List الراجعة من الـ API مباشرة', () {
      final json = jsonDecode(
        '[{"id":1,"name":"Gesr Elsuez"},{"id":2,"name":"Giza"}]',
      );

      final response = GetBranchResponse.fromJson(json);

      expect(response.count, 2);
      expect(response.branches.first.name, 'Gesr Elsuez');
      expect(response.branches.last.id, 2);
    });

    test('يرجع لستة فاضية لو الشكل مش متوقع', () {
      expect(GetBranchResponse.fromJson(null).isEmpty, isTrue);
      expect(GetBranchResponse.fromJson(const {}).isEmpty, isTrue);
    });
  });
}
