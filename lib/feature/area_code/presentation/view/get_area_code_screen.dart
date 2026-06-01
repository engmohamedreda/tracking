import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../cubit/get_area_code_cubit.dart';
import '../../cubit/get_area_code_state.dart';
import '../../model/area_code_entity.dart';

class GetAreaCodeScreen extends StatelessWidget {
  const GetAreaCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetAreaCodeCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أكواد المناطق'),
        ),
        body: BlocBuilder<GetAreaCodeCubit, GetAreaCodeState>(
          builder: (context, state) {
            if (state is GetAreaCodeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetAreaCodeError) {
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
                        onPressed: () =>
                            context.read<GetAreaCodeCubit>().load(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is GetAreaCodeSuccess) {
              final areaCodes = state.response.areaCodes;

              if (areaCodes.isEmpty) {
                return const Center(
                  child: Text('لا توجد أكواد مناطق'),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<GetAreaCodeCubit>().refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: areaCodes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _AreaCodeCard(areaCode: areaCodes[index]);
                  },
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

class _AreaCodeCard extends StatelessWidget {
  final AreaCodeEntity areaCode;

  const _AreaCodeCard({
    required this.areaCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(areaCode.id.toString()),
        ),
        title: Text(
          areaCode.code,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('الرقم: ${areaCode.id}'),
      ),
    );
  }
}
