library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/src/multiselect_dialog.dart';
import 'package:multiselect_formfield/src/pair.dart';

class MultiSelectFormField<T> extends FormField<Iterable<T>> {
  final Widget title;
  final Widget hintWidget;
  final bool required;
  final String errorText;
  final Iterable<Pair<T>>? dataSource;
  final String? textField;
  final T? valueField;
  final Function? change;
  final Function? open;
  final Function? close;
  final Widget? leading;
  final Widget? trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? chipLabelStyle;
  final Color? chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final bool enabled;

  MultiSelectFormField({
    FormFieldSetter<Iterable<T>>? onSaved,
    FormFieldValidator<Iterable<T>>? validator,
    Iterable<T>? initialValue,
    AutovalidateMode? autovalidate = AutovalidateMode.disabled,
    this.title = const Text('Title'),
    this.hintWidget = const Text('Tap to select one or more'),
    this.required = false,
    this.errorText = 'Please select one or more options',
    this.leading,
    this.dataSource,
    this.textField,
    this.valueField,
    this.change,
    this.open,
    this.close,
    this.okButtonLabel = 'OK',
    this.cancelButtonLabel = 'CANCEL',
    this.fillColor,
    this.border,
    this.trailing,
    this.chipLabelStyle,
    this.enabled = true,
    this.chipBackGroundColor,
    this.dialogTextStyle = const TextStyle(),
    this.dialogShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    ),
    this.checkBoxActiveColor,
    this.checkBoxCheckColor,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidate,
          builder: (FormFieldState<Iterable<T>> state) {
            List<Widget> _buildSelectedOptions(state) {
              List<Widget> selectedOptions = [];

              if (state.value != null) {
                state.value.forEach((item) {
                  Pair<T>? existingItem;
                  try {
                    existingItem = dataSource!.singleWhere(
                      ((itm) => itm.value == item),
                    );
                  } catch (e) {}
                  selectedOptions.add(Chip(
                    labelStyle: chipLabelStyle,
                    backgroundColor: chipBackGroundColor,
                    label: Text(
                      existingItem?.label ?? "",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ));
                });
              }

              return selectedOptions;
            }

            return InkWell(
              onTap: !enabled
                  ? null
                  : () async {
                      Iterable<T>? initialSelected = state.value;
                      if (initialSelected == null) {
                        initialSelected = List<T>.empty(growable: true);
                      }

                      final items = <MultiSelectDialogItem<T>>[];
                      dataSource!.forEach((item) {
                        items
                            .add(MultiSelectDialogItem(item.value, item.label));
                      });

                      Iterable<T>? selectedValues =
                          await showDialog<Iterable<T>?>(
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
                isEmpty: state.value == null || state.value == '',
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
                          required
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
                    state.value != null && state.value!.length > 0
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 0.0,
                            children: _buildSelectedOptions(state),
                          )
                        : new Container(
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
