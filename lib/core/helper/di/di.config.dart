// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../feature/area_code/cubit/get_area_code_cubit.dart' as _i173;
import '../../../feature/area_code/cubit/get_area_code_usecase.dart' as _i408;
import '../../../feature/area_code/response/interface/i_get_area_code_repo.dart'
    as _i437;
import '../../../feature/area_code/response/remote/get_area_code_repo.dart'
    as _i835;
import '../../../feature/auth/login/cubit/login_cubit.dart' as _i294;
import '../../../feature/auth/login/cubit/login_usecase.dart' as _i387;
import '../../../feature/auth/login/response/interface/i_login_repo.dart'
    as _i492;
import '../../../feature/auth/login/response/remote/login_repo.dart' as _i986;
import '../../../feature/create_survey/cubit/create_survey_cubit.dart' as _i599;
import '../../../feature/create_survey/cubit/create_survey_usecase.dart'
    as _i1035;
import '../../../feature/create_survey/response/interface/i_create_survey_repo.dart'
    as _i316;
import '../../../feature/create_survey/response/remote/create_survey_repo.dart'
    as _i841;
import '../../../feature/dtickets/delete_tickets/cubit/delete_tickets_cubit.dart'
    as _i506;
import '../../../feature/dtickets/delete_tickets/cubit/delete_tickets_usecase.dart'
    as _i584;
import '../../../feature/dtickets/delete_tickets/response/interface/i_delete_tickets_repo.dart'
    as _i496;
import '../../../feature/dtickets/delete_tickets/response/remote/delete_tickets_repo.dart'
    as _i241;
import '../../../feature/mobile_serials/cubit/get_mobile_serials_cubit.dart'
    as _i1007;
import '../../../feature/mobile_serials/cubit/get_mobile_serials_usecase.dart'
    as _i789;
import '../../../feature/mobile_serials/response/interface/i_get_mobile_serials_repo.dart'
    as _i546;
import '../../../feature/mobile_serials/response/remote/get_mobile_serials_repo.dart'
    as _i783;
import '../../../feature/ntickets/cubit/get_next_tickets_cubit.dart' as _i762;
import '../../../feature/ntickets/cubit/get_next_tickets_usecase.dart' as _i141;
import '../../../feature/ntickets/response/interface/i_get_next_tickets_repo.dart'
    as _i751;
import '../../../feature/ntickets/response/remote/get_next_tickets_repo.dart'
    as _i530;
import '../../../feature/survey_questions/cubit/get_survey_questions_cubit.dart'
    as _i969;
import '../../../feature/survey_questions/cubit/get_survey_questions_usecase.dart'
    as _i690;
import '../../../feature/survey_questions/response/interface/i_get_survey_questions_repo.dart'
    as _i859;
import '../../../feature/survey_questions/response/remote/get_survey_questions_repo.dart'
    as _i1042;
import '../../../feature/tickets/cubit/get_all_tickets_cubit.dart' as _i619;
import '../../../feature/tickets/cubit/get_all_tickets_usecase.dart' as _i349;
import '../../../feature/tickets/response/interface/i_get_all_tickets_repo.dart'
    as _i903;
import '../../../feature/tickets/response/remote/get_all_tickets_repo.dart'
    as _i873;
import '../Api/ApiManager/ApiManager.dart' as _i69;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i69.Apimanager>(() => _i69.Apimanager());
    gh.lazySingleton<_i437.IGetAreaCodeRepo>(
      () => _i835.GetAreaCodeRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i859.IGetSurveyQuestionsRepo>(
      () => _i1042.GetSurveyQuestionsRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i316.ICreateSurveyRepo>(
      () => _i841.CreateSurveyRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i751.IGetNextTicketsRepo>(
      () => _i530.GetNextTicketsRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i492.ILoginRepo>(
      () => _i986.LoginRepo(gh<_i69.Apimanager>()),
    );
    gh.factory<_i690.GetSurveyQuestionsUseCase>(
      () =>
          _i690.GetSurveyQuestionsUseCase(gh<_i859.IGetSurveyQuestionsRepo>()),
    );
    gh.lazySingleton<_i496.IDeleteTicketsRepo>(
      () => _i241.DeleteTicketsRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i903.IGetAllTicketsRepo>(
      () => _i873.GetAllTicketsRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i546.IGetMobileSerialsRepo>(
      () => _i783.GetMobileSerialsRepo(gh<_i69.Apimanager>()),
    );
    gh.factory<_i584.DeleteTicketsUseCase>(
      () => _i584.DeleteTicketsUseCase(gh<_i496.IDeleteTicketsRepo>()),
    );
    gh.factory<_i387.LoginUseCase>(
      () => _i387.LoginUseCase(gh<_i492.ILoginRepo>()),
    );
    gh.factory<_i969.GetSurveyQuestionsCubit>(
      () =>
          _i969.GetSurveyQuestionsCubit(gh<_i690.GetSurveyQuestionsUseCase>()),
    );
    gh.factory<_i141.GetNextTicketsUseCase>(
      () => _i141.GetNextTicketsUseCase(gh<_i751.IGetNextTicketsRepo>()),
    );
    gh.factory<_i408.GetAreaCodeUseCase>(
      () => _i408.GetAreaCodeUseCase(gh<_i437.IGetAreaCodeRepo>()),
    );
    gh.factory<_i1035.CreateSurveyUseCase>(
      () => _i1035.CreateSurveyUseCase(gh<_i316.ICreateSurveyRepo>()),
    );
    gh.factory<_i599.CreateSurveyCubit>(
      () => _i599.CreateSurveyCubit(gh<_i1035.CreateSurveyUseCase>()),
    );
    gh.factory<_i294.LoginCubit>(
      () => _i294.LoginCubit(gh<_i387.LoginUseCase>()),
    );
    gh.factory<_i349.GetAllTicketsUseCase>(
      () => _i349.GetAllTicketsUseCase(gh<_i903.IGetAllTicketsRepo>()),
    );
    gh.factory<_i789.GetMobileSerialsUseCase>(
      () => _i789.GetMobileSerialsUseCase(gh<_i546.IGetMobileSerialsRepo>()),
    );
    gh.factory<_i506.DeleteTicketsCubit>(
      () => _i506.DeleteTicketsCubit(gh<_i584.DeleteTicketsUseCase>()),
    );
    gh.factory<_i762.GetNextTicketsCubit>(
      () => _i762.GetNextTicketsCubit(gh<_i141.GetNextTicketsUseCase>()),
    );
    gh.factory<_i173.GetAreaCodeCubit>(
      () => _i173.GetAreaCodeCubit(gh<_i408.GetAreaCodeUseCase>()),
    );
    gh.factory<_i619.GetAllTicketsCubit>(
      () => _i619.GetAllTicketsCubit(gh<_i349.GetAllTicketsUseCase>()),
    );
    gh.factory<_i1007.GetMobileSerialsCubit>(
      () => _i1007.GetMobileSerialsCubit(gh<_i789.GetMobileSerialsUseCase>()),
    );
    return this;
  }
}
