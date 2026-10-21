import 'dart:convert'; // Per a utf8 i jsondecode
import 'dart:io'; // Per a HttpStatus
import 'package:http/http.dart'
    as http; // Importem la llibreria http l'àlias http

/*

 Classe de Servei per accedir a l'API REST

*/

class HealthysApi {
  String urlBase;

  // Constructor
  HealthysApi(this.urlBase);

  // Mètode per obtenir la llista de productes genèrics

  Future<List<dynamic>> getProduct(String url) async {
    // Retorna la llista de productes de forma genèrica, a partir de l'URL
    http.Response data = await http.get(Uri.parse(url));
    if (data.statusCode == HttpStatus.ok) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body);

      return bodyJSON as List; // Retornem només els registres com a llista
    } else {
      return [];
    }
  }

  // Mètode per obtenir els entrants
  Future<List<dynamic>> getEntrants() async {
    String url = "$urlBase/api/entrants";
    return await getProduct(url);
  }

  // Mètode per obtenir els entrants per tipus
  Future<List<dynamic>> getEntrantsByType(String tipus) async {
    String url = "$urlBase/api/entrants/$tipus";
    return await getProduct(url);
  }

  // Mètode per obtenir els plats principals
  Future<List<dynamic>> getPrincipals() async {
    String url = "$urlBase/api/principals";
    return await getProduct(url);
  }

  // Mètode per obtenir els plats principals per tipus
  Future<List<dynamic>> getPrincipalsByType(String tipus) async {
    String url = "$urlBase/api/principals/$tipus";
    return await getProduct(url);
  }

  // Mètode per obtenir les begudes
  Future<List<dynamic>> getBegudes() async {
    String url = "$urlBase/api/begudes";
    return await getProduct(url);
  }

  // Mètode per obtenir eles begudes per tipus
  Future<List<dynamic>> getBegudesByType(String tipus) async {
    String url = "$urlBase/api/begudes/$tipus";
    return await getProduct(url);
  }
}
