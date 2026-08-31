import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/company_entity.dart';
import 'get_company_state.dart';
import 'get_company_usecase.dart';

@injectable
class GetCompanyCubit extends Cubit<GetCompanyState> {
  final GetCompanyUseCase getCompanyUseCase;

  GetCompanyCubit(this.getCompanyUseCase) : super(GetCompanyInitial());

  List<CompanyEntity> companies = [];

  Future<void> load() async {
    emit(GetCompanyLoading());

    final result = await getCompanyUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(GetCompanyError(failure));
      },
      (response) {
        companies = response.companies;
        emit(GetCompanySuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await load();
  }

  CompanyEntity? findById(int id) {
    for (final company in companies) {
      if (company.id == id) return company;
    }
    return null;
  }
}
