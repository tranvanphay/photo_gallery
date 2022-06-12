import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_gallery/db/database.dart';
import 'package:photo_gallery/model/item.dart';
import 'package:photo_gallery/staggred_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Gallery demo')),
        body: FutureBuilder<dynamic>(
            future: loadJson(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder<List<String>>(
                    future: _getTitles(),
                    builder: (context, titleSnap) {
                      if (titleSnap.hasData) {
                        return ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: titleSnap.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StaggeredPage(
                                title: titleSnap.data![index],
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })));
  }

  Future<dynamic> loadJson() async {
    final data = await rootBundle.loadString('assets/demo3.json');
    Iterable l = json.decode(data);
    final res = List<Item>.from(l.map((model) => Item.fromJson(model)));
    return await SQLiteDbProvider.instance.insert(photos: res);
  }

  Future<List<String>> _getTitles() async {
    return await SQLiteDbProvider.instance.getTitle();
  }

  // Future<Map<String, dynamic>> loadJson() async {
  //   final data = await rootBundle.loadString('assets/demo1.json');
  //   return json.decode(data);
  // }

  _getLocalData() {
    return Future.value(true);
  }
}
