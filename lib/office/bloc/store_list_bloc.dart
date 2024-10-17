import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/office/models/store_model.dart';

sealed class StoreListEvent {}

class ChangeActiveStore extends StoreListEvent {
  final String storeId;

  ChangeActiveStore(this.storeId);
}

List<StoreModel> dummyStores = [
  StoreModel(id: "store-001", name: "샐러디 역삼점"),
  StoreModel(id: "store-002", name: "샐러디 강남점"),
  StoreModel(id: "store-003", name: "샐러디 신논현점"),
];

class StoreListState {
  final String? activeStoreId;
  final List<StoreModel> stores;

  StoreModel get activeStore => stores.where((store) => store.id == activeStoreId).firstOrNull ?? stores.first;

  copyWith({String? activeStoreId, List<StoreModel>? stores}) {
    return StoreListState(activeStoreId: activeStoreId, stores: stores ?? this.stores);
  }

  StoreListState({this.activeStoreId, this.stores = const []});
}

class StoreListBloc extends Bloc<StoreListEvent, StoreListState> {
  StoreListBloc() : super(StoreListState(stores: dummyStores)) {
    on<ChangeActiveStore>(_changeActiveStore);
  }

  Future<void> _changeActiveStore(ChangeActiveStore event, Emitter<StoreListState> emit) async {
    return emit(state);
  }
}
