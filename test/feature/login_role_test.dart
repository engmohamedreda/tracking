import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackingapp/core/helper/session/session_manager.dart';
import 'package:trackingapp/feature/auth/login/model/login_response.dart';

void main() {
  group('LoginUser role parsing', () {
    test('يقرأ الـ roleName من رد الـ login الحقيقي', () {
      final json = jsonDecode(
        '{"success":true,"token":"abc","user":{'
        '"id":"d4bca919-bf33-4a4b-a3e4-0a97798fe9b7","userName":"Ehabi",'
        '"fullName":"Ehab Fawzy","companyId":1,"brandId":1,'
        '"roleName":"SuperAdmin","companyName":"Wagd_Nestle",'
        '"branchName":"Gesr Elsuez"},'
        '"device":{"name":"asd","ipAddress":"192.168.9.220","port":4370,'
        '"isConnected":false},' 
        '"deviceStatus":{"isConnected":false,"message":""}}',
      );

      final response = LoginResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.user.userName, 'Ehabi');
      expect(response.user.fullName, 'Ehab Fawzy');
      expect(response.user.roleName, 'SuperAdmin');
      expect(response.user.isSuperAdmin, isTrue);
      // الرد بيرجع brandId مش branchId، فلازم ناخده منها.
      expect(response.user.branchId, 1);
      expect(response.user.companyName, 'Wagd_Nestle');
    });

    test('يقبل صيغ مختلفة لكتابة الرول', () {
      for (final role in ['SuperAdmin', 'superadmin', 'Super Admin', 'SUPERADMIN']) {
        final user = LoginUser.fromJson({'roleName': role});
        expect(user.isSuperAdmin, isTrue, reason: 'فشل مع: $role');
      }
    });

    test('يرفض أي رول تانية', () {
      for (final role in ['Admin', 'User', 'Representative', '']) {
        final user = LoginUser.fromJson({'roleName': role});
        expect(user.isSuperAdmin, isFalse, reason: 'المفروض يرفض: $role');
      }
    });

    test('الرول الناقصة مش بتكسر الـ parsing', () {
      final user = LoginUser.fromJson({'userName': 'x'});

      expect(user.roleName, '');
      expect(user.isSuperAdmin, isFalse);
    });
  });

  group('SessionManager.normalizeRole', () {
    test('يوحّد المسافات والشرطة السفلية وحالة الحروف', () {
      expect(SessionManager.normalizeRole('SuperAdmin'), 'superadmin');
      expect(SessionManager.normalizeRole('Super Admin'), 'superadmin');
      expect(SessionManager.normalizeRole('super_admin'), 'superadmin');
      expect(SessionManager.normalizeRole('SUPER ADMIN'), 'superadmin');
    });

    test('مش بيغيّر الرولز التانية لـ superadmin', () {
      expect(SessionManager.normalizeRole('Admin'), isNot('superadmin'));
      expect(SessionManager.normalizeRole('User'), isNot('superadmin'));
    });
  });
}
