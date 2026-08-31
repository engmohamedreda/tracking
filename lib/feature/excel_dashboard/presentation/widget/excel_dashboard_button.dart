import 'package:flutter/material.dart';

import '../../../../core/helper/session/session_manager.dart';
import '../view/excel_dashboard_screen.dart';

/// زرار لوحة الإكسيل، بيظهر للـ SuperAdmin بس.
///
/// ملاحظة مهمة: ده إخفاء على مستوى الواجهة فقط ومش حماية أمنية.
/// أي حد عنده توكن صالح يقدر ينده على endpoints الاستيراد مباشرة،
/// فلازم السيرفر نفسه يتحقق من الرول على /import-*.
class ExcelDashboardButton extends StatelessWidget {
  const ExcelDashboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionManager.isSuperAdmin(),
      builder: (context, snapshot) {
        // لحد ما نقرأ الرول من الـ prefs مش بنعرض حاجة،
        // علشان الزرار مايظهرش ويختفي فجأة.
        if (snapshot.data != true) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: FilledButton.tonalIcon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExcelDashboardScreen(),
                ),
              );
            },
            icon: const Icon(Icons.table_chart_outlined),
            label: const Text(' لوحه التحكم '),
          ),
        );
      },
    );
  }
}
