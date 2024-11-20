import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreManagementService {
  final Ref ref;

  StoreManagementService(this.ref);
}

final storeManagementServiceProvider =
    Provider<StoreManagementService>((ref) => StoreManagementService(ref));
