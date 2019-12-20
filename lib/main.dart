import 'package:chuck/api.dart';
import 'package:chuck/mapper.dart';
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
          child: Column(children: <Widget>[
        Container(
          height: 100,
          child: FutureBuilder<List<String>>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, position) {
                      return Icon(
                        icons[snapshot.data.elementAt(position)],
                        color: Colors.teal,
                        size: 40,
                        semanticLabel: snapshot.data.elementAt(position),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return SizedBox.shrink();
              }),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: FutureBuilder<Joke>(
                  future: joke,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data.value,
                        textAlign: TextAlign.center,
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    return CircularProgressIndicator();
                  }),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Icon(
                Icons.search,
                size: 50,
              ),
            ),
            Expanded(
                child: GestureDetector(
              child: Icon(
                Icons.update,
                size: 100,
              ),
              onTap: _fetchJoke,
            )),
            Expanded(
              child: Icon(
                Icons.share,
                size: 50,
              ),
            ),
          ],
        )
      ])),
    );
  }
}
