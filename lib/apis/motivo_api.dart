import 'dart:convert';
import 'package:agenda_esp_on/models/tipo_consulta.dart';
import 'package:http/http.dart' as http;
import 'package:agenda_esp_on/configurations/setup.dart';
import 'package:agenda_esp_on/utils/prefs.dart';

class MotivoApi{

  static Future<List<String>> dropMotivo() async {

    List<TipoConsulta> tipoConsulta = [];

    List<String> listaDrop = [];

    Future<String> _buscarToken() async {
      var setup = await Prefs.getString('user.prefs');
      Map<String, dynamic> mapResponse = json.decode(setup);
      return (mapResponse['token']);
    }
    var _token = await _buscarToken();

    var setup = Setups();

    var url = Uri.parse(setup.conexao+'/tipos_consultas');

    var header = {
      "Content-Type": "application/json",
      "Accept-Charset": "utf-8",
      "Authorization": _token
    };

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final mapResponse = jsonDecode(body).cast<Map<String, dynamic>>();
      //   print(mapResponse);
      // List<TipoConsulta> tipoConsulta = [];

      for (var item in mapResponse) {
        tipoConsulta.add(TipoConsulta(
            id: item['id'], tipoConsulta: item['tipoConsulta']));
        // print(item['nome']);
      }

      listaDrop = ['Buscar..'];
      for(int i = 0; i < tipoConsulta.length; i++){
        listaDrop.add(tipoConsulta[i].tipoConsulta);
      }
    }
    return listaDrop;
  }
}