import 'package:agenda_esp_on/apis/agenda_api.dart';
import 'package:agenda_esp_on/components/alert.dart';
import 'package:agenda_esp_on/components/navigation_drawer_medico.dart';
import 'package:agenda_esp_on/models/agendamentos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPageMedico extends StatefulWidget {
  const MenuPageMedico({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MenuPageMedicoState createState() => _MenuPageMedicoState();
}

class _MenuPageMedicoState extends State<MenuPageMedico> {

  late Future<List<Agendamentos>> _agendamento;

  @override
  void initState() {
    super.initState();
    _agendamento = AgendaApi.getAgendaMedico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerMedico(),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,color: Colors.white,),
            onPressed: () {
              setState(() {
                _agendamento = AgendaApi.getAgendaMedico();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _agendamento,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //  print(snapshot.data);
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
      // drawer: DrawerList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          ///PROGRAMAR CADASTRO NAVIGATOR
        },
      ),
    );
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
                  _editarAgendamento(context, comp);
                },
                title: Text(_stringToString(comp.data) +
                    ' às ' +
                    comp.hora +' hs' +
                    '\nUsuário: ' +
                    comp.usuario+
                    '\nAtendimento: ' +
                    comp.motivo+
                    '\nEdição: ' +
                    comp.ultimaAlteracao+
                    '\nObs.: ' +
                    comp.observacao),
                subtitle: Text(comp.especial+' / '+comp.medico),
                leading: CircleAvatar(
                  child: Text(comp.usuario.substring(0, 1)),
                ),
                trailing: Icon(Icons.edit,color: Colors.amber),
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

  _editarAgendamento(context, comp) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Editar Agendamento?"),
          content: Text('De: ' +
              _stringToString(comp.data) +
              ' às ' +
              comp.hora +
              '\nCom: ' +
              comp.usuario +
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
                  //  print(comp.especial);
                  this.setState(() {
                    this._editarAgenda(comp.id);
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Deletar',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        )
    );
  }

  _editarAgenda(id) async {
    //  print(id);
    int response = await AgendaApi.editarAgenda(id);
    if (response == 204) {
      setState(() {
        alert(context, 'Ok. Solicitação atendida \nEditado o agendamento.');
        _agendamento = AgendaApi.getAgendaMedico();
      });
    }
  }


}
