import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/excel_template_response.dart';
import '../model/excel_template_type.dart';
import 'excel_template_state.dart';
import 'excel_template_usecase.dart';

@injectable
class ExcelTemplateCubit extends Cubit<ExcelTemplateState> {
  final ExcelTemplateUseCase excelTemplateUseCase;

  ExcelTemplateCubit(this.excelTemplateUseCase)
      : super(ExcelTemplateInitial());

  ExcelTemplateType? selectedType;

  /// بينزل التمبلت من السيرفر بس، من غير حفظ.
  /// مفيدة لو عايز تعمل بحاجة تانية بالـ bytes.
  Future<ExcelTemplateResponse?> download({
    required ExcelTemplateType type,
  }) async {
    selectedType = type;
    emit(ExcelTemplateLoading(type: type));

    final result = await excelTemplateUseCase(type: type);

    if (isClosed) return null;

    return result.fold(
      (failure) {
        emit(ExcelTemplateError(type: type, failure: failure));
        return null;
      },
      (response) => response,
    );
  }

  /// بينزل التمبلت ويفتح نافذة الحفظ.
  /// على الويب المتصفح هو اللي بينزّل الملف و saveFile بترجع null دايماً،
  /// فبنستخدم kIsWeb علشان منحسبهاش إلغاء.
  Future<void> downloadAndSave({
    required ExcelTemplateType type,
  }) async {
    selectedType = type;
    emit(ExcelTemplateLoading(type: type));

    final result = await excelTemplateUseCase(type: type);

    if (isClosed) return;

    await result.fold(
      (failure) async {
        emit(ExcelTemplateError(type: type, failure: failure));
      },
      (response) async {
        emit(
          ExcelTemplateLoading(
            type: type,
            message: 'جاري حفظ الملف...',
          ),
        );

        try {
          final savedPath = await FilePicker.platform.saveFile(
            dialogTitle: type.title,
            fileName: response.fileName,
            type: FileType.custom,
            allowedExtensions: const ['xlsx'],
            bytes: response.bytes,
          );

          if (isClosed) return;

          if (!kIsWeb && savedPath == null) {
            emit(
              ExcelTemplateSaveCancelled(type: type, response: response),
            );
            return;
          }

          emit(
            ExcelTemplateSuccess(
              type: type,
              response: response,
              savedPath: savedPath,
            ),
          );
        } catch (e) {
          if (isClosed) return;
          emit(
            ExcelTemplateError(
              type: type,
              failure: ServerError(errorMsg: e.toString()),
            ),
          );
        }
      },
    );
  }

  void reset() {
    emit(ExcelTemplateInitial());
  }
}
