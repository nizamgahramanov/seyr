import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seyr/helper/utility.dart';
import 'package:seyr/model/user.dart';
import '../exception/custom_auth_exception.dart';
import '../helper/app_colors.dart';
import 'firebase_firestore_service.dart';

class AuthService {
  final _firebaseAuth = auth.FirebaseAuth.instance;
  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email!,
    );
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<auth.UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn(scopes: <String>["email"]).signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final credential = auth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        auth.UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        if (userCredential.user != null) {
          List<String>? nameAndSurname =
              splitGoogleFullName(userCredential.user!.displayName);
          storeInFirestore(
            userCredential.user!.uid,
            nameAndSurname == null ? null : nameAndSurname[0],
            nameAndSurname == null ? null : nameAndSurname[1],
            userCredential.user!.email!,
            null,
          );
        }
        return userCredential;
      }
      return null;
    } on auth.FirebaseAuthException catch (authError) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: authError.message,
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomAuthException(context, authError.code, authError.message!);
    } catch (e) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'unknown_error_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomException(ctx: context, errorMessage: "Unknown Error");
    }
  }

  Future<User?> registerUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        storeInFirestore(
          userCredential.user!.uid,
          firstName,
          lastName,
          email,
          password,
        );
      }
      return _userFromFirebase(userCredential.user);
    } on auth.FirebaseAuthException catch (authError) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: authError.message,
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomAuthException(context, authError.code, authError.message!);
    } catch (e) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'unknown_error_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomException(ctx: context, errorMessage: e.toString());
    }
  }

  Future<User?> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(userCredential.user);
    } on auth.FirebaseAuthException catch (authError) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: authError.message,
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomAuthException(context, authError.code, authError.message!);
    } catch (e) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'unknown_error_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomException(ctx: context, errorMessage: "Unknown Error");
    }
  }

  Future<auth.UserCredential> signInWithApple(BuildContext context) async {
    try {
      final appleProvider = auth.AppleAuthProvider();

      if (kIsWeb) {
        return await _firebaseAuth.signInWithPopup(appleProvider);
      } else {
        var userCredential =
            await _firebaseAuth.signInWithProvider(appleProvider);
        if (userCredential.user != null) {
          List<String>? nameAndSurname =
              splitGoogleFullName(userCredential.user!.displayName);
          storeInFirestore(
            userCredential.user!.uid,
            nameAndSurname == null ? null : nameAndSurname[0],
            nameAndSurname == null ? null : nameAndSurname[1],
            userCredential.user!.email!,
            null,
          );
        }
        return userCredential;
      }
    } on auth.FirebaseAuthException catch (authError) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: authError.message,
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomAuthException(context, authError.code, authError.message!);
    } catch (e) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'unknown_error_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomException(ctx: context, errorMessage: "Unknown Error");
    }
  }

  void storeInFirestore(String uid, String? firstname, String? surname,
      String email, String? password) async {
    Map<String, dynamic>? userdata = await FireStoreService().getUserByUid(uid);
    if (userdata == null ||
        (userdata['firstName'] == null &&
                userdata['lastName'] == null &&
                firstname != null ||
            surname != null)) {
      FireStoreService()
          .createUserInFirestore(uid, firstname, surname, email, password);
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style:
            const TextStyle(color: AppColors.redAccent300, letterSpacing: 0.5),
      ),
    );
  }

  void updateUserName(
      BuildContext context, String? firstName, String? lastName) async {
    try {
      await _firebaseAuth.currentUser!
          .updateDisplayName('$firstName $lastName')
          .then((_) {
        FireStoreService().updateUserName(
            firstName, lastName, _firebaseAuth.currentUser!.uid);
      }).catchError((authError) {
        Utility.getInstance().showAlertDialog(
          context: context,
          alertTitle: 'oops_error_title'.tr(),
          alertMessage: authError.message,
          popButtonText: 'ok_btn'.tr(),
          popButtonColor: AppColors.redAccent300,
          onPopTap: () => Navigator.of(context).pop(),
        );
      });
    } on auth.FirebaseAuthException catch (authError) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: authError.message,
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomAuthException(context, authError.code, authError.message!);
    } catch (e) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'unknown_error_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomException(ctx: context, errorMessage: e.toString());
    }
  }

  void updateUserEmail(
      BuildContext context, String? email, String? password) async {
    if (email != null && password != null) {
      try {
        await _firebaseAuth.currentUser!.reauthenticateWithCredential(
          auth.EmailAuthProvider.credential(
              email: _firebaseAuth.currentUser!.email!, password: password),
        );
        _firebaseAuth.currentUser!.updateEmail(email).then((_) {
          FireStoreService().updateUserEmail(
            email,
            _firebaseAuth.currentUser!.uid,
          );
        }).catchError((authError) {
          Utility.getInstance().showAlertDialog(
            context: context,
            alertTitle: 'oops_error_title'.tr(),
            alertMessage: authError.message,
            popButtonText: 'ok_btn'.tr(),
            popButtonColor: AppColors.redAccent300,
            onPopTap: () => Navigator.of(context).pop(),
          );
        });
      } on auth.FirebaseAuthException catch (authError) {
        Utility.getInstance().showAlertDialog(
          context: context,
          alertTitle: 'oops_error_title'.tr(),
          alertMessage: authError.message,
          popButtonText: 'ok_btn'.tr(),
          popButtonColor: AppColors.redAccent300,
          onPopTap: () => Navigator.of(context).pop(),
        );
        throw CustomAuthException(context, authError.code, authError.message!);
      } catch (e) {
        Utility.getInstance().showAlertDialog(
          context: context,
          alertTitle: 'oops_error_title'.tr(),
          alertMessage: 'unknown_error_msg'.tr(),
          popButtonText: 'ok_btn'.tr(),
          popButtonColor: AppColors.redAccent300,
          onPopTap: () => Navigator.of(context).pop(),
        );
        throw CustomException(ctx: context, errorMessage: e.toString());
      }
    }
  }

  void updateUserPassword(BuildContext context, String password,
      String oldPassword, String email) async {
    try {
      await _firebaseAuth.currentUser!.reauthenticateWithCredential(
        auth.EmailAuthProvider.credential(
          email: email,
          password: oldPassword,
        ),
      );
      _firebaseAuth.currentUser!.updatePassword(password).then((_) {
        FireStoreService().updateUserPassword(
          password,
          _firebaseAuth.currentUser!.uid,
        );
      }).catchError((authError) {
        Utility.getInstance().showAlertDialog(
          context: context,
          alertTitle: 'oops_error_title'.tr(),
          alertMessage: authError.message,
          popButtonText: 'ok_btn'.tr(),
          popButtonColor: AppColors.redAccent300,
          onPopTap: () => Navigator.of(context).pop(),
        );
      });
    } on auth.FirebaseAuthException catch (authError) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: authError.message,
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomAuthException(context, authError.code, authError.message!);
    } catch (e) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'unknown_error_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomException(ctx: context, errorMessage: e.toString());
    }
  }

  signOut(BuildContext context) {
    try {
      _firebaseAuth.signOut();
    } on auth.FirebaseAuthException catch (authError) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: authError.message,
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomAuthException(context, authError.code, authError.message!);
    } catch (e) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'unknown_error_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
      throw CustomException(ctx: context, errorMessage: e.toString());
    }
  }

  List<String>? splitGoogleFullName(String? fullName) {
    List<String>? result;
    if (fullName != null) {
      result = fullName.split(" ");
    }
    return result;
  }
}
