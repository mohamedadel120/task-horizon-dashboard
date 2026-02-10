# Base Cubit Architecture

A modern, flexible state management architecture for Flutter apps that provides a foundation for handling API calls, loading states, and error management with minimal boilerplate.

## 📁 Files Overview

### `base_cubit.dart`

The main base cubit class that provides common functionality for all cubits in the app.

**Key Features:**

- Generic API call handling with `handleApiCall()` method
- Automatic state management for loading, success, and error states
- Operation-specific status tracking using endpoint names
- Error message storage and retrieval
- Comprehensive logging for debugging

### `base_state.dart`

The base state class that all cubit states should extend.

**Key Features:**

- Per-operation API state management
- Status tracking (initial, loading, success, error)
- Error message storage per operation
- Response model storage per operation
- Immutable state with copyWith functionality

### `base_builder_widget.dart`

A specialized BlocBuilder widget that handles common UI patterns for different states.

**Key Features:**

- Automatic loading state handling with ShimmerSkeleton
- Custom error widget support
- Fake data display during loading
- Operation-specific state management
- Clean separation of concerns

### `base_consumer_widget.dart`

A specialized BlocConsumer widget that combines BlocBuilder and BlocListener functionality.

**Key Features:**

- All features of BaseBlocBuilder
- State change listeners for side effects
- Callback functions for different states (loading, success, error, initial)
- Perfect for handling navigation, showing snackbars, or other side effects

## 🚀 Getting Started

### 1. Create a Model

First, create a model that extends `BaseModel`:

```dart
class Product extends BaseModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  @override
  BaseModel fromMap(Map<String, dynamic> json) {
    return Product.fromJson(json);
  }

  @override
  Map<String, dynamic> toMap() {
    return toJson();
  }

  @override
  BaseModel copyWith() {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      image: image,
    );
  }

  @override
  BaseModel fakeData() {
    return Product(
      id: 0,
      title: 'Loading...',
      description: 'Please wait while we load the product details.',
      price: 0.0,
      image: 'https://via.placeholder.com/150',
    );
  }
}
```

### 2. Create a Wrapper Model (Required)

For all data structures, create a wrapper that extends `BaseModel`:

```dart
class ProductWrapper extends BaseModel {
  final List<Product> products;

  ProductWrapper({required this.products});

  @override
  ProductWrapper copyWith({List<Product>? products}) {
    return ProductWrapper(
      products: products ?? this.products,
    );
  }

  @override
  ProductWrapper fakeData() {
    return ProductWrapper(
      products: List.generate(
        6,
        (i) => Product(
          id: i,
          title: 'Loading Product ${i + 1}',
          description: 'Please wait...',
          price: 0.0,
          image: 'https://via.placeholder.com/150',
        ),
      ),
    );
  }

  @override
  ProductWrapper fromMap(Map<String, dynamic> json) {
    return ProductWrapper(
      products: (json['products'] as List?)
          ?.map((product) => Product.fromJson(product))
          .toList() ?? [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
```

### 3. Create a State

Create a state that extends `BaseState`:

```dart
class ProductState extends BaseState {
  ProductState({super.apiStates});

  @override
  ProductState copyWith({Map<String, BaseApiState>? apiStates}) {
    return ProductState(apiStates: apiStates ?? this.apiStates);
  }

  // Helper method to get products from API state
  List<Product> get products {
    final apiData = getData(ApiConstants.products);
    if (apiData is ProductWrapper) {
      return apiData.products;
    }
    return [];
  }

  // Helper methods for easy access
  bool get isLoading => getStatus(ApiConstants.products) == BaseStatus.loading;
  bool get hasError => getStatus(ApiConstants.products) == BaseStatus.error;
  String? get errorMessage => getError(ApiConstants.products);
}
```

### 4. Create a Cubit

Create a cubit that extends `BaseCubit`:

```dart
class ProductCubit extends BaseCubit<ProductState> {
  final ProductRepository repository;

  ProductCubit(this.repository)
      : super(ProductState(apiStates: {
          ApiConstants.products: BaseApiState(
            status: BaseStatus.initial,
            error: null,
            responseModel: null,
          ),
        }));

  Future<void> fetchProducts() async {
    handleApiCall<ProductWrapper>(
      endPoint: ApiConstants.products,
      apiCall: () async => await repository.getProducts(),
    );
  }
}
```

### 5. Use in UI

Use the `BaseBlocBuilder` or `BaseBlocConsumer` in your UI:

#### Using BaseBlocBuilder (Simple UI)

```dart
class ProductsPage extends StatelessWidget {
  final ProductCubit cubit;
  const ProductsPage({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit..fetchProducts(),
      child: BaseBlocBuilder<ProductCubit, ProductState, ProductWrapper>(
        endPoint: ApiConstants.products,
        fakeDataForShimmer: ProductWrapper(products: []).fakeData(),
        builder: (context, model) {
          return ListView.builder(
            itemCount: model.products.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(model.products[index].title),
                subtitle: Text(model.products[index].description),
                trailing: Text('\$${model.products[index].price}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(model.products[index].image),
                ),
              ),
            ),
          );
        },
        errorBuilder: (error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cubit.fetchProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

#### Using BaseBlocConsumer (With Side Effects)

```dart
class ProductsPageWithEffects extends StatelessWidget {
  final ProductCubit cubit;
  const ProductsPageWithEffects({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit..fetchProducts(),
      child: BaseBlocConsumer<ProductCubit, ProductState, ProductWrapper>(
        endPoint: ApiConstants.products,
        fakeDataForShimmer: ProductWrapper(products: []).fakeData(),
        // Listen to state changes
        onLoading: (context, state) {
          print('Products are loading...');
        },
        onSuccess: (context, state, data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Loaded ${data.products.length} products')),
          );
        },
        onError: (context, state, error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
        onInitial: (context, state) {
          print('Initial state - ready to load products');
        },
        builder: (context, model) {
          return ListView.builder(
            itemCount: model.products.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(model.products[index].title),
                subtitle: Text(model.products[index].description),
                trailing: Text('\$${model.products[index].price}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(model.products[index].image),
                ),
              ),
            ),
          );
        },
        errorBuilder: (error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cubit.fetchProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

## 🔧 API Reference

### BaseCubit Methods

#### `handleApiCall<T>({required String endPoint, required Future<Either<GFailure,T>> Function() apiCall})`

Handles API calls with automatic state management.

**Parameters:**

- `endPoint`: The API endpoint name for tracking (e.g., `ApiConstants.products`)
- `apiCall`: A function that returns a `Future<Either<GFailure, T>>`

**Behavior:**

1. Sets operation status to `loading`
2. Clears any previous errors for the operation
3. Executes the API call
4. On success: Updates response model and sets status to `success`
5. On failure: Sets status to `error` and stores error message

#### `startOperation(String operation)`

Manually starts an operation (sets loading state).

#### `successOperation(String operation, {dynamic data})`

Manually marks an operation as successful with optional data.

#### `failOperation(String operation, String error)`

Manually marks an operation as failed with error message.

### BaseState Methods

#### `getStatus(String operation)`

Returns the current status of a specific operation.

**Returns:** `BaseStatus` (initial, loading, success, error)

#### `getError(String operation)`

Returns the error message for a specific operation.

**Returns:** `String?` (null if no error)

#### `getData(String operation)`

Returns the response model for a specific operation.

**Returns:** `BaseModel?` (null if no data)

#### `getApiState(String operation)`

Returns the complete API state for a specific operation.

**Returns:** `BaseApiState`

### BaseBlocBuilder Properties

#### `endPoint` (required)

The API endpoint name to track in the state.

#### `builder` (required)

The widget builder function that receives the response model directly.

#### `fakeDataForShimmer` (required)

The fake data to display during loading state.

#### `loading` (optional)

Custom loading widget (defaults to ShimmerSkeleton).

#### `errorBuilder` (optional)

Custom error widget builder.

### BaseBlocConsumer Properties

#### All BaseBlocBuilder properties plus:

#### `onLoading` (optional)

Callback triggered when the operation starts loading.

**Signature:** `void Function(BuildContext context, S state)`

#### `onSuccess` (optional)

Callback triggered when the operation succeeds.

**Signature:** `void Function(BuildContext context, S state, T data)`

#### `onError` (optional)

Callback triggered when the operation fails.

**Signature:** `void Function(BuildContext context, S state, String error)`

#### `onInitial` (optional)

Callback triggered when the operation is in initial state.

**Signature:** `void Function(BuildContext context, S state)`

## 🎯 Best Practices

### 1. Always Use Wrapper Models

**IMPORTANT:** The `BaseBlocBuilder` and `BaseBlocConsumer` expect a `BaseModel` response, not raw data types.

```dart
// ✅ CORRECT - Use wrapper models
handleApiCall<ProductWrapper>(
  endPoint: ApiConstants.products,
  apiCall: () async => await repository.getProducts(),
);

BaseBlocBuilder<ProductCubit, ProductState, ProductWrapper>(
  builder: (context, model) {
    return ListView.builder(
      itemCount: model.products.length, // Access through wrapper
      itemBuilder: (context, index) => Text(model.products[index].title),
    );
  },
)

// ❌ WRONG - Don't use raw data types
handleApiCall<List<Product>>(...) // This will cause errors!
```

### 2. Use BaseBlocConsumer for Side Effects

Use `BaseBlocConsumer` when you need to:

- Show snackbars or dialogs
- Navigate to other screens
- Log analytics events
- Update other parts of the app

```dart
BaseBlocConsumer<ProductCubit, ProductState, ProductWrapper>(
  onSuccess: (context, state, data) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Products loaded successfully!')),
    );
  },
  onError: (context, state, error) {
    // Show error dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  },
  // ... other properties
)
```

### 3. Use BaseBlocBuilder for Simple UI

Use `BaseBlocBuilder` when you only need to display data without side effects:

```dart
BaseBlocBuilder<ProductCubit, ProductState, ProductWrapper>(
  builder: (context, model) {
    return ListView.builder(
      itemCount: model.products.length,
      itemBuilder: (context, index) => ProductCard(product: model.products[index]),
    );
  },
  // ... other properties
)
```

### 4. Endpoint Naming

Use descriptive endpoint names that match your API structure:

```dart
// Good
handleApiCall(endPoint: ApiConstants.fetchProducts, ...);

// Avoid
handleApiCall(endPoint: 'api', ...);
```

### 5. Error Handling

Always provide meaningful error messages:

```dart
// Good
return Left(GNetworkFailure(message: 'Failed to load products'));

// Avoid
return Left(GNetworkFailure(message: 'Error'));
```

### 6. Fake Data

Provide realistic fake data that matches your UI structure:

```dart
@override
BaseModel fakeData() {
  return ProductWrapper(
    products: List.generate(
      6,
      (i) => Product(
        id: i,
        title: 'Loading Product ${i + 1}',
        description: 'Please wait while we load this product...',
        price: 0.0,
        image: 'https://via.placeholder.com/150',
      ),
    ),
  );
}
```

### 7. State Helper Methods

Use helper methods in your state for easy data access:

```dart
class ProductState extends BaseState {
  // ... existing code ...

  List<Product> get products {
    final apiData = getData(ApiConstants.products);
    if (apiData is ProductWrapper) {
      return apiData.products;
    }
    return [];
  }

  bool get isLoading => getStatus(ApiConstants.products) == BaseStatus.loading;
  bool get hasError => getStatus(ApiConstants.products) == BaseStatus.error;
  String? get errorMessage => getError(ApiConstants.products);
}
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Type Mismatch Errors

**Problem:** `Class 'ProductWrapper' has no instance getter 'length'`

**Solution:** Make sure your UI expects the correct data type:

```dart
// Wrong
builder: (context, products) {
  return ListView.builder(
    itemCount: products.length, // ❌ products is ProductWrapper, not List
  );
}

// Correct
builder: (context, model) {
  return ListView.builder(
    itemCount: model.products.length, // ✅ Access through .products
  );
}
```

#### 2. State Not Updating

Make sure you're using the correct endpoint name in your UI:

```dart
// In cubit
handleApiCall(endPoint: ApiConstants.products, ...);

// In UI - must match!
BaseBlocBuilder(
  endPoint: ApiConstants.products, // Must match the endpoint name
  // ...
)
```

#### 3. Loading State Not Showing

Ensure you have fake data provided:

```dart
BaseBlocBuilder(
  fakeDataForShimmer: ProductWrapper(products: []).fakeData(), // Required for loading state
  // ...
)
```

#### 4. Error State Not Showing

Check that your API call returns a `Left` with a failure:

```dart
handleApiCall(
  apiCall: () async {
    try {
      final result = await api.call();
      return Right(result);
    } catch (e) {
      return Left(GNetworkFailure(message: e.toString()));
    }
  },
);
```

#### 5. Listener Not Triggering

Make sure you're using `BaseBlocConsumer` instead of `BaseBlocBuilder` when you need listeners:

```dart
// For side effects, use BaseBlocConsumer
BaseBlocConsumer<ProductCubit, ProductState, ProductWrapper>(
  onSuccess: (context, state, data) {
    // This will be called when data loads successfully
  },
  // ... other properties
)

// For simple UI only, use BaseBlocBuilder
BaseBlocBuilder<ProductCubit, ProductState, ProductWrapper>(
  // No listener callbacks available
  // ... other properties
)
```

## 📝 Complete Examples

### User List Example (Correct Implementation)

```dart
// 1. Model
class User extends BaseModel {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }

  @override
  BaseModel fromMap(Map<String, dynamic> json) => User.fromJson(json);
  @override
  Map<String, dynamic> toMap() => toJson();
  @override
  BaseModel copyWith() => User(name: name, email: email);
  @override
  BaseModel fakeData() => User(name: 'Loading...', email: 'loading@example.com');
}

// 2. Wrapper Model (Required!)
class UserWrapper extends BaseModel {
  final List<User> users;

  UserWrapper({required this.users});

  @override
  UserWrapper copyWith({List<User>? users}) {
    return UserWrapper(users: users ?? this.users);
  }

  @override
  UserWrapper fakeData() {
    return UserWrapper(
      users: List.generate(5, (i) => User(name: 'Loading User ${i + 1}', email: 'loading@example.com')),
    );
  }

  @override
  UserWrapper fromMap(Map<String, dynamic> json) {
    return UserWrapper(
      users: (json['users'] as List?)
          ?.map((user) => User.fromJson(user))
          .toList() ?? [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}

// 3. State
class UserState extends BaseState {
  UserState({super.apiStates});

  @override
  UserState copyWith({Map<String, BaseApiState>? apiStates}) {
    return UserState(apiStates: apiStates ?? this.apiStates);
  }

  List<User> get users {
    final data = getData(ApiConstants.users);
    if (data is UserWrapper) {
      return data.users;
    }
    return [];
  }
}

// 4. Cubit
class UserCubit extends BaseCubit<UserState> {
  UserCubit() : super(UserState());

  Future<void> fetchUsers() async {
    handleApiCall<UserWrapper>( // ✅ Use wrapper model
      endPoint: ApiConstants.users,
      apiCall: () async {
        final response = await userService.getUsers();
        return Right(response);
      },
    );
  }
}

// 5. UI with BaseBlocConsumer (with side effects)
class UserPageWithEffects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..fetchUsers(),
      child: BaseBlocConsumer<UserCubit, UserState, UserWrapper>( // ✅ Use consumer
        endPoint: ApiConstants.users,
        fakeDataForShimmer: UserWrapper(users: []).fakeData(),
        onLoading: (context, state) {
          print('Loading users...');
        },
        onSuccess: (context, state, data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Loaded ${data.users.length} users')),
          );
        },
        onError: (context, state, error) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(error),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
        builder: (context, model) { // ✅ Receive wrapper model
          return ListView.builder(
            itemCount: model.users.length, // ✅ Access through wrapper
            itemBuilder: (context, index) => ListTile(
              title: Text(model.users[index].name), // ✅ Access through wrapper
              subtitle: Text(model.users[index].email),
            ),
          );
        },
      ),
    );
  }
}

// 6. UI with BaseBlocBuilder (simple UI only)
class UserPageSimple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..fetchUsers(),
      child: BaseBlocBuilder<UserCubit, UserState, UserWrapper>( // ✅ Use builder
        endPoint: ApiConstants.users,
        fakeDataForShimmer: UserWrapper(users: []).fakeData(),
        builder: (context, model) { // ✅ Receive wrapper model
          return ListView.builder(
            itemCount: model.users.length, // ✅ Access through wrapper
            itemBuilder: (context, index) => ListTile(
              title: Text(model.users[index].name), // ✅ Access through wrapper
              subtitle: Text(model.users[index].email),
            ),
          );
        },
      ),
    );
  }
}
```

## 🤝 Contributing

When adding new features to the base cubit architecture:

1. Maintain backward compatibility
2. Add comprehensive documentation
3. Include usage examples
4. Update this README
5. Test thoroughly with different scenarios

## 📄 License

This base cubit architecture is part of the Gomla app and follows the same licensing terms.
