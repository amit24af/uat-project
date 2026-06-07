import 'package:flutter/material.dart';

import '../domain/entities/post_location.dart';

class LocationPickerWidget extends StatelessWidget {
  final PostLocation? selectedLocation;
  final bool isLoading;
  final VoidCallback onUseMyLocation;
  final VoidCallback onEnterManually;
  final VoidCallback onRemove;

  const LocationPickerWidget({
    super.key,
    required this.selectedLocation,
    required this.isLoading,
    required this.onUseMyLocation,
    required this.onEnterManually,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Getting location...",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (selectedLocation != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on,
                color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLocation!.displayName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (selectedLocation!.latitude != 0)
                    Text(
                      "${selectedLocation!.latitude.toStringAsFixed(4)}, "
                          "${selectedLocation!.longitude.toStringAsFixed(4)}",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4),
                size: 18,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onUseMyLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.my_location,
                      color: Theme.of(context).colorScheme.primary, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    "Use my location",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onEnterManually,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.edit_location_alt,
                      color: Theme.of(context).colorScheme.primary, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    "Enter manually",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}