import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthys_app/domain/entities/user_session.dart';

/// View model de la sessió d'usuari implementat amb Riverpod.
class UserSessionNotifier extends Notifier<UserSession?> {
  @override
  UserSession? build() {
    return null;
  }

  void iniciaSessio(String name) {
    // TO-DO 2: Guarda en state una nova sessió amb el nom rebut.
  }

  void tancaSessio() {
    // TO-DO 2: Indica en state que ja no hi ha cap sessió activa.
  }
}

final userSessionProvider = NotifierProvider<UserSessionNotifier, UserSession?>(
  UserSessionNotifier.new,
);
