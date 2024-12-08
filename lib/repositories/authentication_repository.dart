import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/data/cache/cache_client.dart';
import 'package:telx/src/models/user.dart';

/// {@template sign_up_with_email_and_password_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const LogInWithGoogleFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [UserModel] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [UserModel.empty] if the user is not authenticated.
  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return UserModel.empty;

      // Convert firebaseUser to your custom User with additional data
      final user = await firebaseUser.toUser;
      print("Im in auth repo : $user");

      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [UserModel.empty] if there is no cached user.
  UserModel get currentUser {
    return _cache.read<UserModel>(key: userCacheKey) ?? UserModel.empty;
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<bool> checkEmailExistence(String email) async {
    print("User Email : $email");
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword', // Use a temporary password
      );
      // If successful, delete the user
      await _firebaseAuth.currentUser?.delete();
      return false; // Email does not exist
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true; // Email exists
      }
      throw Exception('Error checking email existence: ${e.message}');
    }
  }

  Future<void> sendCodeOnEmail(String email) async {
    print("Attempting to send verification code to: $email");
    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.218:4000/sendVerificationCode"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      switch (response.statusCode) {
        case 200:
          print("Code sent successfully.");
          break;
        case 400:
          // Likely email does not exist or missing fields
          final errorMessage =
              jsonDecode(response.body)['error'] ?? "Invalid request";
          print("Client error: $errorMessage");
          throw Exception(errorMessage);
        case 401:
          // Unauthorized or authentication error
          print("Authentication error. Please check your API credentials.");
          throw Exception("Authentication failed.");
        case 429:
          // Too many requests (rate limit exceeded)
          print("Too many requests. Please try again later.");
          throw Exception("Rate limit exceeded. Try again later.");
        case 500:
          // Internal server error
          print("Server encountered an error. Please try again.");
          throw Exception("Internal server error. Try again later.");
        default:
          // Handle unexpected status codes
          print("Unexpected error: ${response.statusCode}");
          throw Exception(
              "Unexpected error occurred. Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while sending verification code: $e");
      throw Exception("Failed to send verification code: $e");
    }
  }

  Future<bool> verifyCode(String email, String code) async {
    final response =
        await http.post(Uri.parse("http://192.168.0.218:4000/verify-code"),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "email": email,
              "code": code,
            }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  // Future<void> logInWithGoogle() async {
  //   try {
  //     late final firebase_auth.AuthCredential credential;
  //     if (isWeb) {
  //       final googleProvider = firebase_auth.GoogleAuthProvider();
  //       final userCredential = await _firebaseAuth.signInWithPopup(
  //         googleProvider,
  //       );
  //       credential = userCredential.credential!;
  //     } else {
  //       final googleUser = await _googleSignIn.signIn();
  //       final googleAuth = await googleUser!.authentication;
  //       credential = firebase_auth.GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //     }
  //
  //     await _firebaseAuth.signInWithCredential(credential);
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     throw LogInWithGoogleFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw const LogInWithGoogleFailure();
  //   }
  // }

  Future<void> logInWithGoogle({required BuildContext context}) async {
    try {
      late final firebase_auth.AuthCredential credential;

      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // User canceled the sign-in process
          return;
        }
        final googleAuth = await googleUser.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      // Sign in with Google credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Get the current user's UID
      final String uid = userCredential.user?.uid ?? '';

      if (uid.isEmpty) {
        throw Exception("User UID not found");
      }

      // Check if the user exists in the Firestore database
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // User exists, navigate to the HomePage
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.homeScreen,
          (route) => false,
        );
      } else {
        // User does not exist, navigate to the UserInfoDetailsScreen
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.userInfoDetailsScreen,
          (route) => false,
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('This account exists with a different sign-in method.'),
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Google credential.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: ${e.message}')),
        );
      }
    } catch (e) {
      // Handle other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  // Future<void> logInWithEmailAndPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw const LogInWithEmailAndPasswordFailure();
  //   }
  // }


  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in the user
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current user's UID
      final String uid = _firebaseAuth.currentUser?.uid ?? '';

      print(_firebaseAuth.currentUser);

      // final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      //     email: email, password: password);
      // if (credential.credential != null) {
      //   _firebaseAuth.currentUser!.delete();
      //   print("Please sign in first");
      // } else {
      //   print("Password is wrong");
      // }

      if (uid.isEmpty) {
        throw Exception("User UID not found");
      }

      // Check if the user exists in the Firestore database
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // User exists, navigate to the HomePage
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.homeScreen,
          (route) => false,
        );
      } else {
        // User does not exist, log out and navigate back to the LoginScreen
        // await _firebaseAuth.signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNames.userInfoDetailsScreen,
          (route) => false,
        );
        // showCustomSnackBar(context: context, message: 'message', type: SnackBarType.failure);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('User does not exist in the database.')),
        // );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      print("Im printing e -> ${e.code}");
      // Handle Firebase authentication errors
      if (e.code == 'user-not-found') {
        // Email does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Email not found. Please register first.')),
        );
      } else if (e.code == 'wrong-password') {
        // Password is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Incorrect password. Please try again.')),
        );
      } else if (e.code == 'invalid-email') {
        // Invalid email format
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email format.')),
        );
      }else if (e.code == 'invalid-credential') {
        // Invalid email format
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email and password')),
        );
      } else {
        // Other FirebaseAuth errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: ${e.message}')),
        );
      }
    } catch (e) {
      // Handle any other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }

  Future<Map<String, dynamic>> addUserViaApi(UserModel user) async {
    // Replace this with your actual API call (using http package, dio, etc.)
    print("Im come into the add user via api");
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.218:4000/addUser'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'uid': user.id,
          'fullName': user.fullName,
          'username': user.username,
          'email': user.email,
          'profilePicture': user.photo,
          'lastSeen': DateTime.now().toIso8601String(),
          'status': 'Active',
          'isOnline': true,
          'dateOfBirth': user.dateOfBirth?.split('T')[0],
          'gender': user.gender,
        }),
      );

      if (response.statusCode == 200) {
        return {'status': 200, 'message': 'User created successfully'};
      } else {
        return {
          'status': response.statusCode,
          'message': 'Failed to create user'
        };
      }
    } catch (e) {
      print("Error problem is : $e");
      return {'status': 500, 'message': 'An error occurred'};
    }
  }

  /// Signs out the current user which will emit
  /// [UserModel.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension FirebaseUserToUser on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [UserModel], fetching additional fields from Firestore.
  Future<UserModel> get toUser async {
    // Base User data from Firebase Authentication
    final baseUser = UserModel(
      id: uid,
      email: email,
      fullName: displayName,
      photo: photoURL,
    );

    try {
      // Fetch additional fields from Firestore
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        return UserModel(
          id: baseUser.id,
          email: baseUser.email,
          fullName: data?['fullName'] as String?,
          photo: data?['profilePicture'] as String?,
          username: data?['username'] as String?,
          dateOfBirth: data?['dateOfBirth'] as String?,
          gender: data?['gender'] as String?,
        );
      }
    } catch (e) {
      print("Error fetching user additional data: $e");
    }
    // Return base User if no additional data is found or an error occurs
    return baseUser;
  }
}
