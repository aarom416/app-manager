class StoreA11y {
  final bool isParkingFree;
  final bool isValetParkingSupported;
  final List<String> availableServices;

  StoreA11y({required this.isParkingFree, required this.isValetParkingSupported, required this.availableServices});

  StoreA11y copyWith({bool? isParkingFree, bool? isValetParkingSupported, List<String>? availableServices}) {
    return StoreA11y(
      isParkingFree: isParkingFree ?? this.isParkingFree,
      isValetParkingSupported: isValetParkingSupported ?? this.isValetParkingSupported,
      availableServices: availableServices ?? this.availableServices,
    );
  }
}

class StoreModel {
  final String id;
  final String name;
  String? introduction;
  String? address;
  String? phoneNumber;
  StoreA11y? a11y;

  StoreModel({required this.id, required this.name, this.introduction, this.address, this.phoneNumber, this.a11y});

  StoreModel copyWith(
      {String? id, String? name, String? introduction, String? address, String? phoneNumber, StoreA11y? a11y}) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      introduction: introduction ?? this.introduction,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      a11y: a11y ?? this.a11y,
    );
  }
}
