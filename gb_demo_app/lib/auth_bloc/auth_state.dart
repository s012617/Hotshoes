import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
@immutable
abstract class LocateState extends Equatable {
  const LocateState([List props = const []]):super(props);
}

class Uninitialized extends LocateState {
  @override
  String toString() {
    return 'Uninitialized';
  }
}
class UnchoosedLocate extends LocateState{
  @override
  String toString(){
    return '未選擇客戶地址';
  }
}
class ChoosedLocate extends LocateState{
  final String BusinessLocate;
  ChoosedLocate(this.BusinessLocate) : super([BusinessLocate]);
  @override
  String toString(){
    return '選擇{客戶地址: $BusinessLocate}';
  }
}
