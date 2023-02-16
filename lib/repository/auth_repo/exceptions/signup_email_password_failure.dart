class SignupWithEmailAndPasswordFailure {
  final String? message;

  const SignupWithEmailAndPasswordFailure(
      [this.message = "An unknown error occurred"]);

  factory SignupWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupWithEmailAndPasswordFailure(
            'Please enter a strong password');
      case 'invalid-email':
        return const SignupWithEmailAndPasswordFailure(
            'Email is not valid or badly formatted');
      case 'email-already-in-use':
        return const SignupWithEmailAndPasswordFailure(
            'An account already exists for the email.');
      case 'operation-not-allowed':
        return const SignupWithEmailAndPasswordFailure(
            'Operation is not allowed. Please contact support');
      case 'user-disabled':
        return const SignupWithEmailAndPasswordFailure(
            'This user has been disabled. Please contact support for help.');
      default:
        return const SignupWithEmailAndPasswordFailure();
    }
  }
}

class SigninWithEmailAndPasswordFailure {
  final String? message;

  const SigninWithEmailAndPasswordFailure(
      [this.message = "An unknown error occurred"]);

  factory SigninWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'invalid-email':
        return const SigninWithEmailAndPasswordFailure(
            'Email is not valid or badly formatted');
      case 'email-already-in-use':
        return const SigninWithEmailAndPasswordFailure(
            'An account already exists for the email.');

      default:
        return const SigninWithEmailAndPasswordFailure();
    }
  }
}
