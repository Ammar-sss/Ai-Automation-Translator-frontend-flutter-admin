import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_translater_admin/app.dart';
import 'package:smart_translater_admin/core/network/dio_client.dart';
import 'package:smart_translater_admin/core/network/server_health_cubit.dart';
import 'package:smart_translater_admin/core/network/server_health_service.dart';
import 'package:smart_translater_admin/core/route/app_router.dart';
import 'package:smart_translater_admin/core/storage/secure_storage_service.dart';
import 'package:smart_translater_admin/feature/auth/data/datasource/auth_remote_data_source.dart';
import 'package:smart_translater_admin/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_translater_admin/feature/auth/presentation/controller/auth_bloc.dart';
import 'package:smart_translater_admin/feature/dashboard/data/datasource/user_remote_datasource.dart';
import 'package:smart_translater_admin/feature/dashboard/data/repositories/user_repository_impl.dart';
import 'package:smart_translater_admin/feature/dashboard/presentation/controller/user_cubit.dart';

import 'package:smart_translater_admin/feature/auth/data/datasource/auth_api_service.dart';

import 'package:smart_translater_admin/feature/sitting/presentation/controller/sitting_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = SecureStorageService();
  final dioClient = DioClient(storageService: storageService);

  final authApiService = AuthApiService(dioClient.dio);
  final remoteDataSource = AuthRemoteDataSourceImpl(
    apiService: authApiService,
    storageService: storageService,
  );
  final userRemoteDataSource = UserRemoteDatasource(dioClient.dio);

  final authRepository = AuthRepositoryImpl(
    authRemoteDataSource: remoteDataSource,
  );
  final userRepository = UserRepositoryImpl(
    userRemoteDatasource: userRemoteDataSource,
  );

  final authBloc = AuthBloc(
    storageService: storageService,
    authRepository: authRepository,
  )..add(AuthCheckRequested());

  final userCubit = UserCubit(userRepository: userRepository);

  final serverHealthService = ServerHealthService();
  final serverHealthCubit = ServerHealthCubit(service: serverHealthService);

  final sittingCubit = SittingCubit(storageService: storageService);

  final appRouter = AppRouter(authBloc: authBloc);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sittingCubit),
        BlocProvider.value(value: serverHealthCubit),
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: userCubit),
      ],
      child: MyApp(router: appRouter.router),
    ),
  );
}
