import 'package:loyaltri_minimal/models/user_profile_api_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/services/flutter_secure_storage.dart';

class SyncManager {
  Future<void> fetchTokenInBG() async {
    final userData = await SecureStorageUtils().getUserData();
    String? companyId;
    final UserProfileApiModel? profileData = await SecureStorageUtils()
        .getProfileData();
    if (profileData != null) {
      companyId = profileData.result.companyId;
    }
    final initResp = await ApiServices.getTokenInBG(
      username: userData?.userData?.email,
      compId: companyId,
    );
    if (initResp?['result'] != null &&
        initResp?['result'] is String &&
        (initResp?['result'].toString().trim().isNotEmpty ?? false)) {
      userData?.userData?.token = initResp?['result'];
      await SecureStorageUtils().removeUserData();
      await SecureStorageUtils().setUserData(userData!.toJson());
    }
  }
}
