import 'package:flutter/material.dart';

import '../components/app_bar_gone.dart';
import 'movie_list_screen.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarGone(),

      /// When switching between tabs this will fade the old
      /// layout out and the new layout in.
      body: MovieListPage(),

      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
