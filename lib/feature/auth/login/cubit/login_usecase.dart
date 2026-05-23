import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/failures.dart';
import '../model/login_response.dart';
import '../response/interface/i_login_repo.dart';

@injectable
class LoginUseCase {
  final ILoginRepo loginRepo;

  LoginUseCase(this.loginRepo);

  Future<Either<Failures, LoginResponse>> call({
    required String username,
    required String password,
  }) {
    return loginRepo.login(
      username: username,
      password: password,
    );
  }
}
