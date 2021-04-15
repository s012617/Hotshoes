import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocateEvent extends Equatable {
  const LocateEvent([List props = const []]):super(props);
}
class BusinessLocated extends LocateEvent{
  @override
  String toString() => '客戶地以點選定';
}

