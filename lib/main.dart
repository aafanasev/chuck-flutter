import 'package:chuck/api.dart';
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
  Future<List<String>> categories;
  Future<Joke> joke;

  void _fetchJoke() {
    setState(() {
      joke = fetchRandomJoke();
    });
  }

  @override
  void initState() {
    super.initState();
    categories = fetchCategories();
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
            Expanded(
              child: FutureBuilder<List<String>>(
                future: categories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, position) {
                        return Text(snapshot.data.elementAt(position));
                      },
                      scrollDirection: Axis.horizontal,
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  return SizedBox.shrink();
                }),
            ),
            FutureBuilder<Joke>(
                future: joke,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error);
                  }

                  return CircularProgressIndicator();
                })
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
