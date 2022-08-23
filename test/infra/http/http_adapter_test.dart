import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_health/data/http/http.dart';
import 'package:my_health/infra/http/http.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(
    () {
      client = ClientSpy();
      sut = HttpAdapter(client);
    },
  );

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  test('Deve chamar o post com os valores corretos', () async {
    await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

    verify(() => client.post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: '{"any_key":"any_value"}')).called(1);

    await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
        headers: {'any_header': 'any_value'});
    verify(() => client.post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'any_header': 'any_value',
        },
        body: '{"any_key":"any_value"}')).called(1);
  });

  test('Deve chamar o post sem o body', () async {
    await sut.request(url: url, method: 'post');

    verify(() => client.post(any(), headers: any(named: 'headers')));
  });

  test('Deve retornar null se o post retornar 200 sem dados', () async {
    client.mockPost(200, body: '');

    final response = await sut.request(url: url, method: 'post');

    expect(response, null);
  });

  test('Deve retornar dados se o post retornar 200', () async {
    final response = await sut.request(url: url, method: 'post');

    expect(response, {'any_key': 'any_value'});
  });

  test('Deve retonar null se o post retornar 204', () async {
    client.mockPost(204, body: '');

    final response = await sut.request(url: url, method: 'post');

    expect(response, null);
  });

  test('Deve retornar NotFoundError se o post retornar 404', () async {
    client.mockPost(404);

    final future = sut.request(url: url, method: 'post');

    expect(future, throwsA(HttpError.notFound));
  });

  test('Deve retornar ServerError se o post retornar 500', () async {
    client.mockPost(500);

    final future = sut.request(url: url, method: 'post');

    expect(future, throwsA(HttpError.serverError));
  });

  test('Deve retornar ServerError se o post retornar um erro', () async {
    client.mockPostError();

    final future = sut.request(url: url, method: 'post');

    expect(future, throwsA(HttpError.serverError));
  });
}
