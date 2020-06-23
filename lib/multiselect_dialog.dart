import 'package:flutter/material.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog(
      {Key key,
      this.items,
      this.initialSelectedValues,
      this.title,
      this.okButtonLabel,
      this.cancelButtonLabel,
      this.showSelectAll,
      this.selectAllText})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final List<V> initialSelectedValues;
  final String title;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final bool showSelectAll;
  final String selectAllText;
  bool selectAllState = false;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = List<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onSelectAllCheckedChange(bool checked) {
    setState(() {
      widget.selectAllState = checked;
      if (checked) {
        _selectedValues.removeRange(0, _selectedValues.length);
        _selectedValues.addAll(widget.items.map((e) => e.value));
      } else {
        _selectedValues.removeRange(0, _selectedValues.length);
      }
    });
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
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
            children: _buildList(),
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

  List<Widget> _buildList() {
    List<Widget> listBody = [];
    if (widget.showSelectAll) {
      listBody.add(
          _buildSelectAllItem(widget.selectAllState, widget.selectAllText));
    }
    listBody.addAll(widget.items.map(_buildItem));
    return listBody;
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }

  Widget _buildSelectAllItem(checked, title) {
    return CheckboxListTile(
      value: checked,
      title: Text(title),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onSelectAllCheckedChange(checked),
    );
  }
}
