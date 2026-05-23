import '../../../../core/helper/failures.dart';
import '../model/login_response.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse response;

  LoginSuccess(this.response);
}

class LoginError extends LoginState {
  final Failures failure;

  LoginError(this.failure);
}
