import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helper/di/di.dart';
import '../../cubit/create_survey_cubit.dart';
import '../../cubit/create_survey_state.dart';
import '../../model/survey_answer_request.dart';
import '../../model/survey_attachment_request.dart';
import 'web_camera_dialog_stub.dart'
    if (dart.library.html) 'web_camera_dialog_web.dart'
    as web_camera;
class CreateSurveyQuestionInput {
  final int id;
  final String title;
  const CreateSurveyQuestionInput({required this.id, required this.title});
}

/// المصدر الوحيد لقائمة الملاحظات.
/// مستخدمة في شاشة تجهيز الاستبيان وشاشة حفظ الاستبيان،
/// والقيم من غير مسافات زائدة عشان الـ trim ما يكسرش اختيار الـ Dropdown.
const List<String> surveyNoteOptions = [
  'لا يوجد',
  'كسر في الاسكرين',
  'بدون سكرين',
  'بطاريه منتفخه',
  'سوكت الشاحن لا يعمل',
];
class CreateSurveyScreen extends StatefulWidget {
  final int companyId;
  final int brandId;
  final int mobileId;
  final int representativeId;
  final int areaId;
  final int ticketId;
  final int surveyId;
  final List<CreateSurveyQuestionInput> questions;
  final String userId;
  final String status;
  final String initialNote;
  final List<SurveyAttachmentRequest> attachments;
  const CreateSurveyScreen({
    super.key,
    required this.companyId,
    required this.brandId,
    required this.mobileId,
    required this.representativeId,
    required this.areaId,
    required this.ticketId,
    this.surveyId = 0,
    required this.questions,
    this.userId = '',
    this.status = '',
    this.initialNote = '',
    this.attachments = const [],
  });
  @override
  State<CreateSurveyScreen> createState() => _CreateSurveyScreenState();
}
class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  final TextEditingController noteController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  final Map<int, bool> answers = {};
  late final List<SurveyAttachmentRequest> selectedAttachments;
  static const String fixedDateText = '2026-05-23T06:36:23.928Z';
  static const List<String> noteOptions = surveyNoteOptions;

  /// أرقام الأسئلة (زي ما بتظهر على الشاشة) اللي إجابتها الافتراضية "نعم".
  static const Set<int> defaultYesQuestionNumbers = {2, 3};
  @override
  void initState() {
    super.initState();
    noteController.text = widget.initialNote;
    selectedAttachments = List<SurveyAttachmentRequest>.from(
      widget.attachments,
    );
    for (var index = 0; index < widget.questions.length; index++) {
      final questionNumber = index + 1;
      answers[widget.questions[index].id] = defaultYesQuestionNumbers.contains(
        questionNumber,
      );
    }
  }
  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
  int get yesCount => answers.values.where((value) => value).length;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateSurveyCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FB),
        appBar: AppBar(
          title: const Text('الاستبيان'),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 18),
              child: Center(
                child: Chip(
                  avatar: const Icon(
                    Icons.confirmation_number_outlined,
                    size: 18,
                  ),
                  label: Text('تذكرة ${widget.ticketId}'),
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<CreateSurveyCubit, CreateSurveyState>(
          listener: (context, state) {
            if (state is CreateSurveySuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.response.message)));
              Navigator.pop(context, true);
            }

            if (state is CreateSurveyError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.failure.errorMsg)));
            }
          },
          builder: (context, state) {
            final isLoading = state is CreateSurveyLoading;
            final loadingMessage = state is CreateSurveyLoading
                ? state.message
                : 'جاري حفظ الاستبيان...';

            return Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1240),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
                            children: [
                              _SurveyHeader(
                                status: widget.status,
                                ticketId: widget.ticketId,
                                questionsCount: widget.questions.length,
                                yesCount: yesCount,
                                attachmentsCount: selectedAttachments.length,
                              ),
                              const SizedBox(height: 18),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth >= 960;
                                  final sideColumn = Column(
                                    children: [
                                      _SurveyDataCard(
                                        companyId: widget.companyId,
                                        brandId: widget.brandId,
                                        mobileId: widget.mobileId,
                                        representativeId:
                                            widget.representativeId,
                                        areaId: widget.areaId,
                                        ticketId: widget.ticketId,
                                        status: widget.status,
                                        fixedDateText: fixedDateText,
                                      ),
                                      const SizedBox(height: 16),
                                      _NoteCard(
                                        controller: noteController,
                                        isLoading: isLoading,
                                      ),
                                      const SizedBox(height: 16),
                                      _AttachmentsCard(
                                        attachments: selectedAttachments,
                                        isLoading: isLoading,
                                        onPickGallery: _pickImagesFromGallery,
                                        onPickCamera: _pickImageFromCamera,
                                        onRemove: _removeAttachment,
                                      ),
                                    ],
                                  );

                                  final questionsColumn = _QuestionsCard(
                                    questions: widget.questions,
                                    answers: answers,
                                    isLoading: isLoading,
                                    onChanged: (questionId, value) {
                                      setState(() {
                                        answers[questionId] = value;
                                      });
                                    },
                                  );

                                  if (!isWide) {
                                    return Column(
                                      children: [
                                        sideColumn,
                                        const SizedBox(height: 16),
                                        questionsColumn,
                                      ],
                                    );
                                  }

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 4, child: sideColumn),
                                      const SizedBox(width: 16),
                                      Expanded(flex: 7, child: questionsColumn),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        _SubmitBar(
                          isLoading: isLoading,
                          questionsCount: widget.questions.length,
                          yesCount: yesCount,
                          imagesCount: selectedAttachments.length,
                          onSubmit: () => _submit(context),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: const Color(0x660F172A),
                      child: Center(
                        child: _LoadingDialog(message: loadingMessage),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickImagesFromGallery() async {
    final images = await imagePicker.pickMultiImage(imageQuality: 80);
    if (images.isEmpty) return;

    final pickedAttachments = <SurveyAttachmentRequest>[];

    for (final image in images) {
      final bytes = await image.readAsBytes();
      pickedAttachments.add(
        SurveyAttachmentRequest(fileName: image.name, bytes: bytes),
      );
    }

    setState(() {
      selectedAttachments.addAll(pickedAttachments);
    });
  }

  Future<void> _pickImageFromCamera() async {
    if (kIsWeb) {
      final attachment = await web_camera.showWebCameraDialog(context);
      if (attachment == null || !mounted) return;

      setState(() {
        selectedAttachments.add(attachment);
      });
      return;
    }

    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image == null) return;

    final bytes = await image.readAsBytes();
    if (!mounted) return;

    setState(() {
      selectedAttachments.add(
        SurveyAttachmentRequest(fileName: image.name, bytes: bytes),
      );
    });
  }

  void _removeAttachment(SurveyAttachmentRequest attachment) {
    setState(() {
      selectedAttachments.remove(attachment);
    });
  }

  void _submit(BuildContext context) {
    if (widget.questions.isEmpty) {
      _showMessage('لابوجد أسئلة استبيان جاهزة');
      return;
    }

    final surveyAnswers = widget.questions.map((question) {
      return SurveyAnswerRequest(
        id: 0,
        title: question.title,
        answer: answers[question.id] ?? false,
        questionId: question.id,
      );
    }).toList();

    context.read<CreateSurveyCubit>().createSurveyFromFlowAndWaitForFingerprint(
      companyId: widget.companyId,
      brandId: widget.brandId,
      mobileId: widget.mobileId,
      userId: widget.userId,
      representativeId: widget.representativeId,
      areaId: widget.areaId,
      ticketId: widget.ticketId,
      surveyAnswers: surveyAnswers,
      note: noteController.text.trim(),
      status: widget.status,
      surveyAttachments: selectedAttachments,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SurveyHeader extends StatelessWidget {
  final String status;
  final int ticketId;
  final int questionsCount;
  final int yesCount;
  final int attachmentsCount;

  const _SurveyHeader({
    required this.status,
    required this.ticketId,
    required this.questionsCount,
    required this.yesCount,
    required this.attachmentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF0F766E)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0F172A),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyDataCard extends StatelessWidget {
  final int companyId;
  final int brandId;
  final int mobileId;
  final int representativeId;
  final int areaId;
  final int ticketId;
  final String status;
  final String fixedDateText;

  const _SurveyDataCard({
    required this.companyId,
    required this.brandId,
    required this.mobileId,
    required this.representativeId,
    required this.areaId,
    required this.ticketId,
    required this.status,
    required this.fixedDateText,
  });

  @override
  Widget build(BuildContext context) {
    return Card();
  }
}

class _NoteCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;

  const _NoteCard({required this.controller, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              icon: Icons.note_alt_outlined,
              title: 'ملاحظات',
              subtitle: 'اكتب أي ملاحظة خاصة بالاستبيان.',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value:
                  _CreateSurveyScreenState.noteOptions.contains(controller.text)
                  ? controller.text
                  : null,
              decoration: const InputDecoration(
                labelText: 'الملاحظة',
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
              hint: const Text('اختر الملاحظة'),
              items: _CreateSurveyScreenState.noteOptions.map((note) {
                return DropdownMenuItem<String>(value: note, child: Text(note));
              }).toList(),
              onChanged: isLoading
                  ? null
                  : (value) {
                      controller.text = value ?? '';
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentsCard extends StatelessWidget {
  final List<SurveyAttachmentRequest> attachments;
  final bool isLoading;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final ValueChanged<SurveyAttachmentRequest> onRemove;

  const _AttachmentsCard({
    required this.attachments,
    required this.isLoading,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              icon: Icons.photo_library_outlined,
              title: 'صور الاستبيان',
              subtitle: 'اختياري - يمكنك حفظ الاستبيان بدون صور',
              trailing: Chip(label: Text('${attachments.length}')),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : onPickGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('المعرض'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : onPickCamera,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('الكاميرا'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (attachments.isEmpty)
              const _EmptyImagesBox()
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: attachments.map((attachment) {
                  return _AttachmentPreview(
                    attachment: attachment,
                    isLoading: isLoading,
                    onRemove: () => onRemove(attachment),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuestionsCard extends StatelessWidget {
  final List<CreateSurveyQuestionInput> questions;
  final Map<int, bool> answers;
  final bool isLoading;
  final void Function(int questionId, bool value) onChanged;

  const _QuestionsCard({
    required this.questions,
    required this.answers,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              icon: Icons.quiz_outlined,
              title: 'أسئلة الاستبيان',
              subtitle: 'اختار نعم أو لا لكل سؤال.',
              trailing: Chip(label: Text('${questions.length} سؤال')),
            ),
            const SizedBox(height: 18),
            if (questions.isEmpty)
              const _EmptyQuestionsBox()
            else
              ...questions.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final question = entry.value;
                final value = answers[question.id] ?? false;

                return _QuestionTile(
                  index: index,
                  question: question,
                  value: value,
                  isLoading: isLoading,
                  onChanged: (newValue) => onChanged(question.id, newValue),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final int index;
  final CreateSurveyQuestionInput question;
  final bool value;
  final bool isLoading;
  final ValueChanged<bool> onChanged;

  const _QuestionTile({
    required this.index,
    required this.question,
    required this.value,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = value
        ? const Color(0xFF0F766E)
        : const Color(0xFFDC2626);
    final activeBg = value ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 620;
          final questionText = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: activeBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  index.toString(),
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    question.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.45,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ],
          );

          final buttons = SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: true,
                label: Text('نعم'),
                icon: Icon(Icons.check_circle_outline),
              ),
              ButtonSegment<bool>(
                value: false,
                label: Text('لا'),
                icon: Icon(Icons.cancel_outlined),
              ),
            ],
            selected: {value},
            showSelectedIcon: false,
            onSelectionChanged: isLoading
                ? null
                : (selection) {
                    onChanged(selection.first);
                  },
          );

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                questionText,
                const SizedBox(height: 14),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: buttons,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: questionText),
              const SizedBox(width: 18),
              buttons,
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class _DataPill extends StatelessWidget {
  final String label;
  final String value;

  const _DataPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        '$label: ${value.isEmpty ? '-' : value}',
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final String title;
  final String value;

  const _DateBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_outlined, color: Color(0xFF64748B)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
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

class _AttachmentPreview extends StatelessWidget {
  final SurveyAttachmentRequest attachment;
  final bool isLoading;
  final VoidCallback onRemove;

  const _AttachmentPreview({
    required this.attachment,
    required this.isLoading,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.memory(
                  attachment.bytes,
                  height: 104,
                  width: 154,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 104,
                      width: 154,
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(Icons.insert_drive_file_outlined),
                    );
                  },
                ),
              ),
              PositionedDirectional(
                top: 7,
                end: 7,
                child: InkWell(
                  onTap: isLoading ? null : onRemove,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              attachment.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyImagesBox extends StatelessWidget {
  const _EmptyImagesBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706)),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _EmptyQuestionsBox extends StatelessWidget {
  const _EmptyQuestionsBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Color(0xFFDC2626)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'مفيش أسئلة استبيان جاهزة. ارجع وجرب تحميل الأسئلة مرة تانية.',
              style: TextStyle(
                color: Color(0xFF991B1B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  final bool isLoading;
  final int questionsCount;
  final int yesCount;
  final int imagesCount;
  final VoidCallback onSubmit;

  const _SubmitBar({
    required this.isLoading,
    required this.questionsCount,
    required this.yesCount,
    required this.imagesCount,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final canSubmit = !isLoading && questionsCount > 0;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 720;
                final summary = Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _BottomPill(
                      label: 'الأسئلة',
                      value: questionsCount.toString(),
                    ),
                    _BottomPill(label: 'نعم', value: yesCount.toString()),
                    _BottomPill(label: 'الصور', value: imagesCount.toString()),
                  ],
                );

                final button = SizedBox(
                  width: isWide ? 320 : double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: canSubmit ? onSubmit : null,
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_upload_outlined),
                    label: const Text('حفظ الاستبيان'),
                  ),
                );

                if (!isWide) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [summary, const SizedBox(height: 12), button],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: summary),
                    const SizedBox(width: 18),
                    button,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomPill extends StatelessWidget {
  final String label;
  final String value;

  const _BottomPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final String message;

  const _LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 18),
            Text(message, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
