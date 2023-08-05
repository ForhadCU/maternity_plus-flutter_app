import 'package:logger/logger.dart';

Logger logger = Logger();

abstract class MyPrint {
  mPrint({required String message});
}

class Debuging extends MyPrint {
  @override
  mPrint({required String message}) {
    logger.d(message);
    throw UnimplementedError();
  }
}

class Warning implements MyPrint {
  @override
  mPrint({required String message}) {
    logger.w(message);
    throw UnimplementedError();
  }
}

class Error implements MyPrint {
  @override
  mPrint({required String message}) {
    logger.e(message);
    throw UnimplementedError();
  }
}

class Info implements MyPrint {
  @override
  mPrint({required String message}) {
    logger.i(message);
    throw UnimplementedError();
  }
}
