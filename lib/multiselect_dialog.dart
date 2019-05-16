import 'package:flutter/material.dart';

class MultiSelectDialogItem {
  static const ANY = 'any';
  const MultiSelectDialogItem(this.value, this.label);

  final dynamic value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog(
      {Key key, this.items, this.initialSelectedValues, this.title, this.okButtonLabel, this.cancelButtonLabel})
      : super(key: key);

  final List<MultiSelectDialogItem> items;
  final List<dynamic> initialSelectedValues;
  final String title;
  final String okButtonLabel;
  final String cancelButtonLabel;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = List<dynamic>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(dynamic itemValue, bool checked) {
    if (itemValue == MultiSelectDialogItem.ANY) {
      this._setAnyOption(selected: true, reset: true);
    } else {
      setState(() {
        if (checked) {
          _selectedValues.add(itemValue);
        } else {
          _selectedValues.remove(itemValue);
        }
        // Set any options status
        if (_selectedValues.length == 0) {
          this._setAnyOption(selected: true);
        } else {
          this._setAnyOption(selected: false);
        }
      });
    }
  }

  void _setAnyOption({selected = true, reset = false}) {
    setState(() {
      if (reset) _selectedValues.clear();
      selected
        ? _selectedValues.add(MultiSelectDialogItem.ANY)
        : _selectedValues.remove(MultiSelectDialogItem.ANY);
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
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

  Widget _buildItem(MultiSelectDialogItem item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
