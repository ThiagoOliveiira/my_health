import 'package:faker/faker.dart';
import 'package:my_health/domain/usecases/authentication.dart';

class ParamsFactory {
  static AuthenticationParams makeAuthentication() => AuthenticationParams(
      email: faker.internet.email(), password: faker.internet.password());
}
