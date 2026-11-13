/// Usuari que ha iniciat sessió en l'aplicació.
///
/// En aquesta tasca només necessitem conservar el nom introduït al formulari.
class UserSession {
  const UserSession({required this.name});

  final String name;
}
