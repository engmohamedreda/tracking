import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../../model/survey_attachment_request.dart';

Future<SurveyAttachmentRequest?> showWebCameraDialog(BuildContext context) {
  return showDialog<SurveyAttachmentRequest>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _WebCameraDialog(),
  );
}

class _WebCameraDialog extends StatefulWidget {
  const _WebCameraDialog();

  @override
  State<_WebCameraDialog> createState() => _WebCameraDialogState();
}

class _WebCameraDialogState extends State<_WebCameraDialog> {
  late final html.VideoElement _video;
  late final String _viewType;
  html.MediaStream? _stream;
  List<html.MediaDeviceInfo> _devices = const [];
  String? _selectedDeviceId;
  bool _loading = true;
  bool _capturing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _viewType = 'survey-camera-${DateTime.now().microsecondsSinceEpoch}';
    _video = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..setAttribute('playsinline', 'true')
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.backgroundColor = '#020617';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (_) => _video);
    _openCamera();
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
  }

  Future<void> _openCamera({String? deviceId}) async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      if (html.window.isSecureContext != true &&
          html.window.location.hostname != 'localhost') {
        throw StateError('INSECURE_CAMERA_CONTEXT');
      }
      _stopStream();
      final constraints = <String, dynamic>{
        'audio': false,
        'video': <String, dynamic>{
          if (deviceId != null && deviceId.isNotEmpty)
            'deviceId': <String, dynamic>{'exact': deviceId},
          'width': <String, dynamic>{'ideal': 1280},
          'height': <String, dynamic>{'ideal': 720},
        },
      };
      final mediaDevices = html.window.navigator.mediaDevices;
      if (mediaDevices == null)
        throw StateError('الكاميرا غير مدعومة في هذا المتصفح');
      final stream = await mediaDevices.getUserMedia(constraints);
      _stream = stream;
      _video.srcObject = stream;
      await _video.play();

      final devices = await mediaDevices.enumerateDevices();
      _devices = devices
          .whereType<html.MediaDeviceInfo>()
          .where((device) => device.kind == 'videoinput')
          .toList(growable: false);
      _selectedDeviceId ??= _devices.isEmpty ? null : _devices.first.deviceId;
    } catch (error) {
      _error = error is StateError && error.message == 'INSECURE_CAMERA_CONTEXT'
          ? 'المتصفح يمنع الكاميرا على HTTP لهذا الدومين. استخدم HTTPS، أو افتح الموقع عبر localhost للتجربة.'
          : 'تعذر فتح الكاميرا. اسمح بالكاميرا للموقع من Chrome، وتأكد أن الكاميرا ليست مستخدمة في تطبيق آخر.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _stopStream() {
    for (final track
        in _stream?.getTracks() ?? const <html.MediaStreamTrack>[]) {
      track.stop();
    }
    _stream = null;
    _video.srcObject = null;
  }

  Future<void> _changeCamera(String? deviceId) async {
    if (deviceId == null || deviceId == _selectedDeviceId) return;
    setState(() => _selectedDeviceId = deviceId);
    await _openCamera(deviceId: deviceId);
  }

  Future<void> _capture() async {
    if (_capturing) return;
    setState(() => _capturing = true);
    try {
      final width = _video.videoWidth;
      final height = _video.videoHeight;
      if (width <= 0 || height <= 0) throw StateError('preview is not ready');
      final canvas = html.CanvasElement(width: width, height: height);
      canvas.context2D.drawImageScaled(_video, 0, 0, width, height);
      final data = canvas.toDataUrl('image/jpeg', 0.85);
      final bytes = base64Decode(data.substring(data.indexOf(',') + 1));
      if (!mounted) return;
      Navigator.of(context).pop(
        SurveyAttachmentRequest(
          fileName:
              'survey_camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
          bytes: bytes,
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'تعذر التقاط الصورة. انتظر حتى تظهر المعاينة ثم حاول مرة أخرى.',
        );
      }
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.camera_alt_outlined),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'فتح الكاميرا',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: _capturing
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              if (_devices.length > 1) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedDeviceId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'الكاميرا'),
                  items: _devices
                      .map(
                        (device) => DropdownMenuItem(
                          value: device.deviceId,
                          child: Text(_cameraLabel(device)),
                        ),
                      )
                      .toList(),
                  onChanged: _loading || _capturing ? null : _changeCamera,
                ),
              ],
              const SizedBox(height: 14),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: HtmlElementView(viewType: _viewType),
                    ),
                    if (_loading)
                      const ColoredBox(
                        color: Color(0x990F172A),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(18),
                        color: const Color(0xEEDC2626),
                        child: Center(
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: _loading || _capturing ? null : _openCamera,
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _loading || _capturing || _error != null
                        ? null
                        : _capture,
                    icon: _capturing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.camera),
                    label: const Text('التقاط صورة'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _cameraLabel(html.MediaDeviceInfo device) {
    final label = device.label?.toString().trim() ?? '';
    return label.isEmpty ? 'كاميرا' : label;
  }
}
