import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../../branch/cubit/get_branch_cubit.dart';
import '../../../company/cubit/get_company_cubit.dart';
import '../../../excel_area_codes/cubit/get_excel_area_codes_cubit.dart';
import '../../../excel_import/cubit/excel_import_cubit.dart';
import '../../../excel_import/cubit/excel_import_state.dart';
import '../../../excel_import/model/excel_import_type.dart';
import '../../../excel_mobile_serials/cubit/get_excel_mobile_serials_cubit.dart';
import '../../../excel_template/cubit/excel_template_cubit.dart';
import '../../../excel_template/cubit/excel_template_state.dart';
import '../../../export_surveys/cubit/export_surveys_cubit.dart';
import '../../../representative/cubit/get_representative_cubit.dart';
import '../../../survey_transactions/cubit/get_all_transactions_cubit.dart';
import 'sections/excel_area_codes_section.dart';
import 'sections/excel_branch_section.dart';
import 'sections/excel_company_section.dart';
import 'sections/excel_mobile_serials_section.dart';
import 'sections/excel_representatives_section.dart';
import 'sections/excel_users_section.dart';
import 'sections/survey_transactions_section.dart';

/// لوحة إدارة شيتات الإكسيل، متاحة للـ SuperAdmin بس.
/// كل قسم فيه: تحميل النموذج + رفع الشيت + البيانات الفعلية تحتيهم.
class ExcelDashboardScreen extends StatelessWidget {
  const ExcelDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // كيوبت واحد للاستيراد وواحد للنماذج بيخدموا الست أقسام كلهم،
        // لأن الـ state بيشيل الـ type فكل قسم بيعرف نفسه.
        BlocProvider(create: (_) => getIt<ExcelImportCubit>()),
        BlocProvider(create: (_) => getIt<ExcelTemplateCubit>()),
        BlocProvider(create: (_) => getIt<GetCompanyCubit>()..load()),
        BlocProvider(create: (_) => getIt<GetBranchCubit>()..load()),
        BlocProvider(create: (_) => getIt<GetExcelAreaCodesCubit>()..load()),
        BlocProvider(
          create: (_) => getIt<GetExcelMobileSerialsCubit>()..load(),
        ),
        BlocProvider(create: (_) => getIt<GetRepresentativeCubit>()..load()),
        BlocProvider(create: (_) => getIt<GetAllTransactionsCubit>()..load()),
        BlocProvider(create: (_) => getIt<ExportSurveysCubit>()),
      ],
      child: const _ExcelDashboardBody(),
    );
  }
}

class _ExcelDashboardBody extends StatefulWidget {
  const _ExcelDashboardBody();

  @override
  State<_ExcelDashboardBody> createState() => _ExcelDashboardBodyState();
}

class _ExcelDashboardBodyState extends State<_ExcelDashboardBody> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _companiesKey = GlobalKey();
  final GlobalKey _branchesKey = GlobalKey();
  final GlobalKey _areaCodesKey = GlobalKey();
  final GlobalKey _mobileSerialsKey = GlobalKey();
  final GlobalKey _representativesKey = GlobalKey();
  final GlobalKey _usersKey = GlobalKey();
  final GlobalKey _transactionsKey = GlobalKey();

  final List<_DashboardSectionTarget> _sectionTargets = [];

  @override
  void initState() {
    super.initState();
    _sectionTargets.addAll([
      _DashboardSectionTarget('الشركات', _companiesKey),
      _DashboardSectionTarget('الفروع', _branchesKey),
      _DashboardSectionTarget('أكواد المناطق', _areaCodesKey),
      _DashboardSectionTarget('سيريالات الموبايل', _mobileSerialsKey),
      _DashboardSectionTarget('المناديب', _representativesKey),
      _DashboardSectionTarget('المستخدمين', _usersKey),
      _DashboardSectionTarget('معاملات الاستبيانات', _transactionsKey),
    ]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = key.currentContext;
      if (targetContext == null) return;

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    });
  }

  /// بعد نجاح أي استيراد بنعيد تحميل بيانات القسم بتاعه
  /// علشان المستخدم يشوف اللي رفعه على طول.
  void _refreshSectionData(BuildContext context, ExcelImportType type) {
    switch (type) {
      case ExcelImportType.company:
        context.read<GetCompanyCubit>().refresh();
        break;
      case ExcelImportType.branch:
        context.read<GetBranchCubit>().refresh();
        break;
      case ExcelImportType.areaCode:
        context.read<GetExcelAreaCodesCubit>().refresh();
        break;
      case ExcelImportType.mobileSerials:
        context.read<GetExcelMobileSerialsCubit>().refresh();
        break;
      case ExcelImportType.representative:
        context.read<GetRepresentativeCubit>().refresh();
        break;
      case ExcelImportType.users:
        break;
    }
  }

  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFDC2626) : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ExcelImportCubit, ExcelImportState>(
          listener: (context, state) {
            if (state is ExcelImportSuccess) {
              _showMessage(context, state.response.message);
              _refreshSectionData(context, state.type);
            }

            if (state is ExcelImportError) {
              _showMessage(context, state.failure.errorMsg, isError: true);
            }
          },
        ),
        BlocListener<ExcelTemplateCubit, ExcelTemplateState>(
          listener: (context, state) {
            if (state is ExcelTemplateSuccess) {
              _showMessage(context, state.message);
            }

            if (state is ExcelTemplateError) {
              _showMessage(context, state.failure.errorMsg, isError: true);
            }

            // الإلغاء مش خطأ، فمش بنعرض أي رسالة.
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('لوحة  التحكم')),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _DashboardIntro(),
                    const SizedBox(height: 14),
                    _DashboardSectionNavigator(
                      targets: _sectionTargets,
                      onSelected: _scrollToSection,
                    ),
                    const SizedBox(height: 18),
                    Container(
                      key: _companiesKey,
                      child: const ExcelCompanySection(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      key: _branchesKey,
                      child: const ExcelBranchSection(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      key: _areaCodesKey,
                      child: const ExcelAreaCodesSection(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      key: _mobileSerialsKey,
                      child: const ExcelMobileSerialsSection(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      key: _representativesKey,
                      child: const ExcelRepresentativesSection(),
                    ),
                    const SizedBox(height: 16),
                    Container(key: _usersKey, child: const ExcelUsersSection()),
                    const SizedBox(height: 16),
                    Container(
                      key: _transactionsKey,
                      child: const SurveyTransactionsSection(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardSectionTarget {
  final String title;
  final GlobalKey key;

  const _DashboardSectionTarget(this.title, this.key);
}

class _DashboardSectionNavigator extends StatelessWidget {
  final List<_DashboardSectionTarget> targets;
  final ValueChanged<GlobalKey> onSelected;

  const _DashboardSectionNavigator({
    required this.targets,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF8FAFC),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.menu_open_outlined, color: Color(0xFF0F766E)),
                SizedBox(width: 10),
                Text(
                  'الانتقال إلى قسم:',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: targets
                  .map(
                    (target) => OutlinedButton.icon(
                      onPressed: () => onSelected(target.key),
                      icon: const Icon(Icons.arrow_downward, size: 18),
                      label: Text(target.title),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardIntro extends StatelessWidget {
  const _DashboardIntro();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEFFDF9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Color(0xFF0F766E),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [SizedBox(height: 6)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
