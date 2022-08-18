import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/bird_post_model.dart';

part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit():super(BirdPostState(birdPosts: [], status:BirdPostStatus.initial));

  void addBirdPost(BirdModel birdModel){
    emit(state.copyWith(status: BirdPostStatus.loading));

    List<BirdModel> birsPosts = state.birdPosts;

    birsPosts.add(birdModel);

    emit(state.copyWith(birdPosts: birsPosts, status: BirdPostStatus.loaded));
  }

}