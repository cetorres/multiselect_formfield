import 'package:flutter/material.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>> items;
  final List<V> initialSelectedValues;
  final Widget title;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final int maxSelections;
  final TextStyle labelStyle;
  final ShapeBorder dialogShapeBorder;
  final Color checkBoxCheckColor;
  final Color checkBoxActiveColor;

  MultiSelectDialog(
      {Key key,
      this.items,
      this.initialSelectedValues,
      this.title,
      this.okButtonLabel,
      this.cancelButtonLabel,
      this.maxSelections,
      this.labelStyle = const TextStyle(),
      this.dialogShapeBorder,
      this.checkBoxActiveColor,
      this.checkBoxCheckColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = List<V>();
  bool _disableOptions = false;

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
      setState(() =>
          _disableOptions = _selectedValues.length == widget.maxSelections);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
      _disableOptions = _selectedValues.length == widget.maxSelections;
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  bool _isItemDisabled(bool isChecked) {
    return !isChecked && _disableOptions;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      shape: widget.dialogShapeBorder,
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(widget.cancelButtonLabel),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text(widget.okButtonLabel),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      checkColor: widget.checkBoxCheckColor,
      activeColor: widget.checkBoxActiveColor,
      title: Text(
        item.label,
        style: widget.labelStyle,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: _isItemDisabled(checked)
          ? null
          : (bool checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
