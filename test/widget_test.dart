// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_translater_admin/app.dart';
import 'package:smart_translater_admin/core/network/dio_client.dart';
import 'package:smart_translater_admin/core/route/app_router.dart';
import 'package:smart_translater_admin/core/storage/secure_storage_service.dart';
import 'package:smart_translater_admin/feature/auth/data/datasource/auth_api_service.dart';
import 'package:smart_translater_admin/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:smart_translater_admin/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_translater_admin/feature/auth/presentation/controller/auth_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_translater_admin/feature/sitting/presentation/controller/sitting_cubit.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    final SecureStorageService storageService = SecureStorageService();
    final dio = DioClient(storageService: storageService);

    final authApiService = AuthApiService(dio.dio);
    final onRemoteDataSource = AuthRemoteDataSourceImpl(
      apiService: authApiService,
      storageService: storageService,
    );

    final authRepo = AuthRepositoryImpl(
      authRemoteDataSource: onRemoteDataSource,
    );

    final authBloc = AuthBloc(
      authRepository: authRepo,
      storageService: storageService,
    );

    final sittingCubit = SittingCubit(storageService: storageService);

    final appRouter = AppRouter(authBloc: authBloc);

    await tester.pumpWidget(
      BlocProvider.value(
        value: sittingCubit,
        child: MyApp(router: appRouter.router),
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}
