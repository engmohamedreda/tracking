import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../cubit/get_all_tickets_cubit.dart';
import '../../cubit/get_all_tickets_state.dart';
import '../../model/ticket_entity.dart';

class TicketsTvDisplayScreen extends StatelessWidget {
  const TicketsTvDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetAllTicketsCubit>()..load(),
      child: const _TicketsLiveBoardView(),
    );
  }
}

class _TicketsLiveBoardView extends StatefulWidget {
  const _TicketsLiveBoardView();

  @override
  State<_TicketsLiveBoardView> createState() => _TicketsLiveBoardViewState();
}

class _TicketsLiveBoardViewState extends State<_TicketsLiveBoardView> {
  static const int _refreshSeconds = 15;

  Timer? _refreshTimer;
  Timer? _countdownTimer;
  DateTime? _lastUpdated;
  int _secondsLeft = _refreshSeconds;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: _refreshSeconds),
      (_) {
        if (!mounted) return;
        context.read<GetAllTicketsCubit>().refresh(silent: true);
        setState(() => _secondsLeft = _refreshSeconds);
      },
    );

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;
        setState(() {
          _secondsLeft = _secondsLeft <= 1 ? _refreshSeconds : _secondsLeft - 1;
        });
      },
    );
  }

  Future<void> _manualRefresh() async {
    await context.read<GetAllTicketsCubit>().refresh(silent: true);
    if (!mounted) return;
    setState(() => _secondsLeft = _refreshSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: BlocConsumer<GetAllTicketsCubit, GetAllTicketsState>(
        listener: (context, state) {
          if (state is GetAllTicketsSuccess) {
            setState(() => _lastUpdated = DateTime.now());
          }
        },
        builder: (context, state) {
          if (state is GetAllTicketsLoading) {
            return const _BoardLoading();
          }

          if (state is GetAllTicketsError) {
            return _BoardError(
              message: state.failure.errorMsg,
              onRetry: () => context.read<GetAllTicketsCubit>().load(),
            );
          }

          if (state is GetAllTicketsSuccess) {
            return _LiveBoardBody(
              tickets: state.response.tickets,
              lastUpdated: _lastUpdated,
              secondsLeft: _secondsLeft,
              onRefresh: _manualRefresh,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LiveBoardBody extends StatelessWidget {
  final List<TicketEntity> tickets;
  final DateTime? lastUpdated;
  final int secondsLeft;
  final Future<void> Function() onRefresh;

  const _LiveBoardBody({
    required this.tickets,
    required this.lastUpdated,
    required this.secondsLeft,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final calledTickets = tickets
        .where((ticket) => ticket.status.toLowerCase() == 'iscalled')
        .toList()
      ..sort(_sortCalledTickets);

    final waitingTickets = tickets.where((ticket) => ticket.isWaiting).toList()
      ..sort((a, b) => a.ticketsNumber.compareTo(b.ticketsNumber));

    final hasCalledCustomer = calledTickets.isNotEmpty;
    final mainTicket = hasCalledCustomer
        ? calledTickets.first
        : (waitingTickets.isNotEmpty ? waitingTickets.first : null);

    final customersAfterMain = hasCalledCustomer
        ? waitingTickets
        : waitingTickets.skip(1).toList();

    final allBoardTickets = <TicketEntity>[
      if (mainTicket != null) mainTicket,
      ...customersAfterMain,
    ];

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1050;
          final compactHeight = constraints.maxHeight < 760;
          final padding = compactHeight ? 14.0 : 22.0;
          final gap = compactHeight ? 12.0 : 18.0;

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                _LiveBoardHeader(
                  total: tickets.length,
                  waiting: waitingTickets.length,
                  called: calledTickets.length,
                  lastUpdated: lastUpdated,
                  secondsLeft: secondsLeft,
                  onRefresh: onRefresh,
                ),
                SizedBox(height: gap),
                Expanded(
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 5,
                              child: _MainCustomerPanel(
                                ticket: mainTicket,
                                isCalled: hasCalledCustomer,
                              ),
                            ),
                            SizedBox(width: gap),
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: _CustomersAfterPanel(
                                      tickets: customersAfterMain.take(4).toList(),
                                    ),
                                  ),
                                  SizedBox(height: gap),
                                  Expanded(
                                    flex: 6,
                                    child: _QueueTablePanel(
                                      tickets: allBoardTickets,
                                      mainTicketId: mainTicket?.id,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          children: [
                            SizedBox(
                              height: 420,
                              child: _MainCustomerPanel(
                                ticket: mainTicket,
                                isCalled: hasCalledCustomer,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 330,
                              child: _CustomersAfterPanel(
                                tickets: customersAfterMain.take(4).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 620,
                              child: _QueueTablePanel(
                                tickets: allBoardTickets,
                                mainTicketId: mainTicket?.id,
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: gap),
                _FooterRefreshBar(secondsLeft: secondsLeft),
              ],
            ),
          );
        },
      ),
    );
  }

  static int _sortCalledTickets(TicketEntity a, TicketEntity b) {
    final aDate = DateTime.tryParse(a.checkCalledTime);
    final bDate = DateTime.tryParse(b.checkCalledTime);

    if (aDate != null && bDate != null) {
      return bDate.compareTo(aDate);
    }

    return b.ticketsNumber.compareTo(a.ticketsNumber);
  }
}

class _LiveBoardHeader extends StatelessWidget {
  final int total;
  final int waiting;
  final int called;
  final DateTime? lastUpdated;
  final int secondsLeft;
  final Future<void> Function() onRefresh;

  const _LiveBoardHeader({
    required this.total,
    required this.waiting,
    required this.called,
    required this.lastUpdated,
    required this.secondsLeft,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF07111F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1D2B3F), width: 1.2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 980;
          final title = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFACC15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.groups_2_outlined,
                  color: Color(0xFF111827),
                  size: 38,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'شاشة العملاء',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'شاشة انتظار العملاء',
                    style: TextStyle(
                      color: Color(0xFFFACC15),
                      fontSize: 17,
                      letterSpacing: 2.4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          );

          final info = Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoBox(label: 'الإجمالي', value: '$total'),
              _InfoBox(label: 'انتظار', value: '$waiting'),
              _InfoBox(label: 'تم النداء', value: '$called'),
              _InfoBox(label: 'التحديث', value: '${secondsLeft}s'),
              _InfoBox(label: 'الوقت', value: _formatTime(lastUpdated)),
              IconButton.filled(
                tooltip: 'تحديث الآن',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFACC15),
                  foregroundColor: const Color(0xFF111827),
                  minimumSize: const Size(52, 52),
                ),
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
              ),
              IconButton.filled(
                tooltip: 'رجوع',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(52, 52),
                ),
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          );

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [title, const SizedBox(height: 14), info],
            );
          }

          return Row(
            children: [
              Expanded(child: title),
              const SizedBox(width: 16),
              info,
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--:--';
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(dateTime.hour)}:${two(dateTime.minute)}:${two(dateTime.second)}';
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1727),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF26364F)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainCustomerPanel extends StatelessWidget {
  final TicketEntity? ticket;
  final bool isCalled;

  const _MainCustomerPanel({required this.ticket, required this.isCalled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xFF07111F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF26364F), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ticket == null
          ? const _NoMainCustomer()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionTitle(
                  title: isCalled ? 'العميل التالي' : 'أول عميل في الانتظار',
                  subtitle: isCalled ? 'العميل الحالي' : 'أول عميل في الانتظار',
                  icon: isCalled
                      ? Icons.campaign_outlined
                      : Icons.hourglass_top_rounded,
                  color: isCalled
                      ? const Color(0xFF22C55E)
                      : const Color(0xFF38BDF8),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF030712),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF374151)),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            '${ticket!.ticketsNumber}',
                            style: const TextStyle(
                              color: Color(0xFFFACC15),
                              fontSize: 280,
                              fontWeight: FontWeight.w900,
                              height: 0.86,
                              letterSpacing: -8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _MainCustomerInfo(ticket: ticket!),
              ],
            ),
    );
  }
}

class _MainCustomerInfo extends StatelessWidget {
  final TicketEntity ticket;

  const _MainCustomerInfo({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Text(
            _safe(ticket.representativeName),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _MiniTag(label: 'الكود', value: ticket.representativeFingerPrint),
              _MiniTag(label: 'الشركة', value: ticket.companyName),
              _MiniTag(label: 'الفرع', value: ticket.branchName),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomersAfterPanel extends StatelessWidget {
  final List<TicketEntity> tickets;

  const _CustomersAfterPanel({required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1727),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF26364F), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(
            title: 'العملاء اللي بعده',
            subtitle: '',
            icon: Icons.format_list_numbered_rtl_outlined,
            color: Color(0xFF38BDF8),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: tickets.isEmpty
                ? const _NoUpcomingCustomers()
                : Row(
                    children: tickets.map((ticket) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          child: _UpcomingCustomerCard(ticket: ticket),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
class _UpcomingCustomerCard extends StatelessWidget {
  final TicketEntity ticket;

  const _UpcomingCustomerCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 105;

        return Container(
          padding: EdgeInsets.all(compact ? 8 : 14),
          decoration: BoxDecoration(
            color: const Color(0xFF030712),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 130,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${ticket.ticketsNumber}',
                      style: TextStyle(
                        color: const Color(0xFF7DD3FC),
                        fontSize:  30,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: compact ? 6 : 10),
                    Text(
                      _safe(ticket.representativeName),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:  18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QueueTablePanel extends StatelessWidget {
  final List<TicketEntity> tickets;
  final int? mainTicketId;

  const _QueueTablePanel({required this.tickets, required this.mainTicketId});

  @override
  Widget build(BuildContext context) {
    final visibleTickets = tickets.take(12).toList();
    final hiddenCount = tickets.length > visibleTickets.length
        ? tickets.length - visibleTickets.length
        : 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF07111F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF26364F), width: 1.4),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF0B1727),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.table_rows_outlined,
                  color: Color(0xFFFACC15),
                  size: 30,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'قائمة العملاء المباشرة | ترتيب العملاء',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Text(
                    '${tickets.length} عميل',
                    style: const TextStyle(
                      color: Color(0xFFFACC15),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const _QueueHeaderRow(),
          Expanded(
            child: visibleTickets.isEmpty
                ? const _NoWaitingData()
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleTickets.length + (hiddenCount > 0 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= visibleTickets.length) {
                        return _MoreCustomersRow(count: hiddenCount);
                      }

                      final ticket = visibleTickets[index];
                      final isMain = mainTicketId != null && ticket.id == mainTicketId;

                      return _QueueDataRow(
                        ticket: ticket,
                        index: index,
                        isMain: isMain,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QueueHeaderRow extends StatelessWidget {
  const _QueueHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      color: const Color(0xFF111827),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          _HeaderCell(width: 72, text: 'الترتيب'),
          _HeaderCell(width: 116, text: 'التذكرة'),
          Expanded(flex: 4, child: _HeaderCell(text: 'العميل')),
          Expanded(flex: 3, child: _HeaderCell(text: 'الكود / الفرع')),
          _HeaderCell(width: 142, text: 'الحالة'),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final double? width;

  const _HeaderCell({required this.text, this.width});

  @override
  Widget build(BuildContext context) {
    final child = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFFFACC15),
        fontSize: 14,
        letterSpacing: 1.4,
        fontWeight: FontWeight.w900,
      ),
    );

    if (width == null) return child;
    return SizedBox(width: width, child: child);
  }
}

class _QueueDataRow extends StatelessWidget {
  final TicketEntity ticket;
  final int index;
  final bool isMain;

  const _QueueDataRow({
    required this.ticket,
    required this.index,
    required this.isMain,
  });

  @override
  Widget build(BuildContext context) {
    final background = isMain
        ? const Color(0xFF3B2600)
        : (index.isEven ? const Color(0xFF0B1727) : const Color(0xFF101B2B));

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: background,
        border: Border(
          bottom: BorderSide(
            color: isMain ? const Color(0xFFFACC15) : const Color(0xFF1F2937),
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              isMain ? 'الآن' : '${index + 1}'.padLeft(2, '0'),
              style: TextStyle(
                color: isMain ? const Color(0xFFFACC15) : const Color(0xFF94A3B8),
                fontSize: isMain ? 17 : 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(
            width: 116,
            child: Text(
              '${ticket.ticketsNumber}',
              style: TextStyle(
                color: isMain ? const Color(0xFFFACC15) : const Color(0xFF7DD3FC),
                fontSize: 30,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              _safe(ticket.representativeName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${_safe(ticket.representativeFingerPrint)}  |  ${_safe(ticket.branchName)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 142,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isMain ? const Color(0xFF14532D) : const Color(0xFF3B2600),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isMain ? const Color(0xFF22C55E) : const Color(0xFFB45309),
                  ),
                ),
                child: Text(
                  isMain ? 'التالي' : 'انتظار',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isMain ? const Color(0xFF86EFAC) : const Color(0xFFFBBF24),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreCustomersRow extends StatelessWidget {
  final int count;

  const _MoreCustomersRow({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      alignment: Alignment.center,
      color: const Color(0xFF111827),
      child: Text(
        '+$count عملاء آخرين في الانتظار',
        style: const TextStyle(
          color: Color(0xFFFACC15),
          fontSize: 21,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final String value;

  const _MiniTag({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF030712),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            _safe(value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterRefreshBar extends StatelessWidget {
  final int secondsLeft;

  const _FooterRefreshBar({required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFACC15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync, color: Color(0xFF111827)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${secondsLeft}s',
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoMainCustomer extends StatelessWidget {
  const _NoMainCustomer();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.people_outline, color: Color(0xFFFACC15), size: 86),
        SizedBox(height: 22),

        SizedBox(height: 12),
        Text(
          'سيظهر العميل التالي هنا بعد تحديث البيانات',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _NoUpcomingCustomers extends StatelessWidget {
  const _NoUpcomingCustomers();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'لا يوجد عملاء بعده حاليًا',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _NoWaitingData extends StatelessWidget {
  const _NoWaitingData();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'لا توجد تذاكر للعرض حاليًا',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BoardLoading extends StatelessWidget {
  const _BoardLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFFFACC15)),
          SizedBox(height: 16),
          Text(
            'جاري تحميل شاشة العملاء...',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _BoardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _BoardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1727),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF26364F)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Color(0xFFEF4444)),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

String _safe(String value) => value.trim().isEmpty ? '-' : value.trim();
