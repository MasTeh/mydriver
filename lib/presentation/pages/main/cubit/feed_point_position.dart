import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPointPosition {
  final double verticalDimension;

  FeedPointPosition({required this.verticalDimension});
}

class FeedPointCubit extends Cubit<FeedPointPosition> {
  FeedPointCubit() : super(FeedPointPosition(verticalDimension: 0));

  void setValue(double value) {
    emit(FeedPointPosition(verticalDimension: value));
  }
}
