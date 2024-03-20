// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

// This example demonstrates how to setup nested navigation using a
// BottomNavigationBar, where each bar item uses its own persistent navigator,
// i.e. navigation state is maintained separately for each item. This setup also
// enables deep linking into nested pages.

void main() {
  runApp(NestedTabNavigationExampleApp());
}

/// An example demonstrating how to use nested navigators
class NestedTabNavigationExampleApp extends StatelessWidget {
  /// Creates a NestedTabNavigationExampleApp
  NestedTabNavigationExampleApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/a',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return ScaffoldWithNavDrawer(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/a',
                name: PageA.routeName,
                builder: (BuildContext context, GoRouterState state) => const PageA(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'details/:id',
                    name: DetailAPage.routeName,
                    builder: (BuildContext context, GoRouterState state) => const DetailAPage(),
                  ),
                  GoRoute(
                    path: 'form',
                    name: FormAPage.routeName,
                    builder: (BuildContext context, GoRouterState state) => const FormAPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/b',
                name: PageB.routeName,
                builder: (BuildContext context, GoRouterState state) => const PageB(),
                routes: <RouteBase>[

                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/c',
                name: PageC.routeName,
                builder: (BuildContext context, GoRouterState state) => const PageC(),
                routes: <RouteBase>[

                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

class ScaffoldWithNavDrawer extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavDrawer].
  const ScaffoldWithNavDrawer({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Text('Nav Drawer'),
                ),
                ListTile(
                  title: Text('A ${navigationShell.currentIndex == 0 ? 'Selected' : ''}'),
                  selected: navigationShell.currentIndex == 0,
                  onTap: () {
                    _onTap(context, 0);
                  },
                ),
                ListTile(
                  title: Text('B ${navigationShell.currentIndex == 1 ? 'Selected' : ''}'),
                  selected: navigationShell.currentIndex == 1,
                  onTap: () {
                    _onTap(context, 1);
                  },
                ),
                ListTile(
                  title: Text('C ${navigationShell.currentIndex == 2 ? 'Selected' : ''}'),
                  selected: navigationShell.currentIndex == 2,
                  onTap: () {
                    _onTap(context, 2);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class PageA extends StatelessWidget {
  static const String routeName = 'a';

  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page A'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              context.goNamed(DetailAPage.routeName, pathParameters: {'id': 'id_example'});
            },
            child: const Text('View detail Page'),
          ),
          TextButton(
            onPressed: () {
              context.goNamed(FormAPage.routeName);
            },
            child: const Text('View Form Page'),
          ),
        ],
      ),
    );
  }
}

class DetailAPage extends StatelessWidget {
  static const String routeName = 'detail_a';

  const DetailAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail A Page'),
      ),
    );
  }
}

class FormAPage extends StatelessWidget {
  static const String routeName = 'form_a';

  const FormAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form A Page'),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  static const String routeName = 'b';

  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page B'),
      ),
    );
  }
}

class PageC extends StatelessWidget {
  static const String routeName = 'c';

  const PageC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page C'),
      ),
    );
  }
}
