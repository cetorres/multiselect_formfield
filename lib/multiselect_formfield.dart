library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final Widget title;
  final Widget hintWidget;
  final bool required;
  final String errorText;
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
  final Color fillColor;
  final InputBorder border;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final InputBorder errorBorder;
  final TextStyle chipLabelStyle;
  final Color chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color checkBoxCheckColor;
  final Color checkBoxActiveColor;
  final Radius borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Color cancelButtonTextColor;
  final Color okButtonTextColor;
  final Color iconColor;

  MultiSelectFormField({
    FormFieldSetter<dynamic> onSaved,
    FormFieldValidator<dynamic> validator,
    dynamic initialValue,
    bool autovalidate = false,
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
    this.chipBackGroundColor,
    this.dialogTextStyle = const TextStyle(),
    this.dialogShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    ),
    this.checkBoxActiveColor,
    this.checkBoxCheckColor,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.borderRadius = Radius.zero,
    this.contentPadding = EdgeInsets.zero,
    this.okButtonTextColor,
    this.cancelButtonTextColor,
    this.iconColor = Colors.black87
  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autovalidate,
    builder: (FormFieldState<dynamic> state) {
      List<Widget> _buildSelectedOptions(state) {
        List<Widget> selectedOptions = [];

        if (state.value != null) {
          state.value.forEach((item) {
            var existingItem = dataSource.singleWhere(
                    (itm) => itm[valueField] == item,
                orElse: () => null);
            selectedOptions.add(Chip(
              labelStyle: chipLabelStyle,
              backgroundColor: chipBackGroundColor,
              label: Text(
                existingItem[textField],
                overflow: TextOverflow.ellipsis,
                // style: TextStyle(color: Colors.red),
              ),
            ));
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

          final items = List<MultiSelectDialogItem<dynamic>>();
          dataSource.forEach((item) {
            items.add(
                MultiSelectDialogItem(item[valueField], item[textField]));
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
                okButtonTextColor: okButtonTextColor,
                cancelButtonTextColor: cancelButtonTextColor,
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
            contentPadding: contentPadding,
            fillColor: fillColor ?? Theme
                .of(state.context)
                .canvasColor,
            border: border ?? OutlineInputBorder(
              borderRadius: BorderRadius.all(borderRadius),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: focusedBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.all(borderRadius),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: enabledBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.all(borderRadius),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            errorBorder: errorBorder ?? OutlineInputBorder(
              borderRadius: BorderRadius.all(borderRadius),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
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
                      color: iconColor,
                      size: 25.0,
                    ),
                  ],
                ),
              ),
              state.value != null && state.value.length > 0
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
