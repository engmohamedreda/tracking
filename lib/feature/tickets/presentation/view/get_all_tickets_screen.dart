import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/di/di.dart';
import '../../../auth/login/presentation/view/login_screen.dart';
import '../../../excel_dashboard/presentation/widget/excel_dashboard_button.dart';
import '../../../ntickets/presentation/view/get_next_tickets_screen.dart';
import 'tickets_tv_display_screen.dart';
import '../../cubit/get_all_tickets_cubit.dart';
import '../../cubit/get_all_tickets_state.dart';
import '../../model/ticket_entity.dart';
import '../../../delete_device_attendence/cubit/delete_device_attendence_cubit.dart';
import '../../../delete_device_attendence/cubit/delete_device_attendence_state.dart';

class GetAllTicketsScreen extends StatelessWidget {
  const GetAllTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<GetAllTicketsCubit>()..load()),
        BlocProvider(create: (_) => getIt<DeleteDeviceAttendenceCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التذاكر'),
          actions: [
            const ExcelDashboardButton(),
            BlocConsumer<
              DeleteDeviceAttendenceCubit,
              DeleteDeviceAttendenceState
            >(
              listener: (context, state) {
                if (state is DeleteDeviceAttendenceSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.response.message)),
                  );
                } else if (state is DeleteDeviceAttendenceError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final loading = state is DeleteDeviceAttendenceLoading;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: FilledButton.tonalIcon(
                    onPressed: loading
                        ? null
                        : () => context
                              .read<DeleteDeviceAttendenceCubit>()
                              .deleteDeviceAttendence(),
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.fingerprint),
                    label: const Text('حذف حضور الجهاز'),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');

                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('تسجيل الخروج'),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TicketsTvDisplayScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.live_tv_outlined),
                label: const Text('عرض شاشة العملاء'),
              ),
            ),
            //_UsersTemplateButton(),
            BlocBuilder<GetAllTicketsCubit, GetAllTicketsState>(
              builder: (context, state) {
                final isLoading = state is GetAllTicketsLoading;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: IconButton.filledTonal(
                    tooltip: 'تحديث',
                    onPressed: isLoading
                        ? null
                        : () => context.read<GetAllTicketsCubit>().refresh(),
                    icon: const Icon(Icons.refresh),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<GetAllTicketsCubit, GetAllTicketsState>(
          builder: (context, state) {
            if (state is GetAllTicketsLoading) {
              return const _PageLoader(message: 'جاري تحميل التذاكر...');
            }

            if (state is GetAllTicketsError) {
              return _ErrorView(
                message: state.failure.errorMsg,
                onRetry: () => context.read<GetAllTicketsCubit>().load(),
              );
            }

            if (state is GetAllTicketsSuccess) {
              final tickets = state.response.tickets;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Column(
                    children: [
                      Expanded(
                        child: tickets.isEmpty
                            ? const _EmptyView()
                            : RefreshIndicator(
                                onRefresh: () => context
                                    .read<GetAllTicketsCubit>()
                                    .refresh(),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final cardWidth =
                                        (constraints.maxWidth - 64) / 2;

                                    return ListView(
                                      padding: const EdgeInsets.fromLTRB(
                                        24,
                                        16,
                                        24,
                                        120,
                                      ),
                                      children: [
                                        _HeaderCard(tickets: tickets),
                                        const SizedBox(height: 18),
                                        Wrap(
                                          spacing: 16,
                                          runSpacing: 16,
                                          children: tickets.map((ticket) {
                                            return SizedBox(
                                              width: cardWidth,
                                              child: _TicketCard(
                                                ticket: ticket,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                      ),
                      _BottomActionBar(
                        label: 'العميل التالي',
                        icon: Icons.queue_play_next_outlined,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GetNextTicketsScreen(),
                            ),
                          );
                          if (!context.mounted) return;
                          context.read<GetAllTicketsCubit>().refresh();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _UsersTemplateButton extends StatefulWidget {
  @override
  State<_UsersTemplateButton> createState() => _UsersTemplateButtonState();
}

class _UsersTemplateButtonState extends State<_UsersTemplateButton> {
  bool _isLoading = false;

  Future<void> _downloadTemplate() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final response = await getIt<Apimanager>().getData(
        endpoint: Endpoint.usersTemplate,
        options: Options(
          responseType: ResponseType.bytes,
          contentType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          validateStatus: (status) => true,
        ),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw Exception('تعذر تحميل قالب العملاء (${response.statusCode})');
      }

      final data = response.data;
      if (data is! List<int>) {
        throw Exception('استجابة ملف القالب غير صحيحة');
      }

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'حفظ قالب العملاء',
        fileName: 'users-template.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        bytes: Uint8List.fromList(data),
      );

      if (!mounted || savedPath == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحميل قالب العملاء بنجاح')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تحميل قالب العملاء: $error')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: FilledButton.tonalIcon(
        onPressed: _isLoading ? null : _downloadTemplate,
        icon: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.download_outlined),
        label: const Text('تحميل قالب العملاء'),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final List<TicketEntity> tickets;

  const _HeaderCard({required this.tickets});

  @override
  Widget build(BuildContext context) {
    final waitingCount = tickets.where((ticket) => ticket.isWaiting).length;
    final calledCount = tickets
        .where((ticket) => ticket.status.toLowerCase() == 'iscalled')
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0F766E)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;
          final title = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'كل التذاكر',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تابع العملاء المنتظرين وافتح العميل التالي.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.82),
                ),
              ),
            ],
          );
          final stats = Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatPill(label: 'الإجمالي', value: tickets.length.toString()),
              _StatPill(label: 'انتظار', value: waitingCount.toString()),
              _StatPill(label: 'تم النداء', value: calledCount.toString()),
            ],
          );

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [title, const SizedBox(height: 18), stats],
            );
          }

          return Row(
            children: [
              Expanded(child: title),
              stats,
            ],
          );
        },
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketEntity ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 600;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_outlined,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ticket.ticketsNumber}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: ticket.status),
              ],
            ),
            const SizedBox(height: 16),
            _InfoTile(
              icon: Icons.person_outline,
              label: 'المندوب',
              value: ticket.representativeName,
              showLabel: !isCompact,
            ),
            _InfoTile(
              icon: Icons.apartment_outlined,
              label: 'الشركة',
              value: ticket.companyName,
              showLabel: !isCompact,
            ),
            _InfoTile(
              icon: Icons.store_mall_directory_outlined,
              label: 'الفرع',
              value: ticket.branchName,
              showLabel: !isCompact,
            ),
            _InfoTile(
              icon: Icons.fingerprint,
              label: 'البصمة',
              value: ticket.representativeFingerPrint,
              showLabel: !isCompact,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showLabel;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  if (showLabel)
                    TextSpan(
                      text: '$label: ',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  TextSpan(
                    text: value.isEmpty ? '-' : value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  String _statusLabel(String value) {
    final lower = value.toLowerCase();
    if (lower == 'waiting') return 'انتظار';
    if (lower == 'iscalled') return 'تم النداء';
    return value.isEmpty ? '-' : value;
  }

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    final color = lower == 'waiting'
        ? const Color(0xFFF59E0B)
        : lower == 'iscalled'
        ? const Color(0xFF2563EB)
        : const Color(0xFF0F766E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(color: color, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _BottomActionBar({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon),
                  label: Text(label),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageLoader extends StatelessWidget {
  final String message;

  const _PageLoader({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('لا توجد تذاكر'));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFEF4444),
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
