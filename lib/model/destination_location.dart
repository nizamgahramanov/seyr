class DestinationLocation {
  final double latitude;
  final double longitude;
  final String? address;
  const DestinationLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}