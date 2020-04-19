import 'dropbox/bloc/dropbox_container_bloc.dart';
import 'dropbox/dropbox_dependency_container.dart';
import 'dropbox/widgets/dropbox_container.dart';
import 'file_manager_app.dart';

class AppDependencyContainer {
  AppDependencyContainer();

  FileManagerApp makeApp() {
    final dropboxDIContainer = DropboxDependencyContainer(
        appDependencyContainer: this);
    return FileManagerApp(dropboxContainer: dropboxDIContainer.makeDropboxContainer());
  }
}