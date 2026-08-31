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
import '../../../feature/branch/cubit/get_branch_cubit.dart' as _i69;
import '../../../feature/branch/cubit/get_branch_usecase.dart' as _i493;
import '../../../feature/branch/response/interface/i_get_branch_repo.dart'
    as _i199;
import '../../../feature/branch/response/remote/get_branch_repo.dart' as _i800;
import '../../../feature/company/cubit/get_company_cubit.dart' as _i883;
import '../../../feature/company/cubit/get_company_usecase.dart' as _i949;
import '../../../feature/company/response/interface/i_get_company_repo.dart'
    as _i392;
import '../../../feature/company/response/remote/get_company_repo.dart'
    as _i805;
import '../../../feature/create_survey/cubit/create_survey_cubit.dart' as _i599;
import '../../../feature/create_survey/cubit/create_survey_usecase.dart'
    as _i1035;
import '../../../feature/create_survey/response/interface/i_create_survey_repo.dart'
    as _i316;
import '../../../feature/create_survey/response/remote/create_survey_repo.dart'
    as _i841;
import '../../../feature/delete_device_attendence/cubit/delete_device_attendence_cubit.dart'
    as _i750;
import '../../../feature/delete_device_attendence/cubit/delete_device_attendence_usecase.dart'
    as _i977;
import '../../../feature/delete_device_attendence/response/interface/i_delete_device_attendence_repo.dart'
    as _i16;
import '../../../feature/delete_device_attendence/response/remote/delete_device_attendence_repo.dart'
    as _i469;
import '../../../feature/dtickets/delete_tickets/cubit/delete_tickets_cubit.dart'
    as _i506;
import '../../../feature/dtickets/delete_tickets/cubit/delete_tickets_usecase.dart'
    as _i584;
import '../../../feature/dtickets/delete_tickets/response/interface/i_delete_tickets_repo.dart'
    as _i496;
import '../../../feature/dtickets/delete_tickets/response/remote/delete_tickets_repo.dart'
    as _i241;
import '../../../feature/dtickets/no_show_tickets/cubit/no_show_ticket_cubit.dart'
    as _i69;
import '../../../feature/dtickets/no_show_tickets/cubit/no_show_ticket_usecase.dart'
    as _i573;
import '../../../feature/dtickets/no_show_tickets/response/interface/i_no_show_ticket_repo.dart'
    as _i586;
import '../../../feature/dtickets/no_show_tickets/response/remote/no_show_ticket_repo.dart'
    as _i891;
import '../../../feature/excel_area_codes/cubit/get_excel_area_codes_cubit.dart'
    as _i937;
import '../../../feature/excel_area_codes/cubit/get_excel_area_codes_usecase.dart'
    as _i1039;
import '../../../feature/excel_area_codes/response/interface/i_get_excel_area_codes_repo.dart'
    as _i930;
import '../../../feature/excel_area_codes/response/remote/get_excel_area_codes_repo.dart'
    as _i126;
import '../../../feature/excel_import/cubit/excel_import_cubit.dart' as _i1006;
import '../../../feature/excel_import/cubit/excel_import_usecase.dart' as _i21;
import '../../../feature/excel_import/response/interface/i_excel_import_repo.dart'
    as _i584;
import '../../../feature/excel_import/response/remote/excel_import_repo.dart'
    as _i269;
import '../../../feature/excel_mobile_serials/cubit/get_excel_mobile_serials_cubit.dart'
    as _i1070;
import '../../../feature/excel_mobile_serials/cubit/get_excel_mobile_serials_usecase.dart'
    as _i204;
import '../../../feature/excel_mobile_serials/response/interface/i_get_excel_mobile_serials_repo.dart'
    as _i724;
import '../../../feature/excel_mobile_serials/response/remote/get_excel_mobile_serials_repo.dart'
    as _i767;
import '../../../feature/excel_template/cubit/excel_template_cubit.dart'
    as _i802;
import '../../../feature/excel_template/cubit/excel_template_usecase.dart'
    as _i247;
import '../../../feature/excel_template/response/interface/i_excel_template_repo.dart'
    as _i683;
import '../../../feature/excel_template/response/remote/excel_template_repo.dart'
    as _i327;
import '../../../feature/export_surveys/cubit/export_surveys_cubit.dart'
    as _i46;
import '../../../feature/export_surveys/cubit/export_surveys_usecase.dart'
    as _i966;
import '../../../feature/export_surveys/response/interface/i_export_surveys_repo.dart'
    as _i938;
import '../../../feature/export_surveys/response/remote/export_surveys_repo.dart'
    as _i230;
import '../../../feature/get_survey_by_id/cubit/get_survey_by_id_cubit.dart'
    as _i633;
import '../../../feature/get_survey_by_id/cubit/get_survey_by_id_usecase.dart'
    as _i720;
import '../../../feature/get_survey_by_id/response/interface/i_get_survey_by_id_repo.dart'
    as _i847;
import '../../../feature/get_survey_by_id/response/remote/get_survey_by_id_repo.dart'
    as _i575;
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
import '../../../feature/representative/cubit/get_representative_cubit.dart'
    as _i582;
import '../../../feature/representative/cubit/get_representative_usecase.dart'
    as _i922;
import '../../../feature/representative/response/interface/i_get_representative_repo.dart'
    as _i615;
import '../../../feature/representative/response/remote/get_representative_repo.dart'
    as _i59;
import '../../../feature/survey_questions/cubit/get_survey_questions_cubit.dart'
    as _i969;
import '../../../feature/survey_questions/cubit/get_survey_questions_usecase.dart'
    as _i690;
import '../../../feature/survey_questions/response/interface/i_get_survey_questions_repo.dart'
    as _i859;
import '../../../feature/survey_questions/response/remote/get_survey_questions_repo.dart'
    as _i1042;
import '../../../feature/survey_transactions/cubit/get_all_transactions_cubit.dart'
    as _i983;
import '../../../feature/survey_transactions/cubit/get_all_transactions_usecase.dart'
    as _i717;
import '../../../feature/survey_transactions/response/interface/i_get_all_transactions_repo.dart'
    as _i197;
import '../../../feature/survey_transactions/response/remote/get_all_transactions_repo.dart'
    as _i185;
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
    gh.lazySingleton<_i584.IExcelImportRepo>(
      () => _i269.ExcelImportRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i437.IGetAreaCodeRepo>(
      () => _i835.GetAreaCodeRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i930.IGetExcelAreaCodesRepo>(
      () => _i126.GetExcelAreaCodesRepo(gh<_i69.Apimanager>()),
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
    gh.lazySingleton<_i16.IDeleteDeviceAttendenceRepo>(
      () => _i469.DeleteDeviceAttendenceRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i492.ILoginRepo>(
      () => _i986.LoginRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i683.IExcelTemplateRepo>(
      () => _i327.ExcelTemplateRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i724.IGetExcelMobileSerialsRepo>(
      () => _i767.GetExcelMobileSerialsRepo(gh<_i69.Apimanager>()),
    );
    gh.factory<_i204.GetExcelMobileSerialsUseCase>(
      () => _i204.GetExcelMobileSerialsUseCase(
        gh<_i724.IGetExcelMobileSerialsRepo>(),
      ),
    );
    gh.lazySingleton<_i392.IGetCompanyRepo>(
      () => _i805.GetCompanyRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i938.IExportSurveysRepo>(
      () => _i230.ExportSurveysRepo(gh<_i69.Apimanager>()),
    );
    gh.factory<_i690.GetSurveyQuestionsUseCase>(
      () =>
          _i690.GetSurveyQuestionsUseCase(gh<_i859.IGetSurveyQuestionsRepo>()),
    );
    gh.lazySingleton<_i496.IDeleteTicketsRepo>(
      () => _i241.DeleteTicketsRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i615.IGetRepresentativeRepo>(
      () => _i59.GetRepresentativeRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i586.INoShowTicketRepo>(
      () => _i891.NoShowTicketRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i199.IGetBranchRepo>(
      () => _i800.GetBranchRepo(gh<_i69.Apimanager>()),
    );
    gh.factory<_i949.GetCompanyUseCase>(
      () => _i949.GetCompanyUseCase(gh<_i392.IGetCompanyRepo>()),
    );
    gh.factory<_i1070.GetExcelMobileSerialsCubit>(
      () => _i1070.GetExcelMobileSerialsCubit(
        gh<_i204.GetExcelMobileSerialsUseCase>(),
      ),
    );
    gh.lazySingleton<_i847.IGetSurveyByIdRepo>(
      () => _i575.GetSurveyByIdRepo(gh<_i69.Apimanager>()),
    );
    gh.factory<_i720.GetSurveyByIdUseCase>(
      () => _i720.GetSurveyByIdUseCase(gh<_i847.IGetSurveyByIdRepo>()),
    );
    gh.lazySingleton<_i903.IGetAllTicketsRepo>(
      () => _i873.GetAllTicketsRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i546.IGetMobileSerialsRepo>(
      () => _i783.GetMobileSerialsRepo(gh<_i69.Apimanager>()),
    );
    gh.lazySingleton<_i197.IGetAllTransactionsRepo>(
      () => _i185.GetAllTransactionsRepo(gh<_i69.Apimanager>()),
    );
    gh.factory<_i966.ExportSurveysUseCase>(
      () => _i966.ExportSurveysUseCase(gh<_i938.IExportSurveysRepo>()),
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
    gh.factory<_i21.ExcelImportUseCase>(
      () => _i21.ExcelImportUseCase(gh<_i584.IExcelImportRepo>()),
    );
    gh.factory<_i46.ExportSurveysCubit>(
      () => _i46.ExportSurveysCubit(gh<_i966.ExportSurveysUseCase>()),
    );
    gh.factory<_i141.GetNextTicketsUseCase>(
      () => _i141.GetNextTicketsUseCase(gh<_i751.IGetNextTicketsRepo>()),
    );
    gh.factory<_i977.DeleteDeviceAttendenceUseCase>(
      () => _i977.DeleteDeviceAttendenceUseCase(
        gh<_i16.IDeleteDeviceAttendenceRepo>(),
      ),
    );
    gh.factory<_i408.GetAreaCodeUseCase>(
      () => _i408.GetAreaCodeUseCase(gh<_i437.IGetAreaCodeRepo>()),
    );
    gh.factory<_i1035.CreateSurveyUseCase>(
      () => _i1035.CreateSurveyUseCase(gh<_i316.ICreateSurveyRepo>()),
    );
    gh.factory<_i883.GetCompanyCubit>(
      () => _i883.GetCompanyCubit(gh<_i949.GetCompanyUseCase>()),
    );
    gh.factory<_i493.GetBranchUseCase>(
      () => _i493.GetBranchUseCase(gh<_i199.IGetBranchRepo>()),
    );
    gh.factory<_i1039.GetExcelAreaCodesUseCase>(
      () => _i1039.GetExcelAreaCodesUseCase(gh<_i930.IGetExcelAreaCodesRepo>()),
    );
    gh.factory<_i750.DeleteDeviceAttendenceCubit>(
      () => _i750.DeleteDeviceAttendenceCubit(
        gh<_i977.DeleteDeviceAttendenceUseCase>(),
      ),
    );
    gh.factory<_i922.GetRepresentativeUseCase>(
      () => _i922.GetRepresentativeUseCase(gh<_i615.IGetRepresentativeRepo>()),
    );
    gh.factory<_i937.GetExcelAreaCodesCubit>(
      () => _i937.GetExcelAreaCodesCubit(gh<_i1039.GetExcelAreaCodesUseCase>()),
    );
    gh.factory<_i294.LoginCubit>(
      () => _i294.LoginCubit(gh<_i387.LoginUseCase>()),
    );
    gh.factory<_i247.ExcelTemplateUseCase>(
      () => _i247.ExcelTemplateUseCase(gh<_i683.IExcelTemplateRepo>()),
    );
    gh.factory<_i573.NoShowTicketUseCase>(
      () => _i573.NoShowTicketUseCase(gh<_i586.INoShowTicketRepo>()),
    );
    gh.factory<_i599.CreateSurveyCubit>(
      () => _i599.CreateSurveyCubit(
        gh<_i1035.CreateSurveyUseCase>(),
        gh<_i720.GetSurveyByIdUseCase>(),
      ),
    );
    gh.factory<_i349.GetAllTicketsUseCase>(
      () => _i349.GetAllTicketsUseCase(gh<_i903.IGetAllTicketsRepo>()),
    );
    gh.factory<_i789.GetMobileSerialsUseCase>(
      () => _i789.GetMobileSerialsUseCase(gh<_i546.IGetMobileSerialsRepo>()),
    );
    gh.factory<_i633.GetSurveyByIdCubit>(
      () => _i633.GetSurveyByIdCubit(gh<_i720.GetSurveyByIdUseCase>()),
    );
    gh.factory<_i1006.ExcelImportCubit>(
      () => _i1006.ExcelImportCubit(gh<_i21.ExcelImportUseCase>()),
    );
    gh.factory<_i506.DeleteTicketsCubit>(
      () => _i506.DeleteTicketsCubit(gh<_i584.DeleteTicketsUseCase>()),
    );
    gh.factory<_i762.GetNextTicketsCubit>(
      () => _i762.GetNextTicketsCubit(gh<_i141.GetNextTicketsUseCase>()),
    );
    gh.factory<_i717.GetAllTransactionsUseCase>(
      () =>
          _i717.GetAllTransactionsUseCase(gh<_i197.IGetAllTransactionsRepo>()),
    );
    gh.factory<_i69.NoShowTicketCubit>(
      () => _i69.NoShowTicketCubit(gh<_i573.NoShowTicketUseCase>()),
    );
    gh.factory<_i582.GetRepresentativeCubit>(
      () => _i582.GetRepresentativeCubit(gh<_i922.GetRepresentativeUseCase>()),
    );
    gh.factory<_i69.GetBranchCubit>(
      () => _i69.GetBranchCubit(gh<_i493.GetBranchUseCase>()),
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
    gh.factory<_i802.ExcelTemplateCubit>(
      () => _i802.ExcelTemplateCubit(gh<_i247.ExcelTemplateUseCase>()),
    );
    gh.factory<_i983.GetAllTransactionsCubit>(
      () =>
          _i983.GetAllTransactionsCubit(gh<_i717.GetAllTransactionsUseCase>()),
    );
    return this;
  }
}
