import 'package:appwrite/appwrite.dart';
import 'appwrite_config.dart';

class AppwriteService {
  AppwriteService._();
  static final AppwriteService instance = AppwriteService._();

  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Realtime realtime;

  bool _initialized = false;

  void initialize({String? endpoint, String? projectId}) {
    if (_initialized) return;
    final resolvedEndpoint = endpoint ?? AppwriteConfig.endpoint;
    final resolvedProjectId = projectId ?? AppwriteConfig.projectId;
    // ignore: avoid_print
    print('[Appwrite] initialize with endpoint: ' + resolvedEndpoint + ', project: ' + resolvedProjectId);
    if (resolvedEndpoint.contains('YOUR_APPWRITE_ENDPOINT') ||
        resolvedEndpoint.contains('your_appwrite_endpoint')) {
      // ignore: avoid_print
      print('[Appwrite] ERROR: Placeholder endpoint detected -> ' + resolvedEndpoint);
    }
    client = Client()
        .setEndpoint(resolvedEndpoint)
        .setProject(resolvedProjectId)
        .setSelfSigned(status: true);

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);
    _initialized = true;
  }
}
