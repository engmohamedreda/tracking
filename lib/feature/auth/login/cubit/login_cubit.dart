import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'login_state.dart';
import 'login_usecase.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await loginUseCase(
      username: username.trim(),
      password: password.trim(),
    );

    result.fold(
      (failure) => emit(LoginError(failure)),
      (response) => emit(LoginSuccess(response)),
    );
  }
}
