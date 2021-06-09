part of 'plan_entity.dart';

class PlanItineraryLeg {
  PlanItineraryLeg({
    this.rentedBike,
    this.points,
    this.mode,
    this.route,
    this.routeLongName,
    this.distance,
    this.duration,
    this.agency,
    this.toPlace,
    this.fromPlace,
    this.startTime,
    this.endTime,
    this.intermediatePlaces,
    this.intermediatePlace,
    this.transitLeg,
    this.pickupBookingInfo,
  }) {
    transportMode =
        getTransportMode(mode: mode, specificTransport: routeLongName);
  }

  static const _distance = "distance";
  static const _duration = "duration";
  static const _legGeometry = "legGeometry";
  static const _points = "points";
  static const _mode = "mode";
  static const _route = "route";
  static const _routeLongName = "routeLongName";
  static const _agency = "agency";
  static const _toPlace = "to";
  static const _fromPlace = "from";
  static const _startTime = "startTime";
  static const _endTime = "endTime";
  static const _intermediatePlaces = "intermediatePlaces";
  static const _intermediatePlace = "intermediatePlace";
  static const _transitLeg = "transitLeg";
  static const _rentedBike = "rentedBike";
  static const _pickupBookingInfo = "pickupBookingInfo";

  final String points;
  final String mode;
  final RouteEntity route;
  final String routeLongName;
  final double distance;
  final double duration;
  final AgencyEntity agency;
  final PlaceEntity toPlace;
  final PlaceEntity fromPlace;
  final DateTime startTime;
  final DateTime endTime;
  final bool transitLeg;
  final bool intermediatePlace;
  final bool rentedBike;
  final PickupBookingInfo pickupBookingInfo;
  // TODO research news LegMode like (BICYCLE_WALK, CITYBIKE)
  TransportMode transportMode;

  final List<PlaceEntity> intermediatePlaces;

  factory PlanItineraryLeg.fromJson(Map<String, dynamic> json) {
    return PlanItineraryLeg(
      points: json[_legGeometry][_points] as String,
      mode: json[_mode] as String,
      route: json[_route] != null
          ? RouteEntity.fromJson(json[_route] as Map<String, dynamic>)
          : null,
      routeLongName: json[_routeLongName] as String,
      distance: json[_distance] as double,
      duration: json[_duration] as double,
      agency: json[_agency] != null
          ? AgencyEntity.fromMap(json[_agency] as Map<String, dynamic>)
          : null,
      toPlace: json[_toPlace] != null
          ? PlaceEntity.fromMap(json[_toPlace] as Map<String, dynamic>)
          : null,
      fromPlace: json[_fromPlace] != null
          ? PlaceEntity.fromMap(json[_fromPlace] as Map<String, dynamic>)
          : null,
      startTime: json[_startTime] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(json[_startTime].toString()) ?? 0)
          : null,
      endTime: json[_endTime] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(json[_endTime].toString()) ?? 0)
          : null,
      intermediatePlaces: json[_intermediatePlaces] != null
          ? List<PlaceEntity>.from(
              (json[_intermediatePlaces] as List<dynamic>).map(
                (x) => PlaceEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      pickupBookingInfo: json[_pickupBookingInfo] != null
          ? PickupBookingInfo.fromMap(
              json[_pickupBookingInfo] as Map<String, dynamic>)
          : null,
      transitLeg: json[_intermediatePlace] as bool,
      intermediatePlace: json[_transitLeg] as bool,
      rentedBike: json[_rentedBike] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _legGeometry: {_points: points},
      _mode: mode,
      _route: route?.toJson(),
      _routeLongName: routeLongName,
      _distance: distance,
      _duration: duration,
      _agency: agency?.toMap(),
      _toPlace: toPlace?.toMap(),
      _fromPlace: fromPlace?.toMap(),
      _startTime: startTime?.millisecondsSinceEpoch,
      _endTime: endTime?.millisecondsSinceEpoch,
      _intermediatePlaces: intermediatePlaces != null
          ? List<dynamic>.from(intermediatePlaces.map((x) => x.toMap()))
          : null,
      _pickupBookingInfo: pickupBookingInfo?.toMap(),
      _intermediatePlace: intermediatePlace,
      _transitLeg: transitLeg,
      _rentedBike: rentedBike,
    };
  }

  PlanItineraryLeg copyWith({
    String points,
    String mode,
    RouteEntity route,
    String routeLongName,
    double distance,
    double duration,
    PlaceEntity toPlace,
    PlaceEntity fromPlace,
    DateTime startTime,
    DateTime endTime,
    bool rentedBike,
    bool intermediatePlace,
    bool transitLeg,
    List<PlaceEntity> intermediatePlaces,
    PickupBookingInfo pickupBookingInfo,
  }) {
    return PlanItineraryLeg(
      points: points ?? this.points,
      mode: mode ?? this.mode,
      route: route ?? this.route,
      routeLongName: routeLongName ?? this.routeLongName,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      toPlace: toPlace ?? this.toPlace,
      fromPlace: fromPlace ?? this.fromPlace,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      rentedBike: rentedBike ?? this.rentedBike,
      intermediatePlace: intermediatePlace ?? this.intermediatePlace,
      transitLeg: transitLeg ?? this.transitLeg,
      intermediatePlaces: intermediatePlaces ?? this.intermediatePlaces,
      pickupBookingInfo: pickupBookingInfo ?? this.pickupBookingInfo,
    );
  }

  String toInstruction(TrufiLocalization localization) {
    final StringBuffer sb = StringBuffer();
    if (transportMode == TransportMode.walk) {
      sb.write(localization.instructionWalk(_durationString(localization),
          distanceString(localization), _toString(localization)));
    } else {
      sb.write(localization.instructionRide(
          transportMode.getTranslate(localization) +
              (route?.shortName != null ? " ${route.shortName}" : ""),
          _durationString(localization),
          distanceString(localization),
          _toString(localization)));
    }
    return sb.toString();
  }

  String distanceString(TrufiLocalization localization) =>
      displayDistanceWithLocale(
        localization,
        distance,
      );

  String get startTimeString => durationToHHmm(startTime);

  String get endTimeString => durationToHHmm(endTime);

  String durationLeg(TrufiLocalization localization) =>
      durationToString(localization, Duration(seconds: duration.toInt()));

  String _toString(TrufiLocalization localization) {
    return toPlace?.name == 'Destination'
        ? localization.commonDestination
        : toPlace?.name;
  }

  String _durationString(TrufiLocalization localization) {
    final value = (duration.ceil() / 60).ceil();
    return localization.instructionDurationMinutes(value);
  }

  IconData get iconData => transportMode.icon;
}
