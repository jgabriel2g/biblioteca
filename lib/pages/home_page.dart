import 'package:biblioteca_cuc/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User userData;
  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showBook(BuildContext context, String id) {
    Navigator.pushNamed(context, Routes.book, arguments: id);
  }

  void showUser(BuildContext context, String id) {
    Navigator.pushNamed(context, Routes.user, arguments: id);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushNamedAndRemoveUntil(
            Routes.login, (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Catálogo de Libros",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () => showUser(context, widget.userData.uid),
          ),
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => signOut(),
          ),
        ],
      ),
      floatingActionButton: null,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () =>
                        showBook(context, snapshot.data?.docs[index].get('id')),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white70,
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                snapshot.data?.docs[index].get('coverUrl'),
                                width: 100,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data?.docs[index].get('title'),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Autor: ${snapshot.data?.docs[index].get('author')}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Año de publicación: ${snapshot.data!.docs[index].get('year')}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Error cargando los libros disponibles');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
