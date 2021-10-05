import 'package:agenda_esp_on/components/navigation_drawer_medico.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPageMedico extends StatefulWidget {
  const MenuPageMedico({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MenuPageMedicoState createState() => _MenuPageMedicoState();
}

class _MenuPageMedicoState extends State<MenuPageMedico> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerMedico(),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 160,
                height: 160,
                child: (Icon(
                  Icons.account_circle_outlined,
                  size: 150,
                  color: Colors.green,
                )),
              ),
            ),
            Container(
              height: 90,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.lime,
              child: Text(
                'Seja bem-vindo(a)!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      // drawer: DrawerList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          ///PROGRAMAR CADASTRO NAVIGATOR
        },
      ),
    );
  }
}