import 'package:flutter/material.dart';
import '../domain/entities/post_location.dart';
import '../services/location_service.dart';

class LocationPickerWidget extends StatefulWidget {
  final PostLocation? selectedLocation;
  final bool isLoading;
  final VoidCallback onUseMyLocation;
  final void Function(PostLocation) onLocationSelected;
  final VoidCallback onRemove;

  const LocationPickerWidget({
    super.key,
    required this.selectedLocation,
    required this.isLoading,
    required this.onUseMyLocation,
    required this.onLocationSelected,
    required this.onRemove,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  final _searchController = TextEditingController();
  final _locationService = LocationService();
  List<PostLocation> _suggestions = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String value) async {
    if (value.trim().length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _isSearching = true);
    final results = await _locationService.searchLocations(value);
    setState(() {
      _suggestions = results;
      _isSearching = false;
    });
  }

  void _selectSuggestion(PostLocation location) {
    setState(() => _suggestions = []);
    _searchController.clear();
    widget.onLocationSelected(location);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedLocation != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on,
                color: Theme.of(context).colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.selectedLocation!.displayName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: widget.onRemove,
              child: Icon(Icons.close,
                  size: 18,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Pretraži lokaciju...",
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _isSearching
                      ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            widget.isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : IconButton(
              onPressed: widget.onUseMyLocation,
              icon: const Icon(Icons.my_location),
              tooltip: "Moja lokacija",
            ),
          ],
        ),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withOpacity(0.2),
              ),
              itemBuilder: (context, index) {
                final s = _suggestions[index];
                return ListTile(
                  dense: true,
                  leading:
                  const Icon(Icons.location_on_outlined, size: 18),
                  title:
                  Text(s.displayName, style: const TextStyle(fontSize: 13)),
                  onTap: () => _selectSuggestion(s),
                );
              },
            ),
          ),
      ],
    );
  }
}