class EnvConfig {
  static EnvConfig? _instance;

  static String backendEnvironment =
      const String.fromEnvironment('BUILD_ENV').isEmpty
          ? "development"
          : const String.fromEnvironment('BUILD_ENV');
  late final String hostUrl;
  EnvConfig._internal() {
    switch (backendEnvironment) {
      case 'development':
        {
          hostUrl = "https://gptuner-db624d447bc6.herokuapp.com/";
        }
        break;

      case 'production':
      default:
        {
          hostUrl = "https://gptuner-db624d447bc6.herokuapp.com/";
        }
    }
  }

  static EnvConfig get instance {
    _instance ??= EnvConfig._internal();
    return _instance!;
  }
}
