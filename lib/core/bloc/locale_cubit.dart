import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('pt'));

  void toggleLocale() {
    if (state.languageCode == 'pt') {
      emit(const Locale('en'));
    } else if (state.languageCode == 'en') {
      emit(const Locale('es'));
    } else {
      emit(const Locale('pt'));
    }
  }

  void setLocale(Locale locale) {
    emit(locale);
  }
}
