class PostLocation {
  final String displayName;
  final double latitude;
  final double longitude;

  const PostLocation({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory PostLocation.fromJson(Map<String, dynamic> json) {
    return PostLocation(
      displayName: json['displayName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  @override
  String toString() => displayName;
}