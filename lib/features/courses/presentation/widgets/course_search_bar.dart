import 'dart:async';
import 'package:flutter/material.dart';

/// A search input specialized for the Courses feature.
///
/// Handles its own TextEditingController and debounces user input
/// before notifying the parent widget.
class CourseSearchBar extends StatefulWidget {
  final ValueChanged<String> onQueryChanged;
  final String hintText;

  const CourseSearchBar({
    super.key,
    required this.onQueryChanged,
    this.hintText = 'Search courses, instructors...',
  });

  @override
  State<CourseSearchBar> createState() => _CourseSearchBarState();
}

class _CourseSearchBarState extends State<CourseSearchBar> {
  final TextEditingController _controller = TextEditingController();

  static const Duration _debounceDuration =
      Duration(milliseconds: 350);

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(_debounceDuration, () {
      widget.onQueryChanged(value);
    });

    setState(() {});
  }

  void _clear() {
    _controller.clear();
    _debounce?.cancel();
    widget.onQueryChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: _clear,
              )
            : null,
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}