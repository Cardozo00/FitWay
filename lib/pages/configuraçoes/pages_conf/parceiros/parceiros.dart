import 'package:flutter/material.dart';

class ParceirosPage extends StatefulWidget {
  const ParceirosPage({super.key});

  @override
  State<ParceirosPage> createState() => _ParceirosPageState();
}

class _ParceirosPageState extends State<ParceirosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff0A6D92),
        title: const Text(
          'Nossos parceiros',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Academias Parceiras',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center, color: Color(0xff0A6D92)),
              title: Text('AFC Academia'),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Personais Parceiros',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xff0A6D92)),
              title: Text('Marcos Phellype'),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xff0A6D92)),
              title: Text('John Carlos'),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Nutricionistas Parceiros',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_hospital, color: Color(0xff0A6D92)),
              title: Text('João Vitor Costa'),
            ),
            ListTile(
              leading: Icon(Icons.local_hospital, color: Color(0xff0A6D92)),
              title: Text('João Vitor Teixeira'),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Lojas Parceiras',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.store, color: Color(0xff0A6D92)),
              title: Text('Suplenger'),
            ),
          ],
        ),
      ),
    );
  }
}
