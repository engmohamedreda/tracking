import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/di/di.dart';
import '../../../no_show_tickets/cubit/no_show_ticket_cubit.dart';
import '../../../no_show_tickets/cubit/no_show_ticket_state.dart';
import '../../cubit/delete_tickets_cubit.dart';
import '../../cubit/delete_tickets_state.dart';

class DeleteTicketsScreen extends StatefulWidget {
  const DeleteTicketsScreen({super.key});

  @override
  State<DeleteTicketsScreen> createState() => _DeleteTicketsScreenState();
}

class _DeleteTicketsScreenState extends State<DeleteTicketsScreen> {
  final TextEditingController ticketIdController = TextEditingController();

  @override
  void dispose() {
    ticketIdController.dispose();
    super.dispose();
  }

  int? _getValidTicketId(BuildContext context) {
    final ticketId = int.tryParse(ticketIdController.text.trim());

    if (ticketId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل رقم تذكرة صحيح'),
        ),
      );
      return null;
    }

    return ticketId;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<DeleteTicketsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<NoShowTicketCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إجراءات التذكرة'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<NoShowTicketCubit, NoShowTicketState>(
            listener: (context, state) {
              if (state is NoShowTicketSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.response.message),
                  ),
                );
              }

              if (state is NoShowTicketError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            child: BlocConsumer<DeleteTicketsCubit, DeleteTicketsState>(
              listener: (context, state) {
                if (state is DeleteTicketsSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.response.message),
                    ),
                  );
                }

                if (state is DeleteTicketsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, deleteState) {
                return BlocBuilder<NoShowTicketCubit, NoShowTicketState>(
                  builder: (context, noShowState) {
                    final isDeleteLoading = deleteState is DeleteTicketsLoading;
                    final isNoShowLoading = noShowState is NoShowTicketLoading;
                    final isBusy = isDeleteLoading || isNoShowLoading;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: ticketIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'رقم التذكرة',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isBusy
                                    ? null
                                    : () {
                                        final ticketId =
                                            _getValidTicketId(context);
                                        if (ticketId == null) return;

                                        context
                                            .read<DeleteTicketsCubit>()
                                            .deleteTicket(ticketId: ticketId);
                                      },
                                icon: isDeleteLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
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
                                onPressed: isBusy
                                    ? null
                                    : () {
                                        final ticketId =
                                            _getValidTicketId(context);
                                        if (ticketId == null) return;

                                        context
                                            .read<NoShowTicketCubit>()
                                            .markNoShow(ticketId: ticketId);
                                      },
                                icon: isNoShowLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.person_off_outlined),
                                label: const Text('لم يحضر'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (deleteState is DeleteTicketsSuccess)
                          Text(
                            'تم الحذف: ${deleteState.response.isDeleted}',
                            textAlign: TextAlign.center,
                          ),
                        if (noShowState is NoShowTicketSuccess)
                          Text(
                            'تم تسجيل عدم الحضور: ${noShowState.response.isSuccess}',
                            textAlign: TextAlign.center,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
