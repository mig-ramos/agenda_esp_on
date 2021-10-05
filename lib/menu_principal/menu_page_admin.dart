import 'package:agenda_esp_on/components/navigation_drawer_admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPageAdmin extends StatefulWidget {
  const MenuPageAdmin({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MenuPageAdminState createState() => _MenuPageAdminState();
}

class _MenuPageAdminState extends State<MenuPageAdmin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerAdmin(),
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
                height: 60,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.lime,
                child: Text(
                  'Seja bem-vindo(a)!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          ///PROGRAMAR CADASTRO NAVIGATOR
        },
      ),
    );
  }
}