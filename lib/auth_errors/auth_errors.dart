import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Map<String, AuthenticationError> errorMap = {
  'user-not-found': const AuthenticationErrorUserNotFound(),
  'weak-password': const AuthErrorWeakPassword(),
  'invalid-email': const AuthenticationErrorInvalidEmail(),
  'invalid-crendential': const AuthenticationErrorInvalidCredential(),
  'operation-not-allowed': const AuthenticationErrorOperationNotAllowed(),
  'email-already-in-use': const AuthenticationErrorEmailAlreadyExists(),
  'requires-recent-login': const AuthenticationErrorRequiresRecentLogin(),
  'no-current-user': const AuthenticationErrorNoCurrentUser(),
  'too-many-requests': const AuthenticationErrorTooManyRequests(),
};

@immutable
abstract class AuthenticationError {
  final String errorTitle;
  final String errorContent;

  const AuthenticationError(
      {required this.errorTitle, required this.errorContent});
  factory AuthenticationError.from(FirebaseAuthException exception) {
    print(exception.code.toLowerCase().trim());
    return errorMap[exception.code.toLowerCase().trim()] ??
        AuthenticationErrorUnknown(unknownException: exception);
  }
}

class AuthenticationErrorUnknown extends AuthenticationError {
  final FirebaseAuthException unknownException;

  const AuthenticationErrorUnknown({required this.unknownException})
      : super(
          errorTitle: 'Unknown Authentication Error',
          errorContent: 'An unknown authentication error has occured',
        );
}

@immutable
class AuthenticationErrorNoCurrentUser extends AuthenticationError {
  const AuthenticationErrorNoCurrentUser()
      : super(
          errorContent: 'Authentication Error',
          errorTitle: 'No current user!',
        );
}

@immutable
class AuthenticationErrorRequiresRecentLogin extends AuthenticationError {
  const AuthenticationErrorRequiresRecentLogin()
      : super(
          errorContent: 'Recent login required',
          errorTitle: 'Please login firt before performing this action',
        );
}

@immutable
class AuthenticationErrorOperationNotAllowed extends AuthenticationError {
  const AuthenticationErrorOperationNotAllowed()
      : super(
          errorContent: 'Operation not allowed',
          errorTitle:
              'You cannot perform this operation at this moment. Please try again later.',
        );
}

@immutable
class AuthenticationErrorUserNotFound extends AuthenticationError {
  const AuthenticationErrorUserNotFound()
      : super(
          errorContent: 'User not found',
          errorTitle:
              'The given user was not found. Please login with different credentials.',
        );
}

@immutable
class AuthErrorWeakPassword extends AuthenticationError {
  const AuthErrorWeakPassword()
      : super(
          errorContent: 'Weak Password',
          errorTitle: 'Please choose a more secure password',
        );
}

@immutable
class AuthenticationErrorInvalidEmail extends AuthenticationError {
  const AuthenticationErrorInvalidEmail()
      : super(
          errorTitle: 'Invalid email address',
          errorContent:
              'Are you sure of your email? Please confirm it and try again.',
        );
}

@immutable
class AuthenticationErrorEmailAlreadyExists extends AuthenticationError {
  const AuthenticationErrorEmailAlreadyExists()
      : super(
          errorContent: 'Email address already in use',
          errorTitle: 'Email is already in use',
        );
}

@immutable
class AuthenticationErrorInvalidCredential extends AuthenticationError {
  const AuthenticationErrorInvalidCredential()
      : super(
          errorContent: 'Invalid Credential',
          errorTitle: 'You may have forgotton your password',
        );
}

@immutable
class AuthenticationErrorTooManyRequests extends AuthenticationError {
  const AuthenticationErrorTooManyRequests()
      : super(
          errorContent: 'Too many unsuccessful login attempts',
          errorTitle: 'Please change your password and try again',
        );
}
