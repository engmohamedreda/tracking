import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../../area_code/cubit/get_area_code_cubit.dart';
import '../../../area_code/cubit/get_area_code_state.dart';
import '../../../area_code/model/area_code_entity.dart';
import '../../cubit/get_mobile_serials_cubit.dart';
import '../../cubit/get_mobile_serials_state.dart';
import '../../model/mobile_serial_entity.dart';

class AreaCodeMobileSerialsScreen extends StatelessWidget {
  const AreaCodeMobileSerialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetAreaCodeCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => getIt<GetMobileSerialsCubit>(),
        ),
      ],
      child: const _AreaCodeMobileSerialsView(),
    );
  }
}

class _AreaCodeMobileSerialsView extends StatefulWidget {
  const _AreaCodeMobileSerialsView();

  @override
  State<_AreaCodeMobileSerialsView> createState() =>
      _AreaCodeMobileSerialsViewState();
}

class _AreaCodeMobileSerialsViewState
    extends State<_AreaCodeMobileSerialsView> {
  AreaCodeEntity? selectedAreaCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Code Serial'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<GetAreaCodeCubit, GetAreaCodeState>(
            builder: (context, state) {
              if (state is GetAreaCodeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetAreaCodeError) {
                return _ErrorBox(
                  message: state.failure.errorMsg,
                  onRetry: () => context.read<GetAreaCodeCubit>().load(),
                );
              }

              if (state is GetAreaCodeSuccess) {
                final areaCodes = state.response.areaCodes;

                if (areaCodes.isEmpty) {
                  return const Text('No area codes found');
                }

                return DropdownButtonFormField<AreaCodeEntity>(
                  value: selectedAreaCode,
                  decoration: const InputDecoration(
                    labelText: 'Area Code',
                    border: OutlineInputBorder(),
                  ),
                  items: areaCodes.map((areaCode) {
                    return DropdownMenuItem<AreaCodeEntity>(
                      value: areaCode,
                      child: Text('${areaCode.code} - Id ${areaCode.id}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedAreaCode = value;
                    });

                    context.read<GetMobileSerialsCubit>().load(
                          areaCodeId: value.id,
                        );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<GetMobileSerialsCubit, GetMobileSerialsState>(
            builder: (context, state) {
              if (state is GetMobileSerialsInitial) {
                return const _InfoBox(
                  message: 'اختار Area Code عشان نجيب Mobile Serial',
                );
              }

              if (state is GetMobileSerialsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetMobileSerialsError) {
                return _ErrorBox(
                  message: state.failure.errorMsg,
                  onRetry: () =>
                      context.read<GetMobileSerialsCubit>().refresh(),
                );
              }

              if (state is GetMobileSerialsSuccess) {
                if (!state.response.hasData) {
                  return const _InfoBox(message: 'No serial found');
                }

                return _MobileSerialCard(
                  mobileSerial: state.response.mobileSerial,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _MobileSerialCard extends StatelessWidget {
  final MobileSerialEntity mobileSerial;

  const _MobileSerialCard({
    required this.mobileSerial,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Serial',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              mobileSerial.serial,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Id: ${mobileSerial.id}'),
            if (mobileSerial.areaCode.isNotEmpty)
              Text('Area Code: ${mobileSerial.areaCode}'),
          ],
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBox({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String message;

  const _InfoBox({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
