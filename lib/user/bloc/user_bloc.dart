import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pick_paper/user/bloc/user_event.dart';
import 'package:pick_paper/user/bloc/user_state.dart';
import 'package:pick_paper/user/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(SigningIn());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is CreateUser) {
      this.userRepository.createUser(event.phoneNumber, event.uid);
      try {
        QueryDocumentSnapshot user =
            await this.userRepository.getUser(event.uid);
        yield SignedIn(user);
      } catch (e) {
        yield SignInError();
      }
    } else if (event is GetUser) {
      try {
        QueryDocumentSnapshot user =
            await this.userRepository.getUser(event.uid);
        yield SignedIn(user);
      } catch (e) {
        yield SignInError();
      }
    } else if (event is UploadProfilePicture) {
      try {
        String photoURL = await this
            .userRepository
            .uploadProfilePicture(event.image, event.userDocId);
        this
            .userRepository
            .updateUser({"profilePictureURL": photoURL}, event.userDocId);

        QueryDocumentSnapshot user =
            await this.userRepository.getUser(event.uid);
        yield SignedIn(user);
      } catch (e) {
        yield UploadingPhotoError();
      }
    } else if (event is UpdateUser) {
      this.userRepository.updateUser(event.tobeUpdated, event.userDocId);
      QueryDocumentSnapshot user = await this.userRepository.getUser(event.uid);
      yield SignedIn(user);
    }
  }
}
