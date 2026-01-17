import 'package:flutter/material.dart';
import 'package:pantomias/data/model/image_meta_info_repository.dart';
import 'package:pantomias/routing/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [Provider(create: (_) => ImageMetaInfoRepository())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pantomias',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      routerConfig: router(),
    );
  }
}
