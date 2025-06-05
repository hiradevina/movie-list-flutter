import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bottom_nav_cubit.dart';
import '../components/app_bar_gone.dart';
import '../components/bottom_nav_bar.dart';
import 'movie_list_screen.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Widget> pageNavigation = <Widget>[
      MovieListPage(),
      MovieListPage(),
    ];

    return BlocProvider<BottomNavCubit>(
        create: (BuildContext context) => BottomNavCubit(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const AppBarGone(),

          /// When switching between tabs this will fade the old
          /// layout out and the new layout in.
          body: BlocBuilder<BottomNavCubit, int>(
            builder: (BuildContext context, int state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pageNavigation.elementAt(state),
              );
            },
          ),

          bottomNavigationBar: const BottomNavBar(),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ));
  }
}
