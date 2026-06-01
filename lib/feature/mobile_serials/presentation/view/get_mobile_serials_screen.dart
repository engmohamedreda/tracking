import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../cubit/get_mobile_serials_cubit.dart';
import '../../cubit/get_mobile_serials_state.dart';
import '../../model/mobile_serial_entity.dart';

class GetMobileSerialsScreen extends StatelessWidget {
  final int areaCodeId;
  final String? areaCode;

  const GetMobileSerialsScreen({
    super.key,
    required this.areaCodeId,
    this.areaCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetMobileSerialsCubit>()
        ..load(
          areaCodeId: areaCodeId,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(areaCode == null ? 'سيريال الموبايل' : 'سيريال $areaCode'),
        ),
        body: BlocBuilder<GetMobileSerialsCubit, GetMobileSerialsState>(
          builder: (context, state) {
            if (state is GetMobileSerialsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetMobileSerialsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.failure.errorMsg,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context
                            .read<GetMobileSerialsCubit>()
                            .load(areaCodeId: areaCodeId),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is GetMobileSerialsSuccess) {
              if (!state.response.hasData) {
                return const Center(
                  child: Text('لا يوجد سيريال'),
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<GetMobileSerialsCubit>().refresh(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _MobileSerialCard(
                      mobileSerial: state.response.mobileSerial,
                    ),
                  ],
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
              mobileSerial.serial,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('الرقم: ${mobileSerial.id}'),
            if (mobileSerial.areaCode.isNotEmpty)
              Text('كود المنطقة: ${mobileSerial.areaCode}'),
          ],
        ),
      ),
    );
  }
}
