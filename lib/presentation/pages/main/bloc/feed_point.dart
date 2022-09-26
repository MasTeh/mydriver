import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydriver/presentation/pages/main/paint/feedpoint/feed_getter.dart';

abstract class FeedPointEvent {}

class MapMoveStart extends FeedPointEvent {}

class MapMoveStopped extends FeedPointEvent {}

abstract class FeedPointState {
  Widget get feedWidget;
}

class FeedPointMapMoving extends FeedPointState {
  @override
  Widget get feedWidget => FeedPointGetter.stateChoosing;
}

class FeedPointMapStopped extends FeedPointState {
  @override
  Widget get feedWidget => FeedPointGetter.stateStaged;
}

class FeedPointBloc extends Bloc<FeedPointEvent, FeedPointState> {
  FeedPointBloc() : super(FeedPointMapStopped()) {
    on<MapMoveStart>((event, emit) {
      emit(FeedPointMapMoving());
    });
    on<MapMoveStopped>((event, emit) {
      emit(FeedPointMapStopped());
    });
  }
}
