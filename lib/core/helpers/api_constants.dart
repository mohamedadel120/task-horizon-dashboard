class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // Base URLs

  static const String baseUrl = 'https://task-dev.thefirstagencysa.com/api/';
  static const String baseUrlDev = 'https://api-dev.gomla.com/v1/';
  static const String baseUrlStaging = 'https://api-staging.gomla.com/v1/';

  // API Versions
  static const String apiVersion = 'v1';
  static const String currentApiVersion = '$baseUrl$apiVersion/';

  // Authentication Endpoints
  static const String auth = 'auth/';
  static const String login = '${auth}login';
  static const String register = '${auth}register';
  static const String logout = '${auth}logout';
  static const String refreshToken = '${auth}refresh';
  static const String verifyOtp = '${auth}verify-otp';
  static const String resendOtp = '${auth}resend-otp';
  static const String forgotPassword = '${auth}forgot-password';
  static const String resetPassword = '${auth}reset-password';
  static const String changePassword = '${auth}change-password';
  static const String updateDeviceToken = '${auth}update-device-token';

  // User Endpoints
  static const String user = 'user/';
  static const String profile = 'profile';
  static const String profileAnalyses = 'profile/analyses';
  static const String profileAvatar = 'profile/avatar';
  static const String profileUpdate = 'update-profile';
  static const String profileEmail = 'profile/email';
  static const String profileEmailVerify = 'profile/email/verify';
  static const String profilePhone = 'profile/phone';
  static const String profilePhoneVerify = 'profile/phone/verify';
  static const String profilePassword = 'profile/password';
  static const String fullProfile = 'full-profile';
  static const String updateProfile = '${user}update-profile';
  static const String uploadAvatar = '${user}upload-avatar';
  static const String deleteAccount = '${user}delete-account';
  static const String userAddresses = '${user}addresses';
  static const String userPreferences = '${user}preferences';

  // Product Endpoints
  static const String products = 'products/';
  static const String productCategories = '${products}categories';
  static const String productSearch = '${products}search';
  static const String productDetails = '${products}details';
  static const String productReviews = '${products}reviews';
  static const String productRecommendations = '${products}recommendations';
  static const String featuredProducts = '${products}featured';
  static const String newArrivals = '${products}new-arrivals';
  static const String bestSellers = '${products}best-sellers';

  // Cart Endpoints
  static const String cart = 'cart/';
  static const String addToCart = '${cart}add';
  static const String updateCart = '${cart}update';
  static const String removeFromCart = '${cart}remove';
  static const String clearCart = '${cart}clear';
  static const String cartItems = '${cart}items';

  // Order Endpoints
  static const String orders = 'myOrders/';
  static const String createOrder = '${orders}create';
  static const String orderHistory = '${orders}history';
  static const String orderDetails = '${orders}details';
  static const String cancelOrder = '${orders}cancel';
  static const String trackOrder = '${orders}track';
  static const String reorder = '${orders}reorder';

  // Posts Endpoints
  static const String posts = 'posts/';
  static const String getPosts = '${posts}list';
  static const String createPost = '${posts}create';

  // Contracts Endpoints
  static const String contracts = 'contracts/';
  static const String createContract = 'contracts';
  static const String updatePost = '${posts}update';
  static const String deletePost = '${posts}delete';
  static const String postDetails = '${posts}details';

  // Payment Endpoints
  static const String payments = 'payments/';
  static const String paymentMethods = '${payments}methods';
  static const String processPayment = '${payments}process';
  static const String paymentHistory = '${payments}history';
  static const String refundPayment = '${payments}refund';

  // Wishlist Endpoints
  static const String wishlist = 'wishlist/';
  static const String addToWishlist = '${wishlist}add';
  static const String removeFromWishlist = '${wishlist}remove';
  static const String getWishlist = '${wishlist}items';

  // AI Endpoints
  static const String ai = 'ai/';
  static const String aiChat = '${ai}chat';
  static const String aiRecommendations = '${ai}recommendations';
  static const String aiSearch = '${ai}search';
  static const String aiPersonalization = '${ai}personalization';

  // Notification Endpoints
  static const String notifications = 'notifications';
  static const String notificationsUnreadCount = '$notifications/unread-count';
  static const String getNotifications = '$notifications/list';
  static const String markAsRead = '$notifications/mark-read';
  static const String notificationSettings = '$notifications/settings';
  static const String registerFcmToken = '$notifications/register-token';
  // Loyalty Program Endpoints
  static const String loyalty = 'loyalty/';
  static const String loyaltyPoints = '${loyalty}points';
  static const String loyaltyHistory = '${loyalty}history';
  static const String redeemPoints = '${loyalty}redeem';
  static const String loyaltyTiers = '${loyalty}tiers';

  // Categories Endpoints
  static const String categories = 'categories';

  // Helper method to get advertisements by category ID
  static String getCategoryAdvertisements(int categoryId) {
    return '$categories/$categoryId/advertisements';
  }

  // Advertisements Endpoints
  static const String advertisements = 'advertisements';
  static const String advertisementDetails = 'advertisementDetails';
  static const String advertisementSearch = 'advertisements/search';
  static String myAdvertisements({required int isActive}) =>
      '$advertisements?is_mine=1&is_active=$isActive';
  static String updateAdvertisement(int advertisementId) =>
      '$advertisements/$advertisementId';
  static String deleteAdvertisement(int advertisementId) =>
      '$advertisements/$advertisementId';
  static String activateAdvertisement(int advertisementId) =>
      '$advertisements/$advertisementId/activate';

  // Favorites Endpoints
  static const String favorites = 'favorites';
  static String deleteFavorite(int adId) => 'favorites/$adId';

  // Content Endpoints
  static const String content = 'content/';
  static const String banners = '${content}banners';
  static const String aboutUs = '${content}about-us';
  static const String termsConditions = '${content}terms-conditions';
  static const String privacyPolicy = '${content}privacy-policy';
  static const String faq = '${content}faq';
  static const String contactUs = '${content}contact-us';

  // Settings Endpoints
  static const String settings = 'settings/';
  static String termsAndConditionsDocuments({
    String pageName = 'terms-and-conditions',
  }) => '${settings}terms-and-conditions-documents?page_name=$pageName';

  // Location Endpoints
  static const String location = 'location/';
  static const String countries = '${location}countries';
  static const String cities = 'cities';
  static const String areas = '${location}areas';
  static const String cityAreasPlaceholder = 'cities/:cityId/areas';

  static String cityAreas(int cityId) => 'cities/$cityId/areas';
  static const String addressValidation = '${location}validate-address';

  // File Upload Endpoints
  static const String uploads = 'uploads/';
  static const String uploadImage = '${uploads}image';
  static const String uploadDocument = '${uploads}document';
  static const String uploadFile = 'upload-file';

  // Search Endpoints
  static const String search = 'search/';
  static const String globalSearch = '${search}global';
  static const String searchSuggestions = '${search}suggestions';
  static const String searchHistory = '${search}history';
  static const String searchFilters = '${search}filters';

  // Analytics Endpoints
  static const String analytics = 'analytics/';
  static const String trackEvent = '${analytics}track';
  static const String userBehavior = '${analytics}user-behavior';

  // Contracts Endpoints
  static const String inComing = 'contracts/incoming';
  static const String outGoing = 'contracts/outgoing';
  static String outgoingContractDetails(int contractId) =>
      'contracts/outgoing/$contractId';
  static String markOutgoingContractAsPaid(int contractId) =>
      'contracts/outgoing/mark-as-paid/$contractId';
  static String cancelOutgoingContract(int contractId) =>
      'contracts/outgoing/cancel/$contractId';
  static String completeReturn(int contractId) =>
      'contracts/outgoing/complete-return/$contractId';
  static String rateOutgoingContract(int contractId) =>
      'contracts/outgoing/rate/$contractId';
  static String contractPdf(int contractId) => 'contracts/$contractId/pdf';
  static String incomingContractDetails(int contractId) =>
      'contracts/incoming/$contractId';
  static String approveIncomingContract(int contractId) =>
      'contracts/incoming/approve/$contractId';
  static String rejectIncomingContract(int contractId) =>
      'contracts/incoming/reject/$contractId';
  static String approvePickupIncomingContract(int contractId) =>
      'contracts/incoming/approve-pickup/$contractId';

  // User Profile Endpoints
  static String userAdvertisements(int userId) =>
      'users/$userId/advertisements';
  static String userReviews(int userId) => 'users/$userId/reviews';

  // Support Endpoints
  static const String support = 'support/';
  static const String createTicket = '${support}create-ticket';
  static const String supportChat = '${support}chat';
  static const String supportHistory = '${support}history';

  // Contact Us Endpoints
  static const String createContactUs = 'contact-us';
  static String contactUsList({int? status}) {
    if (status != null) {
      return '$createContactUs?status=$status';
    }
    return createContactUs;
  }

  // FAQ Endpoints
  static const String faqs = 'faqs';
  // Missing Requests Endpoints
  static const String specialRequests = 'special-requests/';
  static const String createSpecialRequest = 'special-requests';
  static String specialRequestDetails(int requestId) =>
      'special-requests/$requestId';
  static String updateSpecialRequest(int requestId) =>
      'special-requests/$requestId';
  static String deleteSpecialRequest(int requestId) =>
      'special-requests/$requestId';
  static String myRequests({required int isMine}) =>
      'special-requests/?is_mine=$isMine';

  // Comments Endpoints
  static String getCommentsForSpecialRequest(int requestId) =>
      'comments/special-requests/$requestId';
  static const String createComment = 'comments';

  // Reviews Endpoints
  static const String reviews = 'reviews';

  // HTTP Headers
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String acceptLanguage = 'Accept-Language';
  static const String userAgent = 'User-Agent';
  static const String apiKey = 'X-API-Key';

  // Header Values
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String bearerPrefix = 'Bearer ';

  // Request Timeouts (in seconds)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const String pageParam = 'page';
  static const String limitParam = 'limit';
  static const String offsetParam = 'offset';

  // Cache Keys
  static const String cacheKeyPrefix = 'gomla_cache_';
  static const String userCacheKey = '${cacheKeyPrefix}user';
  static const String productsCacheKey = '${cacheKeyPrefix}products';
  static const String categoriesCacheKey = '${cacheKeyPrefix}categories';

  // Helper method to build full URL
  static String buildUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  // Helper method to build headers
  static Map<String, String> buildHeaders({
    String? token,
    String? language,
    String? contentType = applicationJson,
  }) {
    final headers = <String, String>{
      ApiConstants.contentType: contentType!,
      userAgent: 'GOMLA-Mobile-App/1.0.0',
    };

    if (token != null) {
      headers[authorization] = '$bearerPrefix$token';
    }

    if (language != null) {
      headers[acceptLanguage] = language;
    }

    return headers;
  }
}
