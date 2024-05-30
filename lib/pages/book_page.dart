import 'package:biblioteca_cuc/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookPage extends StatelessWidget {
  final String id;

  const BookPage({Key? key, required this.id}) : super(key: key);

  Future<void> setUserLoan(BuildContext context, String bookTitle) async {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final data = {
      'bookId': id,
      'bookTitle': bookTitle,
      'date': formattedDate,
      'finished': false,
    };
    await FirebaseFirestore.instance
        .collection('books')
        .doc(id)
        .update({"loaned": true});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('loans')
        .doc()
        .set(data);
    if (!context.mounted) return;
    showAlert(context, userId);
  }

  Future<void> showAlert(BuildContext context, String id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Biblioteca CUC"),
            content: const Text("Has prestado el libro, recuerda devolverlo!"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, Routes.userLoan,
                        arguments: id);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Detalle del Libro",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('books')
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var bookData = snapshot.data;
            return Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        bookData?['coverUrl'],
                        width: 170,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  bookData?['title'],
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Descripción",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              bookData?['description'],
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Autor",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              bookData?['author'],
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Año de publicación",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              bookData!['year'].toString(),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                setUserLoan(context, bookData['title']),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: bookData['loaned'] == true
                                  ? Colors.grey
                                  : Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: bookData['loaned'] == true
                                ? const Text('No disponible para préstamo')
                                : const Text('Solicitar Préstamo'),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

class Firestore {}
