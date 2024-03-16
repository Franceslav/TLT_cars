import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<bool> {
  AuthCubit() : super(false);
  void set(val) => emit(val);
  bool isAuth() => state;
}
