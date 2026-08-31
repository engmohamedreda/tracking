import '../../../core/helper/failures.dart';
import '../model/get_branch_response.dart';

abstract class GetBranchState {}

class GetBranchInitial extends GetBranchState {}

class GetBranchLoading extends GetBranchState {}

class GetBranchSuccess extends GetBranchState {
  final GetBranchResponse response;

  GetBranchSuccess(this.response);
}

class GetBranchError extends GetBranchState {
  final Failures failure;

  GetBranchError(this.failure);
}
