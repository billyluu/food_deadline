# 鮮食管家 (FreshKeeper)

<div align="center">
  <img src="resource/appicon/app_icon.png" alt="鮮食管家" width="120" height="120">
  
  <h3>智慧食物保鮮期管理應用</h3>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.24.4-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.5.0+-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
  [![Claude Code](https://img.shields.io/badge/Claude%20Code-AI%20Assisted-orange.svg)](https://claude.ai/code)
</div>

## 📱 關於應用

鮮食管家是一款智慧食物保鮮期管理應用，幫助您有效管理食物的有效期限，減少食物浪費。

### ✨ 主要功能

- 🍎 **食物管理** - 添加、編輯、刪除食物項目
- ⏰ **智慧提醒** - 自動提醒食物即將過期
- 📊 **統計分析** - 查看食物總數和過期統計
- 🔔 **通知系統** - 可自訂通知時間和頻率
- 🌐 **多語言** - 支援中文/英文切換
- 🎨 **深色模式** - 自動適配系統主題
- 💾 **離線存儲** - 使用 Realm 數據庫本地存儲

### 📸 功能截圖

```
[首頁] → [設定] → [添加食物] → [通知設定]
```

## 🏗️ 技術架構

### 核心技術棧
- **Flutter** - 跨平台UI框架
- **Dart** - 程式語言
- **BLoC** - 狀態管理
- **Realm** - 本地數據庫
- **GetIt** - 依賴注入

### 主要依賴
```yaml
dependencies:
  flutter_bloc: ^9.0.0          # 狀態管理
  realm: ^20.0.1                # 本地數據庫
  flutter_local_notifications: ^18.0.1  # 本地通知
  get_it: ^8.0.2                # 依賴注入
  shared_preferences: ^2.5.2    # 本地存儲
  permission_handler: ^11.0.1   # 權限管理
  intl: ^0.19.0                 # 國際化
```

## 🚀 快速開始

### 環境要求
- Flutter 3.24.4 (使用 FVM 管理)
- Dart 3.5.0+
- Android SDK 21+
- iOS 11.0+
- FVM (Flutter Version Management)

### 安裝步驟

1. **Clone**
   ```bash
   git clone https://github.com/your-username/food_deadline.git
   cd food_deadline
   ```

2. **設定 FVM 版本**
   ```bash
   # 安裝 FVM（如果尚未安裝）
   dart pub global activate fvm
   
   # 安裝並使用 Flutter 3.24.4
   fvm install 3.24.4
   fvm use 3.24.4
   ```

3. **安裝依賴**
   ```bash
   fvm flutter pub get
   ```

4. **Generate**
   ```bash
   # 一鍵生成所有代碼
   fvm dart run bin/build.dart
   
   # 或者分別執行
   fvm dart run realm generate                                    # 生成 Realm 模型
   fvm dart run build_runner build --delete-conflicting-outputs  # 生成國際化代碼
   fvm flutter pub run flutter_launcher_icons:main               # 生成應用圖標
   ```

5. **運行應用**
   ```bash
   fvm flutter run
   ```

## 📝 開發指南

### 項目結構
```
lib/
├── core/                    # 核心功能
│   ├── constants/          # 常量定義
│   ├── di/                 # 依賴注入
│   ├── errors/             # 錯誤處理
│   ├── realm/              # 數據庫模型
│   └── utils/              # 工具類
├── features/               # 功能模塊
│   ├── home/              # 首頁
│   ├── settings/          # 設定頁
│   ├── splash/            # 啟動頁
│   └── dialog/            # 對話框
├── shared/                # 共享組件
│   └── widgets/           # 通用UI組件
└── main.dart              # 應用入口
```

### 國際化開發

#### 自動生成 AppString 枚舉

專案提供了一個便利的工具來自動生成 AppString 枚舉，避免手動維護的麻煩。

1. **編輯語言檔案**
   ```bash
   # 編輯語言檔案，添加新的鍵值對
   resource/i18n/zh.json
   resource/i18n/en.json
   ```

   例如：
   ```json
   // resource/i18n/zh.json
   {
     "app_name": "鮮食管家",
     "new_feature_title": "新功能標題",
     "new_feature_description": "新功能描述"
   }
   ```

2. **執行自動生成工具**
   ```bash
   # 執行自動生成 AppString 枚舉
   fvm dart run bin/resources_to_enum.dart
   ```

3. **複製生成的代碼**
   - 工具會在 `lib/generated/app_string.s.dart` 生成完整的枚舉代碼
   - 複製生成的內容到 `lib/core/constants/app_string.dart`

4. **使用方式**
   ```dart
   // 生成的枚舉會自動轉換為 camelCase
   // new_feature_title -> newFeatureTitle
   Text(AppString.newFeatureTitle.getI18n(context))
   
   // 支援參數替換
   Text(AppString.welcomeMessage.getI18n(context, ['用戶名']))
   ```

#### 工具特色
- ✅ **自動化** - 一鍵生成所有枚舉
- ✅ **鍵值同步** - 確保中英文鍵值完全一致
- ✅ **命名轉換** - 自動將 snake_case 轉換為 camelCase
- ✅ **錯誤檢查** - 檢查檔案是否存在
- ✅ **統計資訊** - 顯示處理的鍵值數量

#### 傳統方法（手動）
如果需要手動添加個別鍵值：
```bash
# 生成國際化代碼
fvm dart run build_runner build --delete-conflicting-outputs
```

### 數據庫模型

#### 生成 Realm 模型
```bash
# 修改模型後執行
fvm dart run realm generate
```

#### 新增模型範例
```dart
@RealmModel()
class _NewModel {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late int timestamp;
}
```

### 通知系統

#### 權限設定
應用會在啟動時自動請求必要權限：
- 通知權限
- 精確鬧鐘權限（Android 12+）

#### 通知排程
```dart
// 為食物項目排程通知
await notificationService.scheduleExpiryNotifications(item);
```

## 🎨 自定義配置

### 主題顏色
在 `lib/core/constants/color.dart` 中修改：
```dart
const myColorScheme = ColorScheme(
  primary: Color(0xFF2E7D32),  // 主色
  secondary: Color(0xFF66BB6A), // 次要色
  // ...
);
```

### 應用圖標
1. 替換 `resource/appicon/app_icon.png`
2. 執行 `fvm flutter pub run flutter_launcher_icons:main`

### 通知設定
在 `lib/core/constants/app_constants.dart` 中修改：
```dart
class AppConstants {
  static const List<int> notificationDaysOptions = [1, 2, 3, 5, 7, 14];
  static const int defaultNotificationDays = 3;
}
```

## 🔧 調試功能

### Debug 模式專用功能
- 查看排程通知列表
- 僅在 Debug 模式下顯示

### 日誌查看
```bash
# 查看 Flutter 日誌
fvm flutter logs

# 查看 Android 日誌
adb logcat -s flutter
```

## 📦 構建發布

### Android
```bash
# 生成 APK
fvm flutter build apk --release

# 生成 AAB
fvm flutter build appbundle --release
```

### iOS
```bash
# 生成 iOS
fvm flutter build ios --release
```

## 🤝 貢獻指南

1. Fork 此項目
2. 創建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 創建 Pull Request

## 📄 許可證

此項目基於 MIT 許可證 - 查看 [LICENSE](LICENSE) 文件了解詳情。

## 📞 聯繫我們

- 問題回報：[Issues](https://github.com/your-username/food_deadline/issues)
- 功能建議：[Discussions](https://github.com/your-username/food_deadline/discussions)

## 🙏 致謝

感謝所有為這個項目做出貢獻的開發者們！

## 🤖 AI 輔助開發

此專案使用 [Claude Code](https://claude.ai/code) 進行輔助開發，包含：

- 🏗️ **架構設計** - 依賴注入、狀態管理、錯誤處理
- 🔧 **程式碼重構** - 優化現有程式碼結構
- 🌐 **國際化實作** - 多語言支援系統
- 🔔 **通知系統** - 本地通知與權限管理
- 📱 **UI/UX 改進** - 主題設計與使用者介面優化
- 🧪 **開發工具** - 自動化構建腳本與代碼生成
- 📝 **文檔撰寫** - 完整的 README 與開發指南

AI 輔助開發幫助提升了開發效率並確保了代碼品質。

---

<div align="center">
  Made with ❤️ by Flutter & 🤖 Claude Code
</div>