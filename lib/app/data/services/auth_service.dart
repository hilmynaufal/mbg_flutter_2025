import 'package:get/get.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'storage_service.dart';
import '../../core/values/constants.dart';

class AuthService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthProvider _authProvider = AuthProvider();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  // Load user from storage on app start
  void _loadUserFromStorage() {
    final isLoggedIn = _storageService.readBool(AppConstants.keyIsLoggedIn) ?? false;
    if (isLoggedIn) {
      final userData = _storageService.readObject(AppConstants.keyUser);
      if (userData != null) {
        _currentUser.value = UserModel.fromJson(userData);
        _isLoggedIn.value = true;
      }
    }
  }

  // Login method
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _authProvider.login(
        username: username,
        password: password,
      );

      if (response.isSuccess && response.user != null) {
        // Save user data
        _currentUser.value = response.user;
        await _storageService.writeObject(
          AppConstants.keyUser,
          response.user!.toJson(),
        );
        await _storageService.writeBool(AppConstants.keyIsLoggedIn, true);
        _isLoggedIn.value = true;
        return true;
      } else {
        throw Exception('Login failed: Invalid credentials');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Logout method
  Future<void> logout() async {
    _currentUser.value = null;
    _isLoggedIn.value = false;
    await _storageService.remove(AppConstants.keyUser);
    await _storageService.writeBool(AppConstants.keyIsLoggedIn, false);
  }

  // Get user info
  UserModel? getUser() {
    return _currentUser.value;
  }

  // Check if user is logged in
  bool checkLoginStatus() {
    return _isLoggedIn.value;
  }
}
