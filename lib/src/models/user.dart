import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel({
    this.id,
    this.email,
    this.fullName,
    this.photo,
    this.username,
    this.dateOfBirth,
    this.gender,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String? id;

  /// The current user's full name (display name).
  final String? fullName;

  /// Url for the current user's photo.
  final String? photo;

  /// The current user's username.
  final String? username;

  /// The current user's date of birth.
  final String? dateOfBirth;

  /// The current user's gender.
  final String? gender;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel();

  @override
  List<Object?> get props =>
      [email, id, fullName, photo, username, dateOfBirth, gender];
}
