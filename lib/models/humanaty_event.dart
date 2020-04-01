import 'package:humanaty/models/models.dart';

class HumanatyEvent{
  final bool accessibilityAccommodations;
  final String additionalInfo;
  final List allergies;
  final List attendees;
  final double costPerSeat;
  final DateTime date;
  final String description;
  final int guestNum;
  final String hostID;
  final HumanatyLocation location;
  final String meal;
  final List photoGallery;
  final String title;

  HumanatyEvent({
    this.accessibilityAccommodations,
    this.additionalInfo,
    this.allergies,
    this.attendees,
    this.costPerSeat,
    this.date,
    this.description,
    this.guestNum,
    this.hostID,
    this.location,
    this.meal,
    this.photoGallery,
    this.title
  });
}