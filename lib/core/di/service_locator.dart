import 'set_controllers.dart';
import 'setup_usecases.dart';
import 'setup_core.dart';
import 'setup_repository.dart';
import 'setup_services.dart';

void setupServiceLocator() {
  print('🚀 Starting service locator setup...');

  // Core Services
  setupCore();

  // Repositories
  setupRepository();

  // Use Cases
  setupUsecases();

  // Controllers
  setupController();

  // Services
  setupServices();

  print('🚀 Service locator setup completed');
}
