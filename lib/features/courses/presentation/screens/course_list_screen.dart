import 'package:flutter/material.dart';

import '../../data/datasources/courses_mock_datasource.dart';
import '../../data/repositories/courses_repository_impl.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/get_all_courses.dart';

import '../widgets/course_category_chip.dart';
import '../widgets/course_grid.dart';
import '../widgets/course_search_bar.dart';
import '../widgets/empty_courses_widget.dart';

import 'course_detail_screen.dart';

/// Displays the full course catalog: search, category filters,
/// and a responsive grid of courses.
///
/// Data is currently loaded through [GetAllCourses], manually wired to
/// [CoursesRepositoryImpl] and [CoursesMockDataSource]. This temporary
/// wiring will later move into the project's dependency injection layer
/// without affecting this screen's presentation logic.
class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() =>
      _CourseListScreenState();
}

class _CourseListScreenState
    extends State<CourseListScreen> {
  // TODO(eduva): Replace this manual wiring with Dependency Injection.
  late final GetAllCourses _getAllCourses =
      GetAllCourses(
    CoursesRepositoryImpl(
      const CoursesMockDataSource(),
    ),
  );

  bool _isLoading = true;

  List<CourseEntity> _allCourses = [];
  List<CourseEntity> _visibleCourses = [];

  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);

    final courses = await _getAllCourses();

    if (!mounted) return;

    final filtered = _filtered(courses);

    setState(() {
      _allCourses = courses;
      _visibleCourses = filtered;
      _isLoading = false;
    });
  }

  /// Returns the visible courses after applying
  /// search and category filters.
  List<CourseEntity> _filtered(
    List<CourseEntity> source,
  ) {
    final query = _searchQuery.trim().toLowerCase();

    final normalizedCategory =
        _selectedCategory?.trim().toLowerCase();

    return source.where((course) {
      final matchesQuery =
          query.isEmpty ||
          course.title
              .toLowerCase()
              .contains(query) ||
          course.instructorName
              .toLowerCase()
              .contains(query) ||
          course.category
              .toLowerCase()
              .contains(query);

      final matchesCategory =
          normalizedCategory == null ||
          course.category
                  .trim()
                  .toLowerCase() ==
              normalizedCategory;

      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _applyFilters() {
    setState(() {
      _visibleCourses = _filtered(_allCourses);
    });
  }

  void _onSearchQueryChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onCategorySelected(String category) {
    _selectedCategory =
        _selectedCategory == category
            ? null
            : category;

    _applyFilters();
  }
    /// Opens the selected course.
  void _onCourseTap(CourseEntity course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course,
        ),
      ),
    );
  }

  /// Clears the current search query and category filter.
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = null;
      _visibleCourses = _filtered(_allCourses);
    });
  }

  /// Returns all available categories in alphabetical order.
  List<String> get _categories {
    final categories = _allCourses
        .map((course) => course.category)
        .toSet()
        .toList();

    categories.sort(
      (a, b) =>
          a.toLowerCase().compareTo(
                b.toLowerCase(),
              ),
    );

    return categories;
  }

  bool get _hasActiveFilters =>
      _searchQuery.trim().isNotEmpty ||
      _selectedCategory != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 840,
            ),
            child: _isLoading
                ? const _LoadingState()
                : RefreshIndicator(
                    onRefresh: _loadCourses,
                    child: _buildContent(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CourseSearchBar(
          onQueryChanged:
              _onSearchQueryChanged,
        ),

        if (_categories.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildCategoryChips(),
        ],

        const SizedBox(height: 16),

        if (_visibleCourses.isEmpty)
          _buildEmptyState()
        else
          CourseGrid(
            courses: _visibleCourses,
            onCourseTap: _onCourseTap,
          ),
      ],
    );
  }
    Widget _buildEmptyState() {
    final isFilteredEmpty =
        _allCourses.isNotEmpty &&
        _hasActiveFilters;

    return Padding(
      padding: const EdgeInsets.only(
        top: 32,
      ),
      child: EmptyCoursesWidget(
        icon: isFilteredEmpty
            ? Icons.search_off_rounded
            : null,
        title: isFilteredEmpty
            ? 'No courses found'
            : 'No courses available',
        message: isFilteredEmpty
            ? 'No courses match your search. Try a different keyword or category.'
            : 'There are no courses to show right now. Please check back later.',
        actionLabel: isFilteredEmpty
            ? 'Clear filters'
            : null,
        onActionPressed: isFilteredEmpty
            ? _clearFilters
            : null,
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];

          return CourseCategoryChip(
            label: category,
            isSelected:
                category == _selectedCategory,
            onTap: () =>
                _onCategorySelected(category),
          );
        },
      ),
    );
  }
  }

/// Shown while [GetAllCourses] is loading.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
