import 'package:mbta_companion/src/models/vehicle.dart';

class VehiclesFetchSuccess {
  final List<Vehicle> vehicles;

  VehiclesFetchSuccess(this.vehicles);
}

class VehiclesFetchPending {}

class VehiclesFetchFailure {
  final String vehiclesErrorMessage;

  VehiclesFetchFailure(this.vehiclesErrorMessage);
}
