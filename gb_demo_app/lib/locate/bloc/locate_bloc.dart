import 'dart:async';

import 'package:bloc/bloc.dart';

import 'bloc.dart';

class LocateBloc extends Bloc<LocateEvent, LocateState> {
  @override
  LocateState get initialState => LocateInitial();

  @override
  Stream<LocateState> mapEventToState(
    LocateEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
