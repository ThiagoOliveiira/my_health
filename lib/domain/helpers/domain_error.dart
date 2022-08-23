enum DomainError { unexpected, invalidCredentials, accessDenied, serverError }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.serverError:
        return "Estamos com problemas na comunicação com o servidor. Tente novamente mais tarde.";
      default:
        return "Algo errado aconteceu. Tente novamente em breve.";
    }
  }
}
