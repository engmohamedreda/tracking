import 'dart:typed_data';

class SurveyAttachmentRequest {
  final String fileName;
  final Uint8List bytes;

  const SurveyAttachmentRequest({
    required this.fileName,
    required this.bytes,
  });
}
