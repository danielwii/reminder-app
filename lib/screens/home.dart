import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../dialogs/upsert-reminder-bottom-sheet.dart';
import 'inbox.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});

  final screens = [
    Center(child: Text('Discover')),
    Center(child: Text('Collections')),
    Center(child: Text('Dashboard')),
    const InboxScreen(),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useNumber(3);

    useLogger('<[HomeScreen]>', props: {'selected': selected.value});

    return Scaffold(
      bottomNavigationBar: NavigationBar(
          selectedIndex: selected.value,
          onDestinationSelected: selected.setter,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.search), label: 'Discover'),
            NavigationDestination(
                icon: Icon(Icons.collections_bookmark), label: 'Collections'),
            NavigationDestination(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          // open an bottom sheet to choose the type of the new item
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => UpsertReminderBottomSheet());
        },
      ),
      body: screens.elementAt(selected.value),
    );
  }
}
