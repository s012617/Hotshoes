import 'package:get_it/get_it.dart';
import 'package:new_buffalo_pos/scope_model/login_view_model.dart';
import 'package:new_buffalo_pos/scope_model/purchase_model.dart';
import 'package:new_buffalo_pos/scope_model/return_model.dart';
import 'package:new_buffalo_pos/scope_model/sale_model.dart';
import 'package:new_buffalo_pos/scope_model/stock_model.dart';
import 'package:new_buffalo_pos/scope_model/sync_model.dart';
import 'package:new_buffalo_pos/services/api_service.dart';
import 'package:new_buffalo_pos/utils/token_helper.dart';

import 'scope_model/purchase_return_view_model.dart';

GetIt locator = new GetIt();

void setupLocator() {
  // Register services

  locator.registerLazySingleton<TokenHelper>(() => TokenHelper());
  locator.registerLazySingleton<APIService>(() => APIService());
  // Register ScopedModels\
  locator.registerFactory<LoginViewModel>(() => LoginViewModel());
  locator.registerFactory<SaleViewModel>(() => SaleViewModel());
  locator.registerFactory<ReturnViewModel>(() => ReturnViewModel());
  locator.registerFactory<PurchaseReturnViewModel>(
      () => PurchaseReturnViewModel());
  locator.registerFactory<PurchaseModel>(() => PurchaseModel());
  locator.registerFactory<StockModel>(() => StockModel());
  locator.registerFactory<SyncModel>(() => SyncModel());
}
