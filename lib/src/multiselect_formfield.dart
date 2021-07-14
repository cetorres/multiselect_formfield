library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/src/multiselect_dialog.dart';
import 'package:multiselect_formfield/src/pair.dart';

class MultiSelectFormField<T> extends StatelessWidget {
  final FormFieldSetter<Iterable<T>>? onSaved;
  final FormFieldValidator<Iterable<T>>? validator;
  final Iterable<T>? initialValue;
  final AutovalidateMode? autovalidate;
  final Widget title;
  final Widget hintWidget;
  final bool needed;
  final String errorText;
  final Iterable<Pair<T>> dataSource;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? chipLabelStyle;
  final Color? chipBackgroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final bool enabled;

  MultiSelectFormField({
    Key? key,
    required this.dataSource,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.autovalidate = AutovalidateMode.disabled,
    this.title = const Text('Title'),
    this.hintWidget = const Text('Tap to select one or more'),
    this.needed = false,
    this.errorText = 'Please select one or more options',
    this.okButtonLabel = 'OK',
    this.cancelButtonLabel = 'CANCEL',
    this.fillColor,
    this.border,
    this.chipLabelStyle,
    this.enabled = true,
    this.chipBackgroundColor,
    this.dialogTextStyle = const TextStyle(),
    this.dialogShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    ),
    this.checkBoxActiveColor,
    this.checkBoxCheckColor,
  }) : super(key: key);

  List<Widget> _buildSelectedOptions(FormFieldState<Iterable<T>> state) {
    final List<Widget> selectedOptions = [];
    final values = state.value;

    if (values != null) {
      for (final value in values) {
        Pair<T>? existingItem = dataSource.cast<Pair<T>?>().singleWhere(
              ((itm) => itm?.value == value),
              orElse: () => null,
            );
        if (existingItem != null) {
          selectedOptions.add(
            Chip(
              labelStyle: chipLabelStyle,
              backgroundColor: chipBackgroundColor,
              label: Text(
                existingItem.label,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
      }
    }
    return selectedOptions;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Iterable<T>>(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidateMode: autovalidate,
      builder: (FormFieldState<Iterable<T>> state) {
        return InkWell(
          onTap: !enabled
              ? null
              : () async {
                  Iterable<T>? initialSelected =
                      state.value ?? List<T>.empty(growable: true);
                  final items = <MultiSelectDialogItem<T>>[];
                  for (final pair in dataSource) {
                    items.add(MultiSelectDialogItem(pair.value, pair.label));
                  }

                  Iterable<T>? selectedValues = await showDialog<Iterable<T>?>(
                    context: state.context,
                    builder: (BuildContext context) {
                      return MultiSelectDialog(
                        title: title,
                        okButtonLabel: okButtonLabel,
                        cancelButtonLabel: cancelButtonLabel,
                        items: items,
                        initialSelectedValues: initialSelected,
                        labelStyle: dialogTextStyle,
                        dialogShapeBorder: dialogShapeBorder,
                        checkBoxActiveColor: checkBoxActiveColor,
                        checkBoxCheckColor: checkBoxCheckColor,
                      );
                    },
                  );

                  if (selectedValues != null) {
                    state.didChange(selectedValues);
                    state.save();
                  }
                },
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              errorText: state.hasError ? state.errorText : null,
              errorMaxLines: 4,
              fillColor: fillColor ?? Theme.of(state.context).canvasColor,
              border: border ?? UnderlineInputBorder(),
            ),
            isEmpty: state.value?.isEmpty ?? false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: title,
                      ),
                      needed
                          ? Padding(
                              padding: EdgeInsets.only(top: 5, right: 5),
                              child: Text(
                                ' *',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 17.0,
                                ),
                              ),
                            )
                          : Container(),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black87,
                        size: 25.0,
                      ),
                    ],
                  ),
                ),
                state.value?.isNotEmpty ?? false
                    ? Wrap(
                        spacing: 8.0,
                        runSpacing: 0.0,
                        children: _buildSelectedOptions(state),
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 4),
                        child: hintWidget,
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
