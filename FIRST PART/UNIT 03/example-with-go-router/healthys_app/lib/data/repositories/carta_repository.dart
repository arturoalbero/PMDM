// Defineix el repositori d'accés a les dades
// Aquesta capa és la que s'usa des de l'aplicació, per abstraure
// l'accés a les dades.

import 'package:healthys_app/data/services/healthys_api.dart';
import 'package:healthys_app/domain/entities/beguda.dart';
import 'package:healthys_app/domain/entities/entrant.dart';
import 'package:healthys_app/domain/entities/principal.dart';

class CartaRepository {
  late final String urlBase;

  // Amb late indiquem que aquest valor
  // s'inicialitza posteriorment (al constructor)
  late HealthysApi api;

  CartaRepository(this.urlBase) {
    api = HealthysApi(urlBase);
  }

  Future<List<Entrant>> getEntrants() async {
    // Opció 1: Recorregut clàssic de llistes i creció d'elements
    /*
    // Definim una llista d'entrants en format JSON (com els torna l'API)
    List<dynamic> entrantsJSON;
    entrantsJSON = await api.getEntrants();

    // Definim una llista d'objectes de tipus Entrant (com necessita l'aplicació)
    List<Entrant> llista_entrants = [];
    // Recorrem la llista JSON i generem Entrants per a cada element d'aquesta
    // en la llista d'entrants (fem ús del mètode fromJSON per a això)
    for (Map<String, dynamic> entrantJSON in entrantsJSON) {
      llista_entrants.add(Entrant.fromJson(entrantJSON, urlBase));
    }

    return llista_entrants;
*/

    // Opció 2. Fer ús del mapat d'estructures
    // La funció .map ens retorna un Iterable, pel que
    // l'hem de convertir a llista amb el toList().
    return (await api.getEntrants()).map((entrant) {
      return Entrant.fromJson(entrant, urlBase);
    }).toList();
  }

  // TO-DO:
  // Implementar el mètode getPrincipals() per obternir tots els plats principals
  Future<List<Principal>> getPrincipals() async {
    return (await api.getPrincipals()).map((principal) {
      return Principal.fromJson(principal, urlBase);
    }).toList();
  }

  // TO-DO:
  // Implementar el mètode getBegudes() per obternir totes les begudes
  Future<List<Beguda>> getBegudes() async {
    return (await api.getBegudes()).map((beguda) {
      return Beguda.fromJson(beguda, urlBase);
    }).toList();
  }

  // Mètode getEntrantsByTipus(String tipus). Obté els entratnts d'un tipus determinat
  Future<List<Entrant>> getEntrantsByTipus(String tipus) async {
    return (await api.getEntrantsByType(tipus)).map((entrant) {
      return Entrant.fromJson(entrant, urlBase);
    }).toList();
  }

  // TO-DO:
  // Implementar el mètode getPrincipalsByTipus()(String tipus)
  // per obternir els principals de determinat tipus
  Future<List<Principal>> getPrincipalsByTipus(String tipus) async {
    return (await api.getPrincipalsByType(tipus)).map((principal) {
      return Principal.fromJson(principal, urlBase);
    }).toList();
  }

  // TO-DO:
  // Implementar el mètode getBegudesByTipus()(String tipus)
  // per obternir les begudes de determinat tipus
  Future<List<Beguda>> getBegudesByTipus(String tipus) async {
    return (await api.getBegudesByType(tipus)).map((beguda) {
      return Beguda.fromJson(beguda, urlBase);
    }).toList();
  }
}
