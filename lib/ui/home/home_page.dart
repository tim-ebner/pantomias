import 'package:flutter/material.dart';

import 'home_view_model.dart';

enum GameMode { twoVsTwo, threeVsThree }

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text("Pantomias")),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (_, buildContext) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsetsGeometry.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(viewModel.imageName, style: Theme.of(context).textTheme.headlineLarge),
                    SizedBox(height: 16.0),
                    Expanded(child: Image(image: AssetImage(viewModel.imageAssetPath))),
                    SizedBox(height: 16.0),
                    ElevatedButton(onPressed: viewModel.toggleImage, child: viewModel.toggleIcon),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.nextImage,
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
