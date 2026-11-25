# Metro app improvements in this copy

This is an updated copy of the uploaded Flutter source, preserving the existing visual design and assets.

## Included changes
- Station catalog expanded to 84 unique stations across operational Lines 1, 2, and 3. Shared interchange stations appear once and carry multiple line IDs.
- Station picker shows the total station count and a no-results message.
- Station coordinates are nullable; nearest-station calculation skips stations without coordinates and sorts using full precision.
- Added mounted checks around async location flow and a clear empty state.
- App language is shared between Home, Map, Tickets, and Settings during the current app session.
- Map/Tickets/Settings now use a consistent bottom navigation.
- Booking route uses typed `BookingArguments` rather than an unsafe Map cast.
- Added simple booking/tickets/settings placeholder screens with honest UI-only status.
- Excluded local build/cache files from this archive.

## Station data and coordinate caveat
The station names and operational line assignments are based on Cairo Governorate and National Authority for Tunnels public station lists. The project currently retains the coordinate values that were already in the prototype for 25 stations; these values have not been independently verified in this update. The remaining stations have null coordinates. Therefore, nearest-station results are provisional and only calculated among stations with coordinates. Before production use, populate and verify coordinates for all stations from a licensed geospatial dataset (for example, Transport for Cairo's Metro Stops dataset, CC BY 4.0) and include its attribution.

## Verify on your machine
From the project folder run:

```bash
flutter pub get
flutter analyze
flutter run
```

I could not run Flutter analysis in this environment because the Flutter/Dart SDK is not installed here.

## Google Maps station shortcut and coordinate review

The nearest-stations list now has a map icon for each result. Tapping it opens a Google Maps search for the station name (with Cairo Metro/Egypt context). It uses a name-based search intentionally while station coordinates are still under review, avoiding reliance on potentially inaccurate coordinates for the map marker.

The nearest-station calculation is provisional: it only considers stations that currently have coordinates. The complete station list contains 84 stations, but their coordinates must be verified against a reliable source before the feature is considered production-ready.
