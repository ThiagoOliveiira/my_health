import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:my_health/domain/entities/user_entity.dart';
import 'package:my_health/domain/usecases/get_create_current_user_usecase.dart';
import 'package:my_health/ui/pages/firebase_auth/firebase_auth_presenter.dart';

class GetxFirebaseAuthPresenter extends GetxController
    implements FirebaseeAuthPresenter {
  GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;

  GetxFirebaseAuthPresenter({required this.getCreateCurrentUserUseCase});

  @override
  RxBool isLoading = false.obs;

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    try {
      isLoading.value = true;
      await getCreateCurrentUserUseCase.call(user);
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<UserCredential> signUp(String email, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
