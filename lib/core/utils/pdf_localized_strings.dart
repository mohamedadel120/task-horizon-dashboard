import 'package:flutter/material.dart';

/// Holds all localized strings needed for PDF generation
class PdfLocalizedStrings {
  final String contractTitle;
  final String contractDetails;
  final String rentalType;
  final String rentalPeriod;
  final String rentalDate;
  final String endDate;
  final String securityDeposit;
  final String currencySar;
  final String renterInfo;
  final String lessorInfo;
  final String name;
  final String phoneNumber;
  final String identityNumber;
  final String city;
  final String productImages;
  final String noImagesAvailable;
  final String noImage;
  final String termsTitle;
  final String appName;
  final String appNameAr;

  // Rental types
  final String hourly;
  final String daily;
  final String monthly;
  final String yearly;

  // Duration units
  final String dayUnit;
  final String monthUnit;
  final String yearUnit;

  // Months
  final List<String> months;

  // Terms list
  final List<String> terms;

  PdfLocalizedStrings({
    required this.contractTitle,
    required this.contractDetails,
    required this.rentalType,
    required this.rentalPeriod,
    required this.rentalDate,
    required this.endDate,
    required this.securityDeposit,
    required this.currencySar,
    required this.renterInfo,
    required this.lessorInfo,
    required this.name,
    required this.phoneNumber,
    required this.identityNumber,
    required this.city,
    required this.productImages,
    required this.noImagesAvailable,
    required this.noImage,
    required this.termsTitle,
    required this.appName,
    required this.appNameAr,
    required this.hourly,
    required this.daily,
    required this.monthly,
    required this.yearly,
    required this.dayUnit,
    required this.monthUnit,
    required this.yearUnit,
    required this.months,
    required this.terms,
  });

  /// Create from BuildContext using app localizations
  factory PdfLocalizedStrings.fromContext(BuildContext context) {
    // Requires l10n generation which is currently disabled/missing
    return PdfLocalizedStrings(
      contractTitle: 'Contract Title',
      contractDetails: 'Contract Details',
      rentalType: 'Rental Type',
      rentalPeriod: 'Rental Period',
      rentalDate: 'Rental Date',
      endDate: 'End Date',
      securityDeposit: 'Security Deposit',
      currencySar: 'SAR',
      renterInfo: 'Renter Info',
      lessorInfo: 'Lessor Info',
      name: 'Name',
      phoneNumber: 'Phone Number',
      identityNumber: 'Identity Number',
      city: 'City',
      productImages: 'Product Images',
      noImagesAvailable: 'No Images Available',
      noImage: 'No Image',
      termsTitle: 'Terms & Conditions',
      appName: 'task',
      appNameAr: 'ØªÙˆÙ„Øª',
      hourly: 'Hourly',
      daily: 'Daily',
      monthly: 'Monthly',
      yearly: 'Yearly',
      dayUnit: 'Day',
      monthUnit: 'Month',
      yearUnit: 'Year',
      months: [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
      terms: [
        'Term 1',
        'Term 2',
        'Term 3',
        'Term 4',
        'Term 5',
        'Term 6',
        'Term 7',
        'Term 8',
      ],
    );
  }
}
