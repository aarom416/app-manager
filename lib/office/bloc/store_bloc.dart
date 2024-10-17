import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/office/models/store_model.dart';

sealed class StoreEvent {}

class EditStoreInformation extends StoreEvent {
  final StoreModel store;

  EditStoreInformation(this.store);
}

class StoreState {
  StoreModel? store;

  StoreState({this.store});

  StoreState copyWith({StoreModel? store}) {
    return StoreState(store: store ?? this.store);
  }
}

final dummyStore = StoreModel(
  id: "store-001",
  name: '샐러디 역삼점',
  phoneNumber: '010-1234-5678',
  a11y: StoreA11y(
    isParkingFree: true,
    isValetParkingSupported: true,
    availableServices: ['반려동물 동반', '좌식'],
  ),
);

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState(store: dummyStore)) {
    on<EditStoreInformation>(_editStoreInformation);
  }

  Future<void> _editStoreInformation(EditStoreInformation event, Emitter<StoreState> emit) async {
    final newStore = event.store;

    return emit(StoreState(store: newStore));
  }
}
