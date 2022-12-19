import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:reminder/main.dart';
import 'package:reminder/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';

import '../graphql/graphql_api.graphql.dart';
import '../helpers/form.dart';
import '../helpers/func.dart';
import '../helpers/styles.dart';
import '../widgets/button.dart';
import '../widgets/card.dart';

class UpsertReminderBottomSheet extends HookConsumerWidget {
  final formKey = GlobalKey<FormBuilderState>();
  final MixedReminderFragmentMixin? reminder;

  UpsertReminderBottomSheet({super.key, this.reminder});

  Future<void> fnUpsertReminder(BuildContext context, WidgetRef ref) async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final value = formKey.currentState!.value;
      logger.info('value is $value');
      context.loaderOverlay.show();
      try {
        await Func.ins
            .upsertReminder(
          context,
          id: reminder?.origin.id,
          name: value[ReminderFormNames.name.name],
          description: value[ReminderFormNames.description.name],
          date: value[ReminderFormNames.date.name] as DateTime?,
          time: value[ReminderFormNames.time.name] != null
              ? TimeOfDay.fromDateTime(
                  value[ReminderFormNames.time.name] as DateTime)
              : null,
        )
            .then((_) {
          Navigator.of(context).pop();
          AsunaDialog.message('success');
        });
        ref.invalidate(myRemindersProvider);
      } catch (e) {
        logger.severe(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('upsert reminder error')),
        );
      } finally {
        context.loaderOverlay.hide();
      }
      /*
      await Future.microtask(() async {
        await Func.ins.upsertEvent(
          item: widget.item,
          name: value[CommonFormNames.name.name],
          description: value[CommonFormNames.description.name],
          topic: value[CommonFormNames.topic.name],
          link: value[_FormNames.link.name],
          previewData: previewData,
          circleId: FormFields.getCircle(value),
          cover: FormFields.getAsset(value, CommonFormNames.cover.name),
          audioName: value[_FormNames.audioName.name],
          audio: FormFields.getAsset(value, CommonFormNames.audio.name),
          videoName: value[_FormNames.videoName.name],
          video: FormFields.getAsset(value, CommonFormNames.video.name),
          images: FormFields.getAssets(value, CommonFormNames.images.name),
          controller: controller,
        );
        logger.info('create event done');
        AsunaDialog.message('${widget.item != null ? '编辑' : '创建'}成功');
        await Future.delayed(const Duration(milliseconds: 300));
        controller.add({});
        formKey.currentState?.reset();
        logger.info('goto home...');
        Navigator.of(context).pop(true);
      }).catchError((e, s) {
        logger.info('create event error $e $s');
        // AsunaDialog.error('${widget.item != null ? '编辑' : '创建'}失败 $e');
      }).whenComplete(() => context.loaderOverlay.hide());*/
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final update = useUpdate();
    final initialValue = useMemoized<Map<String, dynamic>>(() {
      return {
        ReminderFormNames.name.name: reminder?.origin.name,
        ReminderFormNames.description.name: reminder?.origin.description,
      };
    });

    final isValid = formKey.currentState?.isValid;
    final formErrors = useMap<String, bool?>({});

    /*
    useEffectOnce(() {
      if (initialValue.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          formKey.currentState?.validate();
          update();
          // isValid = formKey.currentState?.saveAndValidate();
        });
      }
      return null;
    });*/

    useLogger('<[UpsertReminderBottomSheet]>', props: {
      'isValid': isValid,
      'formErrors': formErrors.map,
      'value': formKey.currentState?.value,
    });

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(children: [
        const SizedBox(height: 16),
        AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // leading: Text('Cancel', style: FontStyles.title),
            title: Text(
              '${reminder != null ? 'Update' : 'Create'} Reminder',
              style: FontStyles.header.copyWith(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: isValid == true
                    ? () => fnUpsertReminder(context, ref)
                    : null,
                child: const Text('Save'),
              ),
            ]),
        Expanded(
          child: LoaderOverlay(
            child: FormBuilder(
              key: formKey,
              /*
              onWillPop: () async {
                final instantValue = formKey.currentState?.instantValue;
                logger.info('save to draft $instantValue');
                ref
                    .read(_draftProvider.notifier)
                    .update((state) => instantValue);
                return true;
              },*/
              initialValue: initialValue,
              // autoFocusOnValidationFailure: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(shrinkWrap: true, children: [
                  Column(children: [
                    CardContainer(
                      child: Column(children: [
                        FormFields.text(ref,
                            formKey: formKey,
                            name: ReminderFormNames.name.name,
                            title: '',
                            maxLines: 10,
                            maxLength: 300,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              // FormBuilderValidators.minLength(10),
                              FormBuilderValidators.maxLength(300),
                            ]),
                            formErrors: formErrors),
                        FormFields.text(ref,
                            formKey: formKey,
                            name: ReminderFormNames.description.name,
                            title: 'Note',
                            maxLines: 10,
                            maxLength: 300,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              // FormBuilderValidators.minLength(10),
                              FormBuilderValidators.maxLength(300),
                            ]),
                            formErrors: formErrors),
                      ]),
                    ),
                    CardContainer(
                      child: Column(children: [
                        FormBuilderDateTimePicker(
                          name: ReminderFormNames.date.name,
                          inputType: InputType.date,
                          format: DateFormat('yyyy-MM-dd'),
                          onChanged: (value) {
                            formKey.currentState?.saveAndValidate();
                            update();
                          },
                          decoration: InputDecoration(
                            labelText: 'Date',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => formKey
                                  .currentState?.fields['date']
                                  ?.didChange(null),
                            ),
                          ),
                        ),
                        FormBuilderDateTimePicker(
                          name: ReminderFormNames.time.name,
                          inputType: InputType.time,
                          format: DateFormat('HH:mm'),
                          onChanged: (value) {
                            formKey.currentState?.saveAndValidate();
                            update();
                          },
                          decoration: InputDecoration(
                            labelText: 'Time',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => formKey
                                  .currentState?.fields['time']
                                  ?.didChange(null),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                  // Row(children: <Widget>[
                  //   /*
                  //   if (initialValue.isNotEmpty)
                  //     Expanded(
                  //       child: Container(
                  //         margin: const EdgeInsets.only(right: 10),
                  //         child: OutlinedButton(
                  //           onPressed: () {
                  //             // ref
                  //             //     .read(_draftProvider.notifier)
                  //             //     .update((state) => {});
                  //             // update();
                  //             final empty = formKey.currentState?.fields.map(
                  //                     (key, value) => MapEntry(key, null)) ??
                  //                 const {};
                  //             formKey.currentState?.patchValue(empty);
                  //           },
                  //           child: const Text('Clear'),
                  //         ),
                  //       ),
                  //     ),*/
                  //   Expanded(
                  //     child: OutlinedButton(
                  //       onPressed:
                  //           (isValid != null /*|| initialValue.isNotEmpty*/)
                  //               ? () => formKey.currentState?.reset()
                  //               : null,
                  //       child: const Text('Reset'),
                  //     ),
                  //   ),
                  //   const SizedBox(width: 10),
                  //   Expanded(
                  //     child: AsunaButton(
                  //       onPressed: isValid == true
                  //           ? () =>
                  //               fnUpsertReminder(context, ref).then((value) {
                  //                 /*
                  //                 return ref
                  //                     .read(_draftProvider.notifier)
                  //                     .update((state) => {});*/
                  //               })
                  //           : null,
                  //       child: const Text(
                  //         'Create',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //     ),
                  //   ),
                  // ]),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
