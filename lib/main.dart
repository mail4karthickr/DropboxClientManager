import 'package:flutter/material.dart';
import 'app_dependency_container.dart';

void main() {
  final appDependencyContainer = AppDependencyContainer();
  final app = appDependencyContainer.makeApp();
  runApp(app);
}