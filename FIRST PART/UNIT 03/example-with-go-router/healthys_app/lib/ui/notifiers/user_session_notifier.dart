import 'package:flutter/foundation.dart';
import 'package:healthys_app/domain/entities/user_session.dart';

/// Gestió inicial de la sessió amb una ferramenta nativa de Flutter.
///
/// El projecte base funciona amb aquest ValueNotifier. En el primer apartat
/// de la tasca el substituirem per un provider de Riverpod.
final userSessionNotifier = ValueNotifier<UserSession?>(null);
