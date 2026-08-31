import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/branch_entity.dart';
import 'get_branch_state.dart';
import 'get_branch_usecase.dart';

@injectable
class GetBranchCubit extends Cubit<GetBranchState> {
  final GetBranchUseCase getBranchUseCase;

  GetBranchCubit(this.getBranchUseCase) : super(GetBranchInitial());

  List<BranchEntity> branches = [];

  Future<void> load() async {
    emit(GetBranchLoading());

    final result = await getBranchUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(GetBranchError(failure));
      },
      (response) {
        branches = response.branches;
        emit(GetBranchSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await load();
  }

  BranchEntity? findById(int id) {
    for (final branch in branches) {
      if (branch.id == id) return branch;
    }
    return null;
  }
}
