import 'package:cars/models/route_from_to.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RouteFromToCubit extends Cubit<RouteFromTo> {
  RouteFromToCubit() : super(RouteFromTo(from: null, to: null));
  void setFrom(val) {
    state.from = val;
    emit(state);
  }

  void setTo(val) {
    state.to = val;
    emit(state);
  }

  void setComment(val) {
    state.comment = val;
    emit(state);
  }

  RouteFromTo get() => state.obs.value;
}
