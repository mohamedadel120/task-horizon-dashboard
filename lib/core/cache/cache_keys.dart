/// Centralized cache keys for the application
/// Use these constants to ensure consistent cache key naming
class CacheKeys {
  CacheKeys._(); // Private constructor

  // Profile cache keys
  static const String profile = 'profile';
  static const String userProfile = 'user_profile';

  // Advertisement cache keys
  static const String advertisements = 'advertisements';
  static const String advertisementDetails = 'advertisement_details';
  static String advertisementDetailsById(int id) => 'advertisement_details_$id';

  // Categories cache keys
  static const String categories = 'categories';
  static const String categoryById = 'category';

  // Cities and locations cache keys
  static const String cities = 'cities';
  static const String areas = 'areas';
  static String areasByCityId(int cityId) => 'areas_city_$cityId';

  // Contracts cache keys
  static const String incomingContracts = 'incoming_contracts';
  static const String outgoingContracts = 'outgoing_contracts';
  static String contractDetails(int contractId) =>
      'contract_details_$contractId';

  // Search cache keys
  static const String searchHistory = 'search_history';
  static const String recentSearches = 'recent_searches';

  // General cache keys
  static const String appSettings = 'app_settings';
  static const String userPreferences = 'user_preferences';
}

