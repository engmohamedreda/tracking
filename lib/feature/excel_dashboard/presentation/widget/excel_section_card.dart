import 'package:flutter/material.dart';

/// كارت القسم: زرار تحميل النموذج + زرار رفع الشيت،
/// وتحتيهم البيانات الفعلية المعروضة من الـ API.
class ExcelSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isTemplateLoading;
  final bool isImportLoading;
  final bool isDataLoading;
  final VoidCallback onDownloadTemplate;
  final VoidCallback onUploadSheet;
  final VoidCallback? onRefresh;
  final Widget child;

  const ExcelSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isTemplateLoading,
    required this.isImportLoading,
    required this.isDataLoading,
    required this.onDownloadTemplate,
    required this.onUploadSheet,
    required this.child,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // بنقفل الزرايين وقت أي عملية شغالة علشان المستخدم
    // مايبعتش نفس الملف مرتين بالغلط.
    final busy = isTemplateLoading || isImportLoading;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionHeader(
              title: title,
              subtitle: subtitle,
              icon: icon,
              isDataLoading: isDataLoading,
              onRefresh: onRefresh,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: busy ? null : onDownloadTemplate,
                  icon: isTemplateLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_outlined),
                  label: const Text('تحميل النموذج'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: busy ? null : onUploadSheet,
                  icon: isImportLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.upload_file_outlined),
                  label: const Text('رفع الشيت'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDataLoading;
  final VoidCallback? onRefresh;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDataLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF1D4ED8), size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (onRefresh != null)
          IconButton.filledTonal(
            tooltip: 'تحديث',
            onPressed: isDataLoading ? null : onRefresh,
            icon: const Icon(Icons.refresh, size: 20),
          ),
      ],
    );
  }
}

/// لودر بسيط بيستخدم جوه القسم وقت تحميل البيانات.
class ExcelSectionLoader extends StatelessWidget {
  const ExcelSectionLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 28),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

/// رسالة خطأ + إعادة محاولة جوه القسم.
class ExcelSectionError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ExcelSectionError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 28),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFB91C1C),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 44),
            ),
          ),
        ],
      ),
    );
  }
}
