/// أسعار التذاكر حسب عدد المحطات ونوع الراكب
class TicketFareInfo {
  final String category;
  final String stationRangeDescription;
  final int price;
  final String ticketColor;
  final String discountNote;

  const TicketFareInfo({
    required this.category,
    required this.stationRangeDescription,
    required this.price,
    required this.ticketColor,
    required this.discountNote,
  });
}

enum PassengerType {
  general,
  student,
  senior60to70,
  senior70Plus,
  disabled,
}

class FareCalculator {
  static TicketFareInfo calculateFare(int stationCount, PassengerType passengerType) {
    String category;
    String rangeDesc;
    int basePrice;
    String color;

    if (stationCount <= 9) {
      category = 'Zone 1';
      rangeDesc = 'Up to 9 stations';
      basePrice = 10;
      color = 'Yellow';
    } else if (stationCount <= 16) {
      category = 'Zone 2';
      rangeDesc = '10 to 16 stations';
      basePrice = 12;
      color = 'Green';
    } else if (stationCount <= 23) {
      category = 'Zone 3';
      rangeDesc = '17 to 23 stations';
      basePrice = 15;
      color = 'Red';
    } else {
      category = 'Zone 4';
      rangeDesc = 'More than 23 stations';
      basePrice = 20;
      color = 'Blue';
    }

    int finalPrice = basePrice;
    String note = 'Standard';

    switch (passengerType) {
      case PassengerType.senior70Plus:
        finalPrice = 0;
        note = 'Free Travel';
        break;
      case PassengerType.student:
      case PassengerType.disabled:
      case PassengerType.senior60to70:
        finalPrice = (basePrice * 0.5).ceil();
        note = 'Discounted Rate';
        break;
      case PassengerType.general:
        break;
    }

    return TicketFareInfo(
      category: category,
      stationRangeDescription: rangeDesc,
      price: finalPrice,
      ticketColor: color,
      discountNote: note,
    );
  }
}
