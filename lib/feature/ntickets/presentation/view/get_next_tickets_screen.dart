import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../../dtickets/delete_tickets/cubit/delete_tickets_cubit.dart';
import '../../../dtickets/delete_tickets/cubit/delete_tickets_state.dart';
import '../../../dtickets/no_show_tickets/cubit/no_show_ticket_cubit.dart';
import '../../../dtickets/no_show_tickets/cubit/no_show_ticket_state.dart';
import '../../../ticket_survey_flow/presentation/view/ticket_survey_setup_screen.dart';
import '../../cubit/get_next_tickets_cubit.dart';
import '../../cubit/get_next_tickets_state.dart';
import '../../model/ticket_entity.dart';

class GetNextTicketsScreen extends StatelessWidget {
  const GetNextTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetNextTicketsCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => getIt<DeleteTicketsCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<NoShowTicketCubit>(),
        ),
      ],
      child: const _GetNextTicketsView(),
    );
  }
}

class _GetNextTicketsView extends StatelessWidget {
  const _GetNextTicketsView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteTicketsCubit, DeleteTicketsState>(
          listener: (context, state) {
            if (state is DeleteTicketsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message)),
              );

              if (state.response.isDeleted) {
                context.read<GetNextTicketsCubit>().load();
              }
            }

            if (state is DeleteTicketsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<NoShowTicketCubit, NoShowTicketState>(
          listener: (context, state) {
            if (state is NoShowTicketSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message)),
              );

              if (state.response.isSuccess) {
                context.read<GetNextTicketsCubit>().load();
              }
            }

            if (state is NoShowTicketError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('العميل التالي'),
          actions: [
            BlocBuilder<GetNextTicketsCubit, GetNextTicketsState>(
              builder: (context, state) {
                final isLoading = state is GetNextTicketsLoading;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: IconButton.filledTonal(
                    tooltip: 'تحديث',
                    onPressed: isLoading
                        ? null
                        : () => context.read<GetNextTicketsCubit>().refresh(),
                    icon: const Icon(Icons.refresh),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: BlocBuilder<GetNextTicketsCubit, GetNextTicketsState>(
              builder: (context, nextState) {
                final ticket = nextState is GetNextTicketsSuccess &&
                        nextState.response.hasTicket
                    ? nextState.response.ticket
                    : null;
                final isNextLoading = nextState is GetNextTicketsLoading;

                return Column(
                  children: [
                    Expanded(
                      child: _Body(
                        state: nextState,
                        ticket: ticket,
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: BlocBuilder<DeleteTicketsCubit, DeleteTicketsState>(
                        builder: (context, deleteState) {
                          return BlocBuilder<NoShowTicketCubit, NoShowTicketState>(
                            builder: (context, noShowState) {
                              final isDeleteLoading =
                                  deleteState is DeleteTicketsLoading;
                              final isNoShowLoading =
                                  noShowState is NoShowTicketLoading;
                              final isBusy =
                                  isNextLoading || isDeleteLoading || isNoShowLoading;

                              return Container(
                                padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: isBusy || ticket == null
                                            ? null
                                            : () => _confirmDelete(context, ticket),
                                        icon: isDeleteLoading
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Icon(Icons.delete_outline),
                                        label: const Text('حذف'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: FilledButton.tonalIcon(
                                        onPressed: isBusy || ticket == null
                                            ? null
                                            : () => _confirmNoShow(context, ticket),
                                        icon: isNoShowLoading
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Icon(Icons.person_off_outlined),
                                        label: const Text('لم يحضر'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: isBusy || ticket == null
                                            ? null
                                            : () => _openTicketSetup(
                                                  context,
                                                  ticket,
                                                ),
                                        icon: const Icon(Icons.arrow_forward),
                                        label: const Text('التالي'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, TicketEntity ticket) async {
    final deleteCubit = context.read<DeleteTicketsCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('حذف التذكرة؟'),
          content: Text('هل أنت متأكد من حذف التذكرة رقم ${ticket.ticketsNumber}؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      deleteCubit.deleteTicket(ticketId: ticket.id);
    }
  }

  Future<void> _confirmNoShow(BuildContext context, TicketEntity ticket) async {
    final noShowCubit = context.read<NoShowTicketCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تسجيل العميل كغير حاضر؟'),
          content: Text('هل أنت متأكد من تسجيل التذكرة رقم ${ticket.ticketsNumber} كغير حاضر؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.person_off_outlined),
              label: const Text('لم يحضر'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      noShowCubit.markNoShow(ticketId: ticket.id);
    }
  }

  Future<void> _openTicketSetup(BuildContext context, TicketEntity ticket) async {
    final nextCubit = context.read<GetNextTicketsCubit>();

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TicketSurveySetupScreen(ticket: ticket),
      ),
    );

    if (result == true) {
      await nextCubit.load();
    }
  }
}

class _Body extends StatelessWidget {
  final GetNextTicketsState state;
  final TicketEntity? ticket;

  const _Body({
    required this.state,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final currentState = state;
    final currentTicket = ticket;

    if (currentState is GetNextTicketsLoading) {
      return const _PageLoader(message: 'جاري تحميل العميل التالي...');
    }

    if (currentState is GetNextTicketsError) {
      return _ErrorView(
        message: currentState.failure.errorMsg,
        onRetry: () => context.read<GetNextTicketsCubit>().load(),
      );
    }

    if (currentTicket == null) {
      return const _EmptyNextTicket();
    }

    return RefreshIndicator(
      onRefresh: () => context.read<GetNextTicketsCubit>().refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        children: [
          _TopBanner(ticket: currentTicket),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 880;
              if (!isWide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MainTicketCard(ticket: currentTicket),
                    const SizedBox(height: 16),
                    _TimelineCard(ticket: currentTicket),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _MainTicketCard(ticket: currentTicket),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _TimelineCard(ticket: currentTicket),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  final TicketEntity ticket;

  const _TopBanner({required this.ticket});

  String _statusLabel(String value) {
    final lower = value.toLowerCase();
    if (lower == 'waiting') return 'انتظار';
    if (lower == 'iscalled') return 'تم النداء';
    return value.isEmpty ? '-' : value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF2563EB)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.queue_play_next_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تذكرة رقم ${ticket.ticketsNumber}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  ticket.representativeName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _WhiteStatusChip(status: ticket.status),
        ],
      ),
    );
  }
}

class _WhiteStatusChip extends StatelessWidget {
  final String status;

  const _WhiteStatusChip({required this.status});

  String _statusLabel(String value) {
    final lower = value.toLowerCase();
    if (lower == 'waiting') return 'انتظار';
    if (lower == 'iscalled') return 'تم النداء';
    return value.isEmpty ? '-' : value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Text(
        _statusLabel(status),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MainTicketCard extends StatelessWidget {
  final TicketEntity ticket;

  const _MainTicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'بيانات التذكرة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 18),
            _TimelineItem(
              icon: Icons.confirmation_number_outlined,
              label: 'رقم التذكرة',
              value: ticket.id.toString(),
              active: true,
            ),
            _TimelineItem(
              icon: Icons.person_outline,
              label: 'المندوب',
              value: ticket.representativeName,
              active: true,
            ),
            _TimelineItem(
              icon: Icons.apartment_outlined,
              label: 'الشركة',
              value: ticket.companyName,
              active: true,
            ),
            _TimelineItem(
              icon: Icons.store_mall_directory_outlined,
              label: 'الفرع',
              value: ticket.branchName,
              active: true,
            ),
            _TimelineItem(
              icon: Icons.fingerprint,
              label: 'البصمة',
              value: ticket.representativeFingerPrint,
              active: true,
            ),
            _TimelineItem(
              icon: Icons.badge_outlined,
              label: 'رقم المندوب',
              value: ticket.representativeId.toString(),
              active: true,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2563EB)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final TicketEntity ticket;

  const _TimelineCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'توقيت التذكرة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 18),
            _TimelineItem(
              icon: Icons.login,
              label: 'وقت الدخول',
              value: ticket.checkInTime,
              active: true,
            ),
            _TimelineItem(
              icon: Icons.call_received,
              label: 'تم النداء',
              value: ticket.hasCalledTime ? ticket.checkCalledTime : 'لم يتم النداء بعد',
              active: ticket.hasCalledTime,
            ),
            _TimelineItem(
              icon: Icons.done_all,
              label: 'تم الانتهاء',
              value: ticket.hasCompletedTime
                  ? ticket.checkCompletedTime
                  : 'لم يتم الانتهاء بعد',
              active: ticket.hasCompletedTime,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool active;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.active,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF2563EB) : const Color(0xFF94A3B8);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ),
      ],
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

class _EmptyNextTicket extends StatelessWidget {
  const _EmptyNextTicket();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('لا توجد تذكرة تالية'));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

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
              Text(
                message,
                textAlign: TextAlign.center,
              ),
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
