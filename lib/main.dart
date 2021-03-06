import 'package:agenda_esp_on/usuario/editar_usuario_page.dart';
import 'package:agenda_esp_on/usuario/editar_senha_usu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'admin/cad_espe_admin_page.dart';
import 'admin/cad_medi_admin_page.dart';
import 'admin/cad_usu_admin_page.dart';
import 'admin/lista_usuario_page.dart';
import 'agenda/cad_agenda_page.dart';
import 'home/home_page.dart';
import 'login/cad_user_page.dart';
import 'login/login_page.dart';
import 'medico/edita_agenda_usu_page.dart';
import 'medico/editar_medico_page.dart';
import 'menu_principal/menu_page_admin.dart';
import 'menu_principal/menu_page_medico.dart';
import 'menu_principal/menu_page_usuario.dart';
import 'usuario/editar_usuario_page.dart';
import 'usuario/editar_senha_usu_page.dart';

void main() {
  runApp(AgendaEspOn());
}

class AgendaEspOn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgendaEspOn',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'Ephemeris'),
        '/loginPage': (context) => LoginPage(title: 'Fazer Login'),
        '/cadUserPage': (context) => CadUserPage(title: 'Cadastrar Usuário'),
        '/menuPageUsuario': (context) => MenuPageUsuario(title: 'Ephemeris'),
        '/menuPageMedico': (context) =>
            MenuPageMedico(title: 'Agendamento de Pacientes'),
        '/menuPageAdmin': (context) =>
            MenuPageAdmin(title: 'Lista de Especialidades'),
        '/listaUsuPage': (context) => ListaUsuPage(title: 'Lista de Usuários'),
        '/cadUsuAdminPage': (context) =>
            CadUsuAdminPage(title: 'Cadastro de Paciente'),
        '/cadEspeAdminPage': (context) =>
            CadEspeAdminPage(title: 'Cadastro de Especialidade'),
        '/cadMediAdminPage': (context) =>
            CadMediAdminPage(title: 'Cadastro de Médico'),
        '/editaUsuarioPage': (context) =>
            EditarUsuarioPage(title: 'Edita Perfil Usuário'),
        '/editaMedicoPage': (context) =>
            EditarMedicoPage(title: 'Dados Cadastrais Médico'),
        '/editaAgendaUsuPage': (context) => EditaAgendaUsuPage(
              title: 'Editar Ficha Paciente'),
        '/cadAgendaPage': (context) => CadAgendaPage(title: 'Agendar Consulta'),
        '/editarSenhaUsuarioPage': (context) => EditarSenhaUsuario(title: 'Editar Senha'),
      },
    );
  }
}
