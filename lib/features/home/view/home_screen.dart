import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_app/features/home/view/widgets/hero_banner.dart';
import 'package:metro_app/features/home/view/widgets/map_card.dart';
import 'package:metro_app/features/home/view/widgets/nearest_card.dart';
import 'package:metro_app/features/home/view/widgets/station_sheet.dart';
import 'package:metro_app/features/home/view/widgets/trip_card.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_assets.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/main_navigation_shell.dart';
import '../models/station.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isArabic = true;
  bool _isNearestExpanded = false;
  Station? _pickupStation;
  Station? _arrivalStation;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openStationPicker({required bool isPickup}) async {
    final selected = await showModalBottomSheet<Station>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: StationSheet(
          title: isPickup
              ? (_isArabic ? 'محطة الركوب' : 'Departure Station')
              : (_isArabic ? 'محطة الوصول' : 'Arrival Station'),
          isArabic: _isArabic,
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        if (isPickup) {
          _pickupStation = selected;
        } else {
          _arrivalStation = selected;
        }
      });
    }
  }

  void _swapStations() {
    setState(() {
      final temp = _pickupStation;
      _pickupStation = _arrivalStation;
      _arrivalStation = temp;
    });
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        context.go(RouteNames.ticket);
        break;
      case 2:
        context.go(RouteNames.map);
        break;
      case 3:
        context.go(RouteNames.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentDirection = _isArabic ? TextDirection.rtl : TextDirection.ltr;
    final scrollbarDirection = _isArabic ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: contentDirection,
      child: Scaffold(
        appBar: CustomAppBar(
          isArabic: _isArabic,
          logoAssetPath: AppAssets.cairoMetroIcon,
          onLanguageChanged: (val) => setState(() => _isArabic = val),
        ),
        body: Directionality(
          textDirection: scrollbarDirection,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: Directionality(
              textDirection: contentDirection,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: 24.h),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        HeroBanner(isArabic: _isArabic),
                        Padding(
                          padding: EdgeInsets.only(top: 205.h),
                          child: TripCard(
                            pickupStation: _pickupStation,
                            arrivalStation: _arrivalStation,
                            isArabic: _isArabic,
                            onPickPickup: () => _openStationPicker(isPickup: true),
                            onPickArrival: () => _openStationPicker(isPickup: false),
                            onSwap: _swapStations,
                            onShowRoutes: () {
                              context.push(
                                RouteNames.booking,
                                extra: {
                                  'from': _pickupStation,
                                  'to': _arrivalStation,
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    NearestCard(
                      isExpanded: _isNearestExpanded,
                      isArabic: _isArabic,
                      onToggle: () =>
                          setState(() => _isNearestExpanded = !_isNearestExpanded),
                      onSelectStation: (station) {
                        setState(() => _pickupStation = station);
                      },
                    ),
                    SizedBox(height: 12.h),
                    MapCard(
                      isArabic: _isArabic,
                      onTap: () => context.go(RouteNames.map),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: MainNavigation(
          currentIndex: 0,
          isArabic: _isArabic,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}