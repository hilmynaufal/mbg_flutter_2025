import 'package:flutter/material.dart';
import '../../data/models/form_field_model.dart';
import '../../data/models/desa_model.dart';
import '../../data/regional_data.dart';

class SearchableDropdown extends StatefulWidget {
  final FormFieldModel field;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final Map<int, dynamic>? formValues;

  const SearchableDropdown({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
    this.validator,
    this.formValues,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, String>> _filteredOptions = [];
  List<Map<String, String>> _allOptions = [];
  bool _isDropdownOpen = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initializeOptions();
    _updateSearchText();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Validate when focus is lost
        setState(() {
          _errorText = widget.validator?.call(widget.value);
        });
      }
    });
  }

  @override
  void didUpdateWidget(SearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateSearchText();
    }
    if (oldWidget.formValues != widget.formValues) {
      _initializeOptions();
      _filterOptions(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Check if this is a Kecamatan field
  bool get _isKecamatanField {
    final text = widget.field.questionText.toLowerCase();
    return text.contains('kecamatan');
  }

  /// Check if this is a Desa/Kelurahan field
  bool get _isDesaField {
    final text = widget.field.questionText.toLowerCase();
    return text.contains('desa') || text.contains('kelurahan');
  }

  /// Get selected kecamatan name from form values
  String? _getSelectedKecamatanName() {
    if (widget.formValues == null) return null;

    for (var f in RegionalData.kecamatanList) {
      for (var entry in widget.formValues!.entries) {
        final val = entry.value;
        if (val is String && val.toUpperCase() == f.nmKec.toUpperCase()) {
          return f.nmKec;
        }
      }
    }
    return null;
  }

  /// Get desa list filtered by kecamatan name
  List<DesaModel> _getDesaByKecamatanName(String kecamatanName) {
    final kec = RegionalData.kecamatanList.firstWhere(
      (k) => k.nmKec.toUpperCase() == kecamatanName.toUpperCase(),
      orElse: () => RegionalData.kecamatanList.first,
    );
    return RegionalData.getDesaByKecamatan(kec.idKec);
  }

  void _initializeOptions() {
    if (_isKecamatanField) {
      _allOptions = RegionalData.kecamatanList
          .map((kec) => {'value': kec.nmKec.toUpperCase(), 'label': kec.nmKec})
          .toList();
    } else if (_isDesaField) {
      final selectedKecName = _getSelectedKecamatanName();
      final desaData = selectedKecName != null
          ? _getDesaByKecamatanName(selectedKecName)
          : RegionalData.desaList;

      _allOptions = desaData
          .map((desa) =>
              {'value': desa.nmDesa.toUpperCase(), 'label': desa.nmDesa})
          .toList();
    } else {
      final apiOptions = widget.field.options ?? [];
      _allOptions = apiOptions.map((option) {
        if (option is Map) {
          return {
            'value': option['value']?.toString() ?? '',
            'label': option['label']?.toString() ??
                option['value']?.toString() ??
                '',
          };
        } else {
          return {
            'value': option.toString(),
            'label': option.toString(),
          };
        }
      }).toList();
    }

    _filteredOptions = List.from(_allOptions);
  }

  void _updateSearchText() {
    if (widget.value != null && widget.value!.isNotEmpty) {
      // Find the label for the current value
      final option = _allOptions.firstWhere(
        (opt) => opt['value'] == widget.value,
        orElse: () => {'value': widget.value!, 'label': widget.value!},
      );
      _searchController.text = option['label'] ?? widget.value!;
    } else {
      _searchController.text = '';
    }
  }

  void _filterOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = List.from(_allOptions);
      } else {
        _filteredOptions = _allOptions.where((option) {
          final label = option['label']?.toLowerCase() ?? '';
          final value = option['value']?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return label.contains(searchQuery) || value.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _selectOption(Map<String, String> option) {
    final value = option['value'];
    final label = option['label'] ?? value;

    _searchController.text = label ?? '';
    widget.onChanged(value);

    setState(() {
      _isDropdownOpen = false;
      _errorText = widget.validator?.call(value);
    });

    _focusNode.unfocus();
  }

  void _clearSelection() {
    _searchController.clear();
    widget.onChanged(null);
    setState(() {
      _filteredOptions = List.from(_allOptions);
      _errorText = widget.validator?.call(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        RichText(
          text: TextSpan(
            text: widget.field.questionText,
            style: theme.textTheme.labelLarge,
            children: [
              if (widget.field.validationRules.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
        if (widget.field.questionDescription != null &&
            widget.field.questionDescription!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            widget.field.questionDescription!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
        const SizedBox(height: 8),

        // Search field with dropdown
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isDropdownOpen = hasFocus && _filteredOptions.isNotEmpty;
            });
          },
          child: TextFormField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.field.questionPlaceholder ??
                  'Cari ${widget.field.questionText}...',
              errorText: _errorText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.value != null && widget.value!.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSelection,
                    )
                  : const Icon(Icons.arrow_drop_down),
            ),
            onChanged: (value) {
              _filterOptions(value);
              setState(() {
                _isDropdownOpen = true;
              });
            },
            onTap: () {
              setState(() {
                _isDropdownOpen = true;
              });
            },
            validator: (value) {
              // Use the actual selected value for validation, not the search text
              return widget.validator?.call(widget.value);
            },
          ),
        ),

        // Dropdown options list
        if (_isDropdownOpen && _filteredOptions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                final label = option['label'] ?? '';
                final value = option['value'] ?? '';
                final isSelected = value == widget.value;

                return InkWell(
                  onTap: () => _selectOption(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : null,
                      border: Border(
                        bottom: index < _filteredOptions.length - 1
                            ? BorderSide(color: theme.dividerColor)
                            : BorderSide.none,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isSelected ? theme.colorScheme.primary : null,
                              fontWeight: isSelected ? FontWeight.w600 : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Show "No results" message
        if (_isDropdownOpen &&
            _filteredOptions.isEmpty &&
            _searchController.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Text(
              'Tidak ada hasil ditemukan',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
