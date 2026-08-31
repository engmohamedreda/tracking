import 'package:flutter/material.dart';

/// صف موحّد لعرض أي بيانات في لوحة الإكسيل،
/// علشان الأقسام كلها تبان بنفس الشكل.
class ExcelDataRow {
  final int id;
  final String title;
  final List<ExcelDataChip> chips;

  const ExcelDataRow({
    required this.id,
    required this.title,
    this.chips = const [],
  });
}

class ExcelDataChip {
  final String label;
  final String value;

  const ExcelDataChip({
    required this.label,
    required this.value,
  });

  bool get hasValue => value.trim().isNotEmpty;
}

class ExcelDataList extends StatelessWidget {
  final List<ExcelDataRow> rows;
  final String emptyMessage;

  const ExcelDataList({
    super.key,
    required this.rows,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          if (index > 0) const SizedBox(height: 8),
          _ExcelDataTile(row: rows[index]),
        ],
      ],
    );
  }
}

class _ExcelDataTile extends StatelessWidget {
  final ExcelDataRow row;

  const _ExcelDataTile({required this.row});

  @override
  Widget build(BuildContext context) {
    final chips = row.chips.where((chip) => chip.hasValue).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              row.id.toString(),
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title.isEmpty ? '—' : row.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (chips.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final chip in chips)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            '${chip.label}: ${chip.value}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, color: Color(0xFF94A3B8), size: 30),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
