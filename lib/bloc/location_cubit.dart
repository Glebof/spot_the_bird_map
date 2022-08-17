import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {

  LocationCubit() : super(const LocationInitial());

  Future<void> getLocation() async {

    LocationPermission permission = await Geolocator.requestPermission();
    
    if(permission != LocationPermission.denied || permission != LocationPermission.deniedForever) {
      emit(const LocationLoading());
    }
    
    try {

      Position position= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      emit(LocationLoaded(latitude: position.latitude, longitude: position.longitude, ));
      
    } catch (error) {
      print(error);
      emit(const LocationError());
    }
    
    // Get lat and long
  }
}