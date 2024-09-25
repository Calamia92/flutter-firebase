import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firebase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController codeController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void openDialogCode() async {
    final code = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: "Entrez votre code",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('Cancel');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                firestoreService.createCode(codeController.text);
                Navigator.of(context).pop('OK');
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );

    print('Code saisi : $code');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Code'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openDialogCode,
        tooltip: 'Ajouter un code',
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firestoreService.getCodes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey[300],
                  child: ListTile(
                    title: Text(
                      snapshot.data.docs[index]['code'],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
