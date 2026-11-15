import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_translater_admin/core/route/app_routes.dart';
import 'package:smart_translater_admin/core/widgets/server_status_indicator.dart';

import '../../feature/auth/presentation/controller/auth_bloc.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        actions: [Center(child: ServerStatusIndicator())],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(
                      "A",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text("Admin", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.dashboard);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.settings);
              },
            ),
            const Divider(),
            SafeArea(
              child: ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text("logout"),
                onTap: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
