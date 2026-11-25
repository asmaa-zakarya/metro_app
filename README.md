# metro_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Cairo Metro station data

The station picker includes the 84 unique stations across the three operational lines (Line 1: 35, Line 2: 20, Line 3: 34; shared interchange stations are stored once with multiple line IDs). The station list is based on Cairo Governorate and National Authority for Tunnels public station lists.

Station coordinates are nullable and are intentionally not fabricated. The current project carries forward the coordinates that were already present in the prototype; nearest-station calculation only uses records with coordinates. Before using nearest-station results as production navigation, replace/verify the coordinate coverage using a licensed geospatial dataset such as Transport for Cairo's Metro Stops dataset (CC BY 4.0) and attribute it accordingly.
