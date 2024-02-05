// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

@immutable
class LoginToken {
  final String token;

  const LoginToken({required this.token});
  const LoginToken.success() : token = 'success';

  @override
  String toString() => 'LoginToken(token: $token)';
}
