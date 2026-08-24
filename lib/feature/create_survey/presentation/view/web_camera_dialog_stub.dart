import 'package:flutter/material.dart';

import '../../model/survey_attachment_request.dart';

/// Non-web fallback. The calling screen uses image_picker on these platforms.
Future<SurveyAttachmentRequest?> showWebCameraDialog(
  BuildContext context,
) async {
  return null;
}
