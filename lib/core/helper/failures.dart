abstract class Failures {
  final String errorMsg;
  Failures({required this.errorMsg});
}

class ServerError extends Failures {
  ServerError({required super.errorMsg});
}

class NEtworkerror extends Failures {
  NEtworkerror({required super.errorMsg});
}
