import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/office/models/manager_model.dart';

sealed class ManagerEvent {}

class EditEmail extends ManagerEvent {
  final String email;

  EditEmail(this.email);
}

class EditPhoneNumber extends ManagerEvent {
  final String phoneNumber;

  EditPhoneNumber(this.phoneNumber);
}

class ManagerState {
  ManagerModel? manager;

  ManagerState({this.manager});
}

class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  ManagerBloc() : super(ManagerState(manager: dummyManager)) {
    on<EditEmail>(_editEmail);
    on<EditPhoneNumber>(_editPhoneNumber);
  }

  Future<void> _editEmail(EditEmail event, Emitter<ManagerState> emit) async {
    final newManager = state.manager?.copyWith(
      email: event.email,
    );

    return emit(ManagerState(manager: newManager));
  }

  Future<void> _editPhoneNumber(EditPhoneNumber event, Emitter<ManagerState> emit) async {
    final newManager = state.manager?.copyWith(
      phoneNumber: event.phoneNumber,
    );

    return emit(ManagerState(manager: newManager));
  }
}
