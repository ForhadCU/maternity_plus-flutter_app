import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

void main() async {
  Bloc.observer = MyBlocObserver();

  final myCubit = MyCubit(5);
  final myCubit1 = MyCubit1();

  // c: listener for myCubit
  final subscriptionMyCubit = myCubit.stream.listen((event) {
    if (kDebugMode) {
      print(event);
    }
  });
  // c: listener for myCubit1
  final subscriptionMyCubit1 = myCubit1.stream.listen((event) {
    print(event);
  });

  final myCubit2 = MyCubit2();

  myCubit2.autoUpdateSate();
  print(myCubit2.state.num);
  print(myCubit2.state.name);
  myCubit2.manuallyUpdateState(1);
  print(myCubit2.state.num);
  print(myCubit2.state.name);

  /*  myCubit.negOrPos(4);
  print(myCubit.state);
  myCubit1.addTwoNum(firstNum: 2, secondNum: 2);
  // print("${myCubit.negOrPos(-1)}");
  myCubit.negOrPos(5);
  print(myCubit.state); */

  await Future.delayed(Duration.zero);
  await subscriptionMyCubit.cancel();
  await myCubit.close();
  await subscriptionMyCubit1.cancel();
  await myCubit1.close();
  await myCubit2.close();
}

class MyCubit extends Cubit<String> {
  MyCubit(int initialState) : super("initialState");

  String? negOrPos(int num) {
    if (num >= 0) {
      emit('Positive Number');
    } else {
      emit('Negative Number');
    }
    return null;
  }
}

class MyCubit1 extends Cubit<int> {
  MyCubit1() : super(0);

  void addTwoNum({required int firstNum, required int secondNum}) {
    var total = firstNum + secondNum;
    emit(total);
  }
}

class MyCubit2 extends Cubit<MyStateClass> {
  // MyCubit2(MyStateClass initialState) : super(initialState);
  MyCubit2() : super(MyStateClass(num: 0, name: 'zero'));

  void autoUpdateSate() {
    emit(MyStateClass(num: state.num + 2, name: 'Incremented'));
  }

  void manuallyUpdateState(int num) {
    if (num > state.num) {
      emit(MyStateClass(
          num: state.num, name: 'Incremented to ${state.num + num}'));
    } else if (num < state.num) {
      emit(MyStateClass(
          num: state.num, name: 'Decremented to ${state.num - num}'));
    } else {
      emit(MyStateClass(num: state.num, name: "Not change"));
    }
  }
}

class MyStateClass {
  int num;
  String name;

  MyStateClass({required this.num, required this.name});
}

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print("${bloc.runtimeType} $change");
  }
}
