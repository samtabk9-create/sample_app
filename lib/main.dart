import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/database_service.dart';
import 'data/repositories/appointment_repository_impl.dart';
import 'presentation/providers/appointment_provider.dart';
import 'presentation/pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        ProxyProvider<DatabaseService, AppointmentRepositoryImpl>(
          update: (_, databaseService, __) => AppointmentRepositoryImpl(databaseService),
        ),
        ChangeNotifierProxyProvider<AppointmentRepositoryImpl, AppointmentProvider>(
          create: (context) => AppointmentProvider(
            Provider.of<AppointmentRepositoryImpl>(context, listen: false),
          ),
          update: (_, repository, previous) => previous ?? AppointmentProvider(repository),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}