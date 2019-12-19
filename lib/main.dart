import 'package:chuck/joke.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuck Norris',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Chuck Norris facts'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future<Joke> joke;

  void _fetchJoke() {
    setState(() {
      joke = fetchRandomJoke();
    });
  }

  @override
  void initState() {
    super.initState();
    joke = fetchRandomJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Joke>(
                future: joke,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }

                  return CircularProgressIndicator();
                }
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchJoke,
        tooltip: 'Random joke',
        child: Icon(Icons.add),
      ),
    );
  }
}
