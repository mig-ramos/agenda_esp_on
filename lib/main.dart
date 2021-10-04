import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home/home_page.dart';

void main() {
  runApp(AgendaEspOn());
}

class AgendaEspOn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgendaEspOn',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'Ephemeris'),
        // '/loginPage': (context) => LoginPage(title: 'Fazer Login'),
        // '/menuPageUsuario': (context) => MenuPageUsuario(title: 'Ephemeris'),
        // '/menuPageMedico': (context) => MenuPageMedico(title: 'Ephemeris'),
        // '/menuPageAdmin': (context) => MenuPageAdmin(title: 'Ephemeris'),
        // '/cadUsuarioPage': (context) =>
        //     CadUsuarioPage(title: 'Cadastrar Usuário'),
        // '/editaUsuarioPage': (context) =>
        //     EditarUsuarioPage(title: 'Editar Perfil Usuário'),
        // '/cadAgendaPage': (context) => CadAgendaPage(title: 'Agendar Consulta'),
        // '/editarSenhaUsuarioPage': (context) =>
        //     EditarSenhaUsuario(title: 'Editar Senha'),
        //  '/idAgenda':(context) => IdAgenda(title: 'Editar Senha', agenda: getAgendaId())
      },
    );
  }
}