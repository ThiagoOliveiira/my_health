import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_health/data/http/http.dart';
import 'package:my_health/data/usecases/authentication/authentication.dart';
import 'package:my_health/domain/helpers/domain_error.dart';
import 'package:my_health/domain/usecases/usecases.dart';
import 'package:test/test.dart';

import '../../domain/mocks/params_factory.dart';
import '../../infra/mocks/api_factory.dart';
import '../mocks/mocks.dart';

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;
  late Map apiResult;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    apiResult = ApiFactory.makeAccountJson();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = ParamsFactory.makeAuthentication();
    httpClient.mockRequest(apiResult);
  });

  test('Deve chamar HttpClient com URL correto', () async {
    await sut.auth(params);
    verify(
      () => httpClient.request(
          url: url,
          method: 'post',
          body: {"email": params.email, "password": params.password}),
    );
  });

  test('Deve retornar um UnexpectedError se HttpClient retornar 400', () async {
    httpClient.mockRequestError(HttpError.badRequest);

    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar um UnexpectedError se HttpClient retornar 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar um ServerError se HttpClient retonar 500', () async {
    httpClient.mockRequestError(HttpError.serverError);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar um InvalidCredentialsError se HttpClient retornar 401',
      () async {
    httpClient.mockRequestError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Deve retornar uma conta se HttpClient retornar 200', () async {
    final account = await sut.auth(params);

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Deve lançar UnexpectedError se HttpClient retornar 200 com dados inválidos',
      () async {
    httpClient.mockRequest({'invalid_key': 'invalid_value'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
