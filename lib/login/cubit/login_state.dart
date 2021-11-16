part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.obscure = true,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final bool obscure;

  @override
  List<Object> get props => [email, password, status, obscure];

  LoginState copyWith(
      {Email email, Password password, FormzStatus status, bool obscure}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      obscure: obscure ?? this.obscure,
    );
  }
}
