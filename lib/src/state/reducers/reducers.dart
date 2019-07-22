import '../state.dart';
import 'allStopsReducer.dart';
import 'commuteReducer.dart';
import 'locationReducer.dart';
import 'savedStopsReducer.dart';
import 'nearbyStopsReducer.dart';

AppState appReducer(AppState state, action) => AppState(
    locationDataReducer(state.locationState, action),
    commuteReducer(state.commuteState, action),
    savedStopsReducer(state.savedStopsState, action),
    allStopsReducer(state.allStopsState, action),
    nearbyStopsReducer(state.nearbyStopsState, action));
