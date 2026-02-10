/// Notification type enum
/// Indicates the category/entity type of the notification
enum NotificationType {
  contract('contract'),
  advertisement('advertisement');

  final String value;
  const NotificationType(this.value);

  static NotificationType? fromString(String? value) {
    if (value == null) return null;
    return NotificationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationType.contract,
    );
  }
}

/// Notification screen enum
/// Specifies which screen/page the mobile app should navigate to
enum NotificationScreen {
  contractDetails('contract_details'),
  contractPickup('contract_pickup'),
  contractReturn('contract_return'),
  advertisementDetails('advertisement_details');

  final String value;
  const NotificationScreen(this.value);

  static NotificationScreen? fromString(String? value) {
    if (value == null) return null;
    return NotificationScreen.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationScreen.contractDetails,
    );
  }
}

/// Notification key enum
/// Identifies the specific event/action that triggered the notification
enum NotificationKey {
  // Contract keys
  incomingContractCreated('incoming_contract_created'),
  contractApproved('contract_approved'),
  contractRejected('contract_rejected'),
  contractPaymentReceived('contract_payment_received'),
  contractPaymentConfirmed('contract_payment_confirmed'),
  contractPickupReady('contract_pickup_ready'),
  contractAwaitingReturn('contract_awaiting_return'),
  contractAwaitingReturnOwner('contract_awaiting_return_owner'),
  contractCompleted('contract_completed'),

  // Advertisement keys
  advertisementActivated('advertisement_activated');

  final String value;
  const NotificationKey(this.value);

  static NotificationKey? fromString(String? value) {
    if (value == null) return null;
    return NotificationKey.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationKey.incomingContractCreated,
    );
  }
}


