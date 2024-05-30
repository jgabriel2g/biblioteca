import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserLoanPage extends StatelessWidget {
  final String id;

  const UserLoanPage({Key? key, required this.id}) : super(key: key);

  Future<void> finishLoan(
      BuildContext context, String loanId, String bookId) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .update({"loaned": false});
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('loans')
        .doc(loanId)
        .update({"finished": true});
    if (!context.mounted) return;
    showAlert(context);
  }

  Future<void> showAlert(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Biblioteca CUC"),
            content: const Text("Has devuelto el libro, muchas gracias!"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
          "Préstamos del Usuario",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .collection("loans")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () => {
                        if (snapshot.data!.docs[index].get('finished') == false)
                          finishLoan(context, snapshot.data!.docs[index].id,
                              snapshot.data?.docs[index].get('bookId'))
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              snapshot.data!.docs[index].get('finished') == true
                                  ? Colors.grey
                                  : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?.docs[index].get('bookTitle'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Fecha: ${snapshot.data?.docs[index].get('date')}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Estado: ${snapshot.data!.docs[index].get('finished') == true ? 'Finalizado' : 'En uso, toca para devolverlo'}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16),
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
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aun no has hecho préstamos',
                      ),
                    ],
                  ),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Aun no has hecho préstamos',
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
