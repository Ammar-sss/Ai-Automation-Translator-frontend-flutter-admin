import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_translater_admin/feature/auth/data/models/user.dart';
import 'package:smart_translater_admin/feature/dashboard/presentation/controller/user_cubit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<UserCubit>();
    if (cubit.state is! UserLoaded) {
      cubit.loadAllUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Bar / Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "All Users",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => context.read<UserCubit>().loadAllUsers(),
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh Users",
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Search user...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  child: const Text("Clear"),
                ),
              ],
            ],
          ),
        ),

        // Expanded takes all remaining screen space cleanly
        Expanded(
          child: BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {
              if (state is UserFailer) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is UserOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserLoaded) {
                final List<User> users = state.user;

                final filteredUser = users.where((user) {
                  final query = _searchQuery.toLowerCase().trim();
                  if (query.isEmpty) return true;
                  return user.username.toLowerCase().contains(query) ||
                      user.email.trim().toLowerCase().contains(query);
                }).toList();

                // Pull-to-refresh enabled!
                return RefreshIndicator(
                  onRefresh: () => context.read<UserCubit>().loadAllUsers(),
                  child: ListView.separated(
                    itemCount: filteredUser.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = filteredUser[index];
                      final bool isAdmin = user.email == "admin@just.com";
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            user.username.isNotEmpty
                                ? user.username[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(user.username),
                        subtitle: Text(user.email),
                        trailing: !isAdmin
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (user.enabled) {
                                        context
                                            .read<UserCubit>()
                                            .deActivateUserByID(user.id);
                                      } else {
                                        context
                                            .read<UserCubit>()
                                            .activateUserById(user.id);
                                      }
                                    },
                                    tooltip: user.enabled
                                        ? "Deactivate"
                                        : "Activate",
                                    icon: Icon(
                                      user.enabled
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                      color: user.enabled
                                          ? Colors.green
                                          : Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<UserCubit>().deleteUserById(
                                        user.id,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
                );
              }

              return const Center(child: Text("Press refresh to load users"));
            },
          ),
        ),
      ],
    );
  }
}
