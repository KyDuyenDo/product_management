
# Product Management Client

A Flutter application for managing products with features like listing, searching, filtering, adding, editing, and deleting products.

## 🧰 Technology Stack

### Core Technologies
- **Framework**: Flutter 3.4.4+
- **Language**: Dart 3.4.4+
- **State Management**: BLoC Pattern with flutter_bloc
- **Architecture**: Clean Architecture
- **Database**: SQLite (via sqflite)
- **HTTP Client**: http package
- **Dependency Injection**: get_it
- **Error Handling**: dartz for Either type
- **Image Handling**: image_picker
- **Image Upload**: ImgBB API integration

### Main Libraries & Dependencies

#### State Management & Architecture
- **flutter_bloc**: ^8.1.6  
- **equatable**: ^2.0.5  
- **dartz**: ^0.10.1  
- **get_it**: ^7.7.0  

#### Networking & Data
- **http**: ^1.2.2  
- **sqflite**: ^2.3.3  
- **path**: ^1.9.0  

#### UI & Media
- **google_fonts**: ^6.2.1  
- **image_picker**: ^1.1.2  
- **cupertino_icons**: ^1.0.6  

#### Development Tools
- **flutter_lints**: ^3.0.0  
- **flutter_test**: SDK

### External Services
- **ImgBB API**
- **RESTful API Backend**

---

## 🧱 Architecture

Follows Clean Architecture with 3 layers:

### 1. Presentation Layer
- BLoC for UI state
- Pages, widgets, models

### 2. Domain Layer
- Entities, use cases, repository interfaces, failures

### 3. Data Layer
- Repositories, local/remote sources, DTOs

### Patterns Used
- Repository, Use Case, Factory, Observer (BLoC), DI

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── database/
│   ├── injection/
│   ├── enum/
│   ├── error/
│   ├── network/
│   ├── services/
│   ├── usecase/
│   └── utils/
├── features/
│   └── product/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecase/
│       └── presentation/
│           ├── bloc/
│           ├── model/
│           ├── pages/
│           └── widgets/
└── main.dart
```

---

## ✨ Features

### Core
- Product listing, search, filter, CRUD, image upload
- Category management

### Technical
- Offline support, error handling, loading states
- Responsive UI, image optimization, validation

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.4.4+
- Dart SDK 3.4.4+
- Android Studio or VS Code
- Device/emulator
- Running backend

### Installation

```bash
git clone https://github.com/yourusername/product-management-client.git
cd product-management-client
flutter pub get
flutter run
```

---

## 🌐 API Endpoints Required

- `GET /products`
- `GET /products/:id`
- `POST /products`
- `PUT /products/:id`
- `DELETE /products/:id`
- `GET /categories`
- `POST /products/:id/images`

---

## 🔁 Data Flow

1. User → UI
2. UI → BLoC Event
3. BLoC → Use Case
4. Use Case → Repository
5. Repository → Data Sources
6. Result → BLoC → UI State

---

## 🛡 Error Handling

- **Either<Failure, Success>** pattern  
- Server, Cache, Network, Validation failures  
- User-friendly messages

---

## 💽 Caching Strategy

**Cache-first** logic:  
Online → API → Update cache → UI  
Offline → Load from cache  
Graceful fallback

---

## 🏗 Building for Production

```bash
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release
```

---

## 🧪 Testing

```bash
flutter test
flutter test --coverage
flutter test test/features/product/
```

---

## ⚙️ Performance Considerations

- Lazy-load and cache images
- SQLite indexing
- Memory-safe state management
- API debounce + cache

---

## 🤝 Contributing

1. Fork repo  
2. Create feature branch  
3. Follow code style  
4. Add tests  
5. Commit & push  
6. Open PR

---

## 📜 License

MIT License - see LICENSE file.

---

## 📬 Support

Open an issue on GitHub if you need help.
---
✅ Note: The server has been deployed on Render at:
🌍 https://mock-api-bjd9.onrender.com

👉 You only need to run the Flutter app, no need to start the local server.
