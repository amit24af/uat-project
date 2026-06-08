// class LocationCubit extends Cubit<LocationState> {
//   final LocationRepo locationRepo;
//
//   LocationCubit(this.locationRepo) : super(LocationInitial());
//
//   Future<void> searchLocation(String query) async {
//     if (query.isEmpty) return;
//
//     emit(LocationLoading());
//     try {
//       final results = await locationRepo.searchPlaces(query);
//       emit(LocationLoaded(results));
//     } catch (e) {
//       emit(LocationError(e.toString()));
//     }
//   }
//
//   Future<void> useCurrentLocation() async {
//     emit(LocationLoading());
//     try {
//       final location = await locationRepo.getCurrentLocation();
//       emit(LocationSelected(location));
//     } catch (e) {
//       emit(LocationError(e.toString()));
//     }
//   }
// }