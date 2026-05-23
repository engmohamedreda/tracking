import 'package:dartz/dartz.dart';

import '../../../../../core/helper/failures.dart';
import '../../model/login_response.dart';

abstract class ILoginRepo {
  Future<Either<Failures, LoginResponse>> login({
    required String username,
    required String password,
  });
}
