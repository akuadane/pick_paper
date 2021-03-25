export 'user_state.dart';
export 'user_event.dart';
export 'user_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pick_paper/user/bloc/user_event.dart';
import 'package:pick_paper/user/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserState initialState) : super(SigningIn());
}
