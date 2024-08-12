library multiselect;

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class _TheState {}

var _theState = RM.inject(() => _TheState());

class RowWrapper extends InheritedWidget {
  final dynamic data;
  final bool Function() shouldNotify;
  RowWrapper({
    required Widget child,
    this.data,
    required this.shouldNotify,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;

  const _SelectRow({
    Key? key,
    required this.onChange,
    required this.selected,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!selected);
        _theState.notify();
      },
      child: Container(
        height: kMinInteractiveDimension,
        child: Row(
          children: [
            Checkbox(
                value: selected,
                onChanged: (x) {
                  onChange(x!);
                  _theState.notify();
                }),
            Text(text)
          ],
        ),
      ),
    );
  }
}

///
/// A Dropdown multiselect menu
///
///
class DropDownMultiSelect<T> extends StatefulWidget {
  /// The options form which a user can select
  final List<T> options;

  /// Selected Values
  final List<T> selectedValues;

  /// This function is called whenever a value changes
  final Function(List<T>) onChanged;

  /// defines whether the field is dense
  final bool isDense;

  /// defines whether the widget is enabled;
  final bool enabled;

  /// Input decoration
  final InputDecoration? decoration;

  /// this text is shown when there is no selection
  final String? whenEmpty;

  /// a function to build custom childern
  final Widget Function(List<T> selectedValues)? childBuilder;

  /// a function to build custom menu items
  final Widget Function(T option)? menuItembuilder;

  /// a function to validate
  final String Function(int? selectedOptions)? validator;

  /// defines whether the widget is read-only
  final bool readOnly;

  /// icon shown on the right side of the field
  final Widget? icon;

  /// Textstyle for the hint
  final TextStyle? hintStyle;

  /// hint to be shown when there's nothing else to be shown
  final Widget? hint;

  /// selectedValue separator
  final String separator;

  /// style for the selected values
  final TextStyle? selectedValuesStyle;

  const DropDownMultiSelect({
    Key? key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.whenEmpty,
    this.icon,
    this.hint,
    this.hintStyle,
    this.childBuilder,
    this.selectedValuesStyle,
    this.menuItembuilder,
    this.isDense = true,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.readOnly = false,
    this.separator = ' , ',
  }) : super(key: key);

  @override
  _DropDownMultiSelectState createState() => _DropDownMultiSelectState<T>();
}

class _DropDownMultiSelectState<TState>
    extends State<DropDownMultiSelect<TState>> {
  late final List<(int, TState)> uniqueOptions = [];
  late final List<(int, TState)> selectedValues = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.options.length; i++) {
      uniqueOptions.add((i, widget.options[i]));
    }
    if (widget.selectedValues.isNotEmpty) {
      for (int i = 0; i < widget.options.length; i++) {
        selectedValues.add((i, widget.selectedValues[i]));
      }
    }
  }

  @override
  void didUpdateWidget(covariant DropDownMultiSelect<TState> oldWidget) {
    super.didUpdateWidget(oldWidget);
    uniqueOptions.clear();
    selectedValues.clear();
    for (int i = 0; i < widget.options.length; i++) {
      uniqueOptions.add((i, widget.options[i]));
    }
    if (widget.selectedValues.isNotEmpty) {
      for (int i = 0; i < widget.options.length; i++) {
        selectedValues.add((i, widget.selectedValues[i]));
      }
    }
  }

  @override
  void dispose() {
    uniqueOptions.clear();
    selectedValues.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            child: DropdownButtonFormField<int>(
              hint: widget.hint,
              style: widget.hintStyle,
              icon: widget.icon,
              validator: widget.validator != null ? widget.validator : null,
              decoration: widget.decoration != null
                  ? widget.decoration
                  : InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
              isDense: widget.isDense,
              onChanged: widget.enabled ? (x) {} : null,
              isExpanded: false,
              value: selectedValues.isNotEmpty ? selectedValues[0].$1 : null,
              selectedItemBuilder: (context) {
                return uniqueOptions
                    .map((e) => DropdownMenuItem(child: Container()))
                    .toList();
              },
              items: uniqueOptions
                  .map(
                    (x) => DropdownMenuItem<int>(
                      child: _theState.rebuild(() {
                        return widget.menuItembuilder != null
                            ? widget.menuItembuilder!(x.$2)
                            : _SelectRow(
                                selected: selectedValues.contains(x),
                                text: x.$2.toString(),
                                onChange: (isSelected) {
                                  if (isSelected) {
                                    var ns = selectedValues;
                                    ns.add(x);
                                    widget.onChanged(List<TState>.generate(
                                        ns.length, (index) => ns[index].$2));
                                  } else {
                                    var ns = selectedValues;
                                    ns.remove(x);
                                    widget.onChanged(List<TState>.generate(
                                        ns.length, (index) => ns[index].$2));
                                  }
                                },
                              );
                      }),
                      value: x.$1,
                      onTap: !widget.readOnly
                          ? () {
                              if (selectedValues.contains(x)) {
                                var ns = selectedValues;
                                ns.remove(x);
                                widget.onChanged(List<TState>.generate(
                                    ns.length, (index) => ns[index].$2));
                              } else {
                                var ns = selectedValues;
                                ns.add(x);
                                widget.onChanged(List<TState>.generate(
                                    ns.length, (index) => ns[index].$2));
                              }
                            }
                          : null,
                    ),
                  )
                  .toList(),
            ),
          ),
          _theState.rebuild(() => widget.childBuilder != null
              ? widget.childBuilder!(widget.selectedValues)
              : Padding(
                  padding: widget.decoration != null
                      ? widget.decoration!.contentPadding != null
                          ? widget.decoration!.contentPadding!
                          : EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      widget.selectedValues.length > 0
                          ? widget.selectedValues
                              .map((e) => e.toString())
                              .reduce(
                                  (a, b) => a.toString() + ' , ' + b.toString())
                          : widget.whenEmpty ?? '',
                      style: widget.selectedValuesStyle
                          ?.copyWith(overflow: TextOverflow.ellipsis),
                    ),
                  ))),
        ],
      ),
    );
  }
}
