import 'package:mbta_companion/src/models/commute.dart';

class CommuteFetchSuccess {
  final Commute commute;

  CommuteFetchSuccess(this.commute);
}

class CommuteFetchPending {}

class CommuteFetchFailure {
  final String commuteErrorMessage;

  CommuteFetchFailure(this.commuteErrorMessage);
}
