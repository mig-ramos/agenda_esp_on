import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_dialog_box.dart';

class NavigationDrawerAdmin extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final app = 'Ephemeris';
    final name = 'Agenda de Especialistas Online';
    final area = 'Administrador';
    final urlImage = 'assets/images/logo_login.png';

    return Drawer(
      child: Material(
        //   color: Colors.green,
        color: Color.fromRGBO(0, 75, 0, .6),
        child: ListView(
          children: <Widget>[
            buildHeader(
                urlImage: urlImage,
                app: app,
                name: name,
                area: area,
                onClicked: () => {}),
            Container(
              padding: padding,
              child: Column(
                children: [
                  SizedBox(height: 18),
                  buildMenuItem(
                    text: 'Especialidades',
                    icon: Icons.assignment_ind_outlined,
                    onCliked: () => selectedItem(context, 0),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Cadastrar Usuário',
                    icon: Icons.people,
                    onCliked: () => selectedItem(context, 1),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Cadastrar Médico',
                    icon: Icons.people,
                    onCliked: () => selectedItem(context, 2),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Listar Usuários',
                    icon: Icons.assignment,
                    onCliked: () => selectedItem(context, 3),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Editar Senha',
                    icon: Icons.vpn_key_outlined,
                    onCliked: () => selectedItem(context, 4),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.white70),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Ajuda',
                    icon: Icons.help,
                    onCliked: () => selectedItem(context, 5),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.exit_to_app,
                    onCliked: () => selectedItem(context, 6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String app,
    required String name,
    required String area,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              // CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    area,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              // Spacer(),
              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              //   child: Icon(Icons.add_comment_outlined, color: Colors.white),
              // )
            ],
          ),
        ),
      );

  buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onCliked,
  }) {
    final color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onCliked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        //     Navigator.of(context).pushNamed('/cadAgendaPage');
        break;
      case 1:
         Navigator.of(context).pushNamed('/cadUsuAdminPage');
        break;
      case 2:
        Navigator.of(context).pushNamed('/cadMediAdminPage');
        break;
      case 3:
        Navigator.of(context).pushNamed('/listaUsuPage');
        break;
      case 4:
        Navigator.of(context).pushNamed('/editarSenhaUsuarioPage');
        break;
      case 5:
        showDialog(context: context,
            builder: (BuildContext context){
              return CustomDialogBox(
                  title: "Administração",
                  descriptions: "Para acrescentar uma especialidade, \nbasta clicar no botão (+).\n\nPara excluir especialidade\ndesde que não seja utilizada,\nbasta manter clicado\no Cartão da especialidade..",
                  text: "Ok"
              );
            }
        );
        break;
      case 6:
        Prefs.setString('user.prefs', '');
        Prefs.setString('usuario.prefs', '');
        Prefs.setString('perfil', '');
        Navigator.pop(context);
        break;
    }
  }
}
