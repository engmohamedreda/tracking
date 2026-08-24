# تشغيل كاميرا الويب

زر **Camera** يفتح معاينة الكاميرا ويمكن اختيار كاميرا USB والتقاط الصورة.

## مهم بخصوص HTTP

لا يستطيع كود Flutter تجاوز سياسة أمان المتصفح:

- `http://localhost` مسموح للكاميرا.
- `http://domain.com` أو `http://192.168.x.x` **لن يعمل** في Chrome؛ يجب استخدام HTTPS.
- للتجربة فقط، يمكن تشغيل Chrome بتمييز هذا الدومين كأصل آمن (لا تستخدم ذلك للمستخدمين الحقيقيين):

```bash
open -na "Google Chrome" --args \
  --user-data-dir="/tmp/trackingapp-chrome" \
  --unsafely-treat-insecure-origin-as-secure="http://YOUR_DOMAIN:PORT"
flutter run -d chrome --web-hostname 0.0.0.0 --web-port 8080
```

استبدل `YOUR_DOMAIN:PORT` بعنوان الموقع الفعلي، ثم افتح نفس العنوان في نافذة Chrome التي شُغّلت بالأمر.

## متطلبات أخرى

- يجب أن يوافق المستخدم على صلاحية الكاميرا.
- إذا لم تظهر الكاميرا الخارجية، تأكد أنها متصلة وليست مستخدمة في Zoom أو Meet أو تطبيق Camera.
- الكود الخاص بالمعاينة Web فقط، ولا توجد dependency جديدة؛ Gallery ما زال يستخدم `image_picker`.
