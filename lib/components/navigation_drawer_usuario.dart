import 'package:agenda_esp_on/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawerUsuario extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final app = 'Ephemeris';
    final name = 'Agenda de Especialistas Online';
    final area = 'Paciente';
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
                  SizedBox(height: 30),
                  buildMenuItem(
                    text: 'Agendar consulta',
                    icon: Icons.calendar_today_outlined,
                    onCliked: () => selectedItem(context, 0),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Editar Perfil Usuário',
                    icon: Icons.account_circle_outlined,
                    onCliked: () => selectedItem(context, 1),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Editar Senha',
                    icon: Icons.vpn_key_outlined,
                    onCliked: () => selectedItem(context, 2),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.white70),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Ajuda',
                    icon: Icons.help,
                    onCliked: () => selectedItem(context, 3),
                  ),
                  SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.exit_to_app,
                    onCliked: () => selectedItem(context, 4),
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

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/cadAgendaPage');
        break;
      case 1:
        Navigator.of(context).pushNamed('/editaUsuarioPage');
        break;
      case 2:
        Navigator.of(context).pushNamed('/editarSenhaUsuarioPage');
        break;
      case 3:
      //  Navigator.of(context).pushNamed('/idAgenda');
      //     Navigator.of(context).push(MaterialPageRoute(builder: (contex) {
      //   return IdAgenda(title: 'AgendaEspOn', agenda: AgendaApi().getAgendaId());}),
        break;
      case 4:
        Prefs.setString('user.prefs', '');
        Prefs.setString('usuario.prefs', '');
        // Prefs.setString('email', '');
        // Prefs.setString('tokenjwt', '');
        Prefs.setString('perfil', '');
        Navigator.pop(context);
        break;
    }
  }

  // String _mail() {
  //   var mail = Prefs.getString('email') as String;
  //   return mail;
  // }

  // initState() {
  //   _mail();
  // }
}