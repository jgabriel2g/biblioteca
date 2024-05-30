import 'package:biblioteca_cuc/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final String id;

  const UserPage({Key? key, required this.id}) : super(key: key);

  void showUserLoan(BuildContext context, String id) {
    Navigator.pushNamed(context, Routes.userLoan, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Perfil de Usuario",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.library_books,
              color: Colors.white,
            ),
            onPressed: () => showUserLoan(context, id),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var userData = snapshot.data;
            return Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/6326/6326055.png",
                        width: 80,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  userData?['full_name'],
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 30),
                Text(
                  "Email",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  userData?['email'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  "Número de Identificación",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  userData?['identification_number'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  "Rol",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  userData!['rol'].toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            );
          }),
    );
  }
}
