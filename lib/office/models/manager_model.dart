class Address {
  String zipCode;
  String address;
  String streetAddress;
  String detailAddress;

  Address({
    this.zipCode = '',
    this.address = '',
    this.streetAddress = '',
    this.detailAddress = '',
  });
}

class ManagerModel {
  String email;
  String phoneNumber;
  Address address;

  ManagerModel({required this.address, required this.email, required this.phoneNumber});

  ManagerModel copyWith({
    String? email,
    String? phoneNumber,
    Address? address,
  }) {
    return ManagerModel(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }
}

final dummyAddress = Address(
  zipCode: '566892',
  address: '서울특별시',
  streetAddress: '역삼 1동',
  detailAddress: 'A빌딩 303호',
);

final dummyManager = ManagerModel(
  email: 'no-reply@aaa.bbb',
  phoneNumber: '010-1234-5678',
  address: dummyAddress,
);
