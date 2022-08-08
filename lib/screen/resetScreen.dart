import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Reset Password"),
          centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
            child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: "Reset Email"),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(onPressed: () {}, child: Text("Reset")))
          ],
        )),
      ),
    );
  }
}
