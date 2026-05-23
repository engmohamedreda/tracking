import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/di/di.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DeleteTicketsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Ticket'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
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
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: ticketIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ticket Id',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: state is DeleteTicketsLoading
                        ? null
                        : () {
                            final ticketId = int.tryParse(
                              ticketIdController.text.trim(),
                            );

                            if (ticketId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Enter valid ticket id'),
                                ),
                              );
                              return;
                            }

                            context.read<DeleteTicketsCubit>().deleteTicket(
                                  ticketId: ticketId,
                                );
                          },
                    child: state is DeleteTicketsLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Delete'),
                  ),
                  const SizedBox(height: 16),
                  if (state is DeleteTicketsSuccess)
                    Text(
                      'Deleted: ${state.response.isDeleted}',
                      textAlign: TextAlign.center,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
