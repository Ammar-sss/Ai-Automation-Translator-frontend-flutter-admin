part of 'sitting_cubit.dart';

@immutable
class SittingState {
  final ThemeMode themeMode;
  final String fontFamily;

  const SittingState({
    this.themeMode = ThemeMode.light,
    this.fontFamily = 'Default',
  });

  SittingState copyWith({ThemeMode? themeMode, String? fontFamily}) {
    return SittingState(
      themeMode: themeMode ?? this.themeMode,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
