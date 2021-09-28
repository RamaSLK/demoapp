import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      // return SomethingWentWrong();
      return MaterialApp(
          home:Scaffold(
            appBar: AppBar(
              title: const Text('Something went wrong'),
              centerTitle: true,
            ),
          )
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      // return Loading();
      return MaterialApp(
          home:Scaffold(
            appBar: AppBar(
              title: const Text('Something is loading'),
              centerTitle: true,
            ),
          )
      );
    }

    // return MyAwesomeApp();
    return MaterialApp(
        home:Scaffold(
          appBar: AppBar(
            title: const Text('Something has loaded'),
            centerTitle: true,
          ),
          body: Center(
            child: GetPlayers('0FwJzh7uKwLMLjuqaWvB'),
          )
        )
    );
  }
}

class GetPlayers extends StatelessWidget {
  final String documentId;

  GetPlayers(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference players = FirebaseFirestore.instance.collection('players');

    return FutureBuilder<DocumentSnapshot>(
      future: players.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Player: ${data['FirstName']} ${data['LastName']} \n"
              "Country: ${data['Country']}\n"
              "Age: ${data['Age']}\n"
              "Gender: ${data['Gender']}");
        }

        return Text("loading");
      },
    );
  }
}