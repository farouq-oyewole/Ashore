import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeEvent>((event, emit) {
      if (state == ThemeMode.light) {
        emit(ThemeMode.dark);
      } else {
        emit(ThemeMode.light);
      }
    });
  }
}
