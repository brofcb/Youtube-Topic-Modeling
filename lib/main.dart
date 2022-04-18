import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_topic_modeling/topic.dart';
import 'package:youtube_topic_modeling/widgets/input_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: HexColor("#FF0000")),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String videoUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#FF0000"),
        title: const Text(
          "YouTube Topic Modeling",
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/yt-background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
            ),
            child: Center(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 35,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Enter YouTube video link",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: InputTextField(
                            onChanged: (s) => {
                              setState(() {
                                videoUrl = s;
                              })
                            },
                            hintText: "ENTER A URL",
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        backgroundColor: HexColor("#FF0000"),
        onPressed: () => {
          if (videoUrl != "")
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondPage(
                          videoUrl: videoUrl,
                        )),
              )
            }
        },
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Future<List<Topic>>? topics;
  initState() {
    super.initState();
    print("init");
    topics = fetchTopics(widget.videoUrl);
  }

  Future<List<Topic>> fetchTopics(String videoUrl) async {
    print("Fetching");

    var topics = <Topic>[];
    final response = await http.get(Uri.parse(
        "https://us-central1-unique-bebop-342715.cloudfunctions.net/lda_model?url=$videoUrl"));
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      for (var topic in json["data"]) {
        topics.add(Topic(topic.cast<String>()));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load topic');
    }
    print("Passed");
    return topics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Found Topics",
          ),
          backgroundColor: Colors.red),
      body: Center(
          child: FutureBuilder<List<Topic>>(
        future: topics,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Topic>> snapshot,
        ) {
          if (snapshot.hasData) {
            return (ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, i) {
                Topic topic = snapshot.data![i];
                return ListTile(
                  title: Text("Topic ${i + 1}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WordsList(
                                topic: topic,
                              )),
                    );
                  },
                );
              },
            ));
          } else {
            return (CircularProgressIndicator());
          }
        },
      )),
    );
  }
}

class WordsList extends StatelessWidget {
  const WordsList({Key? key, required this.topic}) : super(key: key);
  final Topic topic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Words"),
        backgroundColor: Colors.red,
      ),
      body: Center(
          child: ListView.builder(
              itemCount: topic.words.length,
              itemBuilder: (context, i) {
                String word = topic.words[i];
                return ListTile(
                  title: Text(word),
                );
              })),
    );
  }
}
