import 'package:flutter/material.dart';

/// شريط التنقل بين الصفحات للـ endpoints اللي بترجع pagination.
class ExcelPaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasPrevious;
  final bool hasNext;
  final bool isLoading;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ExcelPaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasPrevious,
    required this.hasNext,
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'صفحة $currentPage من $totalPages • الإجمالي $totalCount',
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: (!hasPrevious || isLoading) ? null : onPrevious,
            icon: const Icon(Icons.chevron_right, size: 20),
            label: const Text('السابق'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: (!hasNext || isLoading) ? null : onNext,
            icon: const Icon(Icons.chevron_left, size: 20),
            label: const Text('التالي'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
