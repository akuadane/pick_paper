export 'user_state.dart';
export 'user_event.dart';
export 'user_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pick_paper/user/bloc/user_event.dart';
import 'package:pick_paper/user/bloc/user_state.dart';
import 'package:pick_paper/user/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(SigningIn());

  @override
  Stream<UserState> mapEventToState(UserEvent event) {}
}
