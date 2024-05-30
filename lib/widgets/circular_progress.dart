import 'package:flutter/material.dart';

class CircularProgressWidget extends StatefulWidget {
  final String text;
  const CircularProgressWidget({Key? key, required this.text})
      : super(key: key);

  @override
  State<CircularProgressWidget> createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
              color: Color.fromARGB(255, 11, 73, 105)),
          const SizedBox(
            width: 15,
          ),
          Text(
            widget.text,
            style: const TextStyle(
                fontFamily: "MonB",
                color: Color.fromARGB(255, 11, 73, 105),
                fontSize: 15),
          )
        ],
      ),
    );
  }
}
