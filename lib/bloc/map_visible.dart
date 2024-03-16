import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetState {
  final bool isMapVisible;

  WidgetState({required this.isMapVisible});
}

class WidgetCubit extends Cubit<WidgetState> {
  WidgetCubit() : super(WidgetState(isMapVisible: true));

  void toggleMapVisibility() {
    emit(WidgetState(isMapVisible: !state.isMapVisible));
  }
}
