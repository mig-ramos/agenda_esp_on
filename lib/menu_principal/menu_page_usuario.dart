import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/components/navigation_drawer_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPageUsuario extends StatefulWidget {
  const MenuPageUsuario({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageUsuarioState createState() => _MenuPageUsuarioState();
}
class _MenuPageUsuarioState extends State<MenuPageUsuario> {

//  late Future<List<Compromisso>> _compromisso;

  @override
  initState() {
    super.initState();
 //   _compromisso = AgendaApi.getAgenda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [

            IconButton(
              icon: Icon(Icons.refresh,color: Colors.white,),
              onPressed: () {
                setState(() {
              //    _compromisso = AgendaApi.getAgenda();
                });
              },
            ),


          ],
        ),
        body: FutureBuilder(
         // future: _compromisso,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return ListView(
                children: _listCompromissos(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'O usuário não tem\n   Agendamento..',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        '\nPara agendar: \nbasta clicar no botão (+)',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\nPara Excluir agendamento: \nbasta manter clicado\no Cartão de Agendamento..',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      )
                    ]),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            ///PROGRAMAR CADASTRO NAVIGATOR
            Navigator.of(context).pushNamed('/cadAgendaPage');
          },
        ),
        drawer: NavigationDrawerUsuario());
  }

  // _deletarAgendamento(context, Teste teste){
  _deletarAgendamento(context, comp) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Deletar Agendamento?"),
          content: Text('De: ' +
              _stringToString(comp.data) +
              ' às ' +
              comp.hora +
              '\nCom: ' +
              comp.medico +
              '\nPara: ' +
              comp.motivo),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar')),
            TextButton(
                onPressed: () {
                  print(comp.especial);
                  this.setState(() {
                    this._deleteAgenda(comp.id);
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Deletar',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ));
  }

  List<Widget> _listCompromissos(data) {
    List<Widget> compromissos = [];
    for (var comp in data) {
      compromissos.add(Card(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onLongPress: () {
                  _deletarAgendamento(context, comp);
                },
                title: Text(_stringToString(comp.data) +
                    ' às ' +
                    comp.hora +
                    ' hs\nEspecialidade: ' +
                    comp.especial +
                    '\nMédico: ' +
                    comp.medico),
                subtitle: Text('Atendimento: ' + comp.motivo),
                leading: CircleAvatar(
                  child: Text(comp.medico.substring(0, 1)),
                ),
                trailing: Icon(Icons.delete,color: Colors.red,),
              )
            ],
          ),
        ),
      ));
    }
    return compromissos;
  }

  String _stringToString(String date) {
    String _dateString = "";
    _dateString = date.substring(8, 10) +
        '/' +
        date.substring(5, 7) +
        '/' +
        date.substring(0, 4);
    return _dateString;
  }

  _deleteAgenda(id) async {
    print(id);
    // int response = await AgendaApi.delAgenda(id);
    // if (response == 204) {
    //   setState(() {
    //     alert(context, 'Ok. Solicitação atendida \nDeletado o agendamento.');
    //     _compromisso = AgendaApi.getAgenda();
    //   });
    // }
  }
}