import 'package:agenda_esp_on/components/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(title),
    centerTitle: true,
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Container(
                    margin: EdgeInsets.all(24),
                    width: 180,
                    height: 180,
                    child: (Image.asset('assets/images/estetoscopio.png')))),
            Container(
              child: Column(
                children: [
                  Text("Bem-vindo!",
                      style: TextStyle(fontSize: 30, color: Colors.pink)),
                  Container(
                    height: 70,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {  },
                      style: elevatedButtonStyle,
                      child: (
                      Text('Entrar')
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(8),
                    child: TextButton(
                      onPressed: () {  },
                      style: textButtonStyle,
                      child: (Text("Não tenho Cadastro")),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
