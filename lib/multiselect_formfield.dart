library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final Widget title;
  final Widget hintWidget;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final bool addAnyOption;
  final String anyLabel;
  final InputDecoration decorator;
  final bool optionsDeletable;
  final Color fillColor;
  final InputBorder border;
  final TextStyle chipLabelStyle;
  final Color chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color checkBoxCheckColor;
  final Color checkBoxActiveColor;

  MultiSelectFormField(
    {FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    dynamic initialValue,
    bool autovalidate = false,
    this.value,
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
    this.addAnyOption = false,
    this.anyLabel = 'Any',
    this.decorator = const InputDecoration(filled: true),
    this.optionsDeletable = false,
    this.chipLabelStyle,
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
          autovalidate: autovalidate,
          builder: (FormFieldState<dynamic> state) {
            List _dataSource = List.from(dataSource ?? []);
            dynamic _value = state.value ?? initialValue;

            if (addAnyOption) {
              _dataSource.insert(0, {
                valueField: MultiSelectDialogItem.ANY,
                textField: anyLabel
              });
            }

            List<Widget> _buildSelectedOptions(dynamic values, state) {
              List<Widget> selectedOptions = [];

              if (values != null) {
                values.forEach((item) {
                  if (item != MultiSelectDialogItem.ANY) {
                    var existingItem = _dataSource.singleWhere((itm) => itm[valueField] == item, orElse: () => null);
                    selectedOptions.add(Chip(
                      label: Text(existingItem[textField], overflow: TextOverflow.ellipsis),
                      onDeleted: optionsDeletable
                        ? () {
                            state.value.remove(existingItem[valueField]);
                            state.didChange(value);
                          }
                        : null,
                    ));
                  }
                });
              }

              return selectedOptions;
            }

            return InkWell(
              onTap: () async {
                List initialSelected = state.value;
                if (initialSelected == null) {
                  initialSelected = List();
                }
                if (addAnyOption && initialSelected.isEmpty) {
                  initialSelected.add(MultiSelectDialogItem.ANY);
                }

                final items = List<MultiSelectDialogItem>();
                _dataSource.forEach((item) {
                  items.add(MultiSelectDialogItem(item[valueField], item[textField]));
                });

                List selectedValues = await showDialog<List>(
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
                decoration:  decorator.copyWith(
                  errorText: state.hasError ? state.errorText : null,
                  errorMaxLines: 4,
                  fillColor: fillColor ?? Theme.of(state.context).canvasColor,
                  border: border ?? UnderlineInputBorder(),
                ),
                isEmpty: _value == null || _value == '',
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
                    _value != null && _value.length > 0 && _value.indexOf(MultiSelectDialogItem.ANY) == -1
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 0.0,
                            children: _buildSelectedOptions(_value, state),
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
