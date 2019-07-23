import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/services/commute_service.dart';
import 'package:mbta_companion/src/state/actions/commuteActions.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchCommute() {
  return (Store store) async {
    Future(() async {
      store.dispatch(CommuteFetchPending());
      try {
        final commute = await CommuteService.getCommute();
        store.dispatch(CommuteFetchSuccess(commute));
      } catch (e) {
        print("$e");
        store.dispatch(CommuteFetchFailure(e));
      }
    });
  };
}

ThunkAction saveCommuteOp(Commute commute) {
  return (Store store) async {
    Future(() async {
      store.dispatch(CommuteSavePending());
      try {
        await CommuteService.saveCommute(commute);
        store.dispatch(CommuteFetchSuccess(commute));
      } catch (e) {
        print("$e");
        store.dispatch(CommuteSaveFailure(e));
      }
    });
  };
}

ThunkAction deleteCommuteOp(Commute commute) {
  return (Store store) async {
    Future(() async {
      store.dispatch(CommuteDeletePending());
      try {
        await CommuteService.deleteCommute(commute);
        store.dispatch(CommuteDeleteSuccess(commute));
      } catch (e) {
        print("$e");
        store.dispatch(CommuteDeleteFailure(e));
      }
    });
  };
}
