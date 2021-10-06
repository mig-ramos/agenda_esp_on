///
/// Configuração da url API
///
class Setups {

  var _conexao = 'http://192.168.15.15:8080';
  // var url = Uri.parse('https://agenda-online-tcc.herokuapp.com');
  var _cabecalho = {
    "Content-Type": "application/json",
    "Accept-Charset": "utf-8"
  };

  get conexao => _conexao;
  set conexao(value) {
    _conexao = value;
  }

  get cabecalho => _cabecalho;
  set cabecalho(value) {
    _cabecalho = value;
  }

  @override
  String toString() {
    return 'Setups{conexao: $conexao, cabecalho: $cabecalho}';
  }
 }


