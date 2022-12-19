import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:reminder/graphql/graphql_api.dart';
import 'package:reminder/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reminder/widgets/snackbar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:simple_animations/simple_animations.dart';
import '../dialogs/upsert-reminder-bottom-sheet.dart';
import '../helpers/form.dart';
import '../helpers/func.dart';
import '../helpers/styles.dart';
import '../services/providers.dart';
import '../widgets/render.dart';

/// create a list of reminderscf
///
/// each reminder will have a title, a description, a time and a date
/// the reminder will be displayed in a list view
/// each reminder will have a delete button
/// when clicked, the reminder will be deleted
/// and the list will be updated
/// the list will be displayed in a column
class InboxScreen extends HookConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRemindersProviderRef = ref.watch(myRemindersProvider);

    final editModeID = useState<String?>(null);

    useLogger('<[InboxScreen]>', props: {
      'total': myRemindersProviderRef.valueOrNull?.myReminders.length,
      'editModeID': editModeID.value,
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: SafeArea(
        child: KeyboardDismisser(
          child: GestureDetector(
            onTap: () {
              logger.info('tap outside');
              editModeID.value = null;
            },
            child: AsunaListRender(
              isLoading: myRemindersProviderRef.isLoading &&
                  !myRemindersProviderRef.isRefreshing,
              hasError: myRemindersProviderRef.hasError,
              isEmpty:
                  myRemindersProviderRef.valueOrNull?.myReminders.isEmpty ??
                      true,
              onRefresh: () => ref.invalidate(myRemindersProvider),
              render: () {
                final elements = myRemindersProviderRef.value!.myReminders;

                return RefreshIndicator(
                  onRefresh: () {
                    ref.invalidate(myRemindersProvider);
                    return ref.read(myRemindersProvider.future);
                  },
                  child: ListView.separated(
                    itemCount: elements.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final element = elements[index];
                      return Slidable(
                        key: ValueKey(element.origin.id),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          dismissible: DismissiblePane(
                              closeOnCancel: true,
                              onDismissed: () {
                                // TODO delete the reminder
                                logger.info('onDismissed');
                              },
                              confirmDismiss: () => AsunaDialog.confirm(context,
                                      title: const Text('Delete reminder'),
                                      content: const Text(
                                          'Are you sure you want to delete this reminder?'))
                                  .then((confirmed) => confirmed == true)),
                          extentRatio: .25,
                          children: [
                            SlidableAction(
                              onPressed: (context) {},
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: .25,
                          children: [
                            /*
                            SlidableAction(
                              onPressed: (context) {},
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              label: 'Share',
                            ),*/
                            SlidableAction(
                              // An action can be bigger than the others.
                              onPressed: (context) {},
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: 'Archive',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => editModeID.value = element.origin.id,
                          child: editModeID.value == element.origin.id
                              ? _EditReminderTile(ref: ref, reminder: element)
                              : _ReminderTile(
                                  key: ValueKey(element.origin.id),
                                  reminder: element),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _EditReminderTile extends HookWidget {
  final WidgetRef ref;
  final formKey = GlobalKey<FormBuilderState>();
  final MixedReminderFragmentMixin reminder;

  _EditReminderTile({super.key, required this.ref, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final draft = useMap({});

    useUnmount(() {
      if (draft.map.isNotEmpty) {
        logger.info('unmount ${draft.map}, trigger save');
        Func.ins
            .upsertReminder(
              context,
              id: reminder.origin.id,
              name: draft.map['name'],
              description: draft.map['description'],
            )
            .then((value) => ref.invalidate(myRemindersProvider))
            .catchError(
          (error) {
            logger.severe('update reminder error $error');
            AsunaDialog.error('update reminder error');
          },
        );
      }
    });

    useLogger('<[_EditReminderTile]>', props: {
      'reminder': reminder,
      'draft': draft.map,
    });

    return Card(
      child: FormBuilder(
        key: formKey,
        onChanged: () {
          formKey.currentState!.save();
          draft.replace(formKey.currentState!.value);
        },
        initialValue: {
          ReminderFormNames.name.name: reminder.origin.name,
          ReminderFormNames.description.name: reminder.origin.description,
        },
        child: ListTile(
          title: FormBuilderTextField(
            name: ReminderFormNames.name.name,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: InputBorder.none,
            ),
          ),
          subtitle: FormBuilderTextField(
            name: ReminderFormNames.description.name,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: InputBorder.none,
            ),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ),
      ),
    );
  }
}

class _ReminderTile extends HookConsumerWidget {
  final MixedReminderFragmentMixin reminder;

  const _ReminderTile({super.key, required this.reminder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = useState(false);

    useLogger('<[_ReminderTile]>', props: {
      'reminder': reminder,
      'id': reminder.origin.id,
    });

    return Column(children: [
      ListTile(
        leading: IconButton(
          icon: Icon(isDone.value
              ? Icons.check_outlined
              : Icons.radio_button_unchecked_outlined),
          onPressed: () => isDone.value = !isDone.value,
        ),
        title: Text(reminder.origin.name),
        subtitle: reminder.origin.description?.isNotEmpty ?? false
            ? Text(reminder.origin.description!)
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) =>
                    UpsertReminderBottomSheet(reminder: reminder));
          },
        ),
      ),
      Row(children: [
        const SizedBox(width: 78),
        if (reminder.origin.startDate != null)
          Row(children: [
            const Icon(Icons.calendar_today_outlined),
            const SizedBox(width: 8),
            Text(DateFormat.yMd().format(reminder.origin.startDate!)),
            const SizedBox(width: 16),
          ]),
        if (reminder.origin.startTime != null)
          Row(children: [
            const Icon(Icons.access_time_outlined),
            const SizedBox(width: 8),
            Text(reminder.origin.startTime!),
          ]),
      ]),
    ]);
  }
}
