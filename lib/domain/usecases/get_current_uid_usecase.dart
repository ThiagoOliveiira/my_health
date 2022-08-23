import 'package:my_health/domain/repositories/repositories.dart';

class GetCurrentUIDUseCase {
  final FirebaseRepository repository;

  GetCurrentUIDUseCase({required this.repository});

  Future<String> call() async {
    return await repository.getCurrentUID();
  }
}
