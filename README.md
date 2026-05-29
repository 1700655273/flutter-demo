# Flutter 主流框架 Demo

基于 **Clean Architecture** 架构，集成 Flutter 主流开发框架的示例项目。

## 环境要求

| 工具 | 最低版本 |
|------|---------|
| Flutter | 3.27.0+ |
| Dart | 3.3.0+ |
| Gradle | 8.9 |
| AGP | 8.7.0 |
| Kotlin | 2.1.0 |
| Java | 17+ |
| Android minSdk | 21 |

## 技术栈

| 技术 | 包名 | 版本 | 说明 |
|------|-------|------|------|
| 状态管理 | `flutter_riverpod` | ^2.5.1 | Provider + StateNotifier 模式 |
| 路由管理 | `go_router` | ^14.2.0 | StatefulShellRoute 声明式路由 |
| 网络请求 | `dio` | ^5.4.3 | DioException + 拦截器 + 统一错误处理 |
| 网络调试 | `pretty_dio_logger` | ^1.4.0 | 控制台美化日志（Debug 模式） |
| 网络调试 | OkHttp Profiler 桥接 | — | MethodChannel → Log.v() 写入 Logcat |
| 远程日志 | `sentry_flutter` + `sentry_dio` | ^8.0.0 | 错误追踪 + 网络请求追踪 + 结构化日志 |
| 本地存储 | `shared_preferences` | ^2.3.4 | KV 持久化存储 |
| JSON 序列化 | `json_annotation` | ^4.9.0 | 数据模型注解 |
| UI 框架 | Material 3 | — | 动态色彩设计系统 |
| 构建工具 | Gradle 8.9 + AGP 8.7 | — | 声明式插件 + includeBuild |

## 项目结构

```
lib/
├── main.dart                              # 应用入口（ProviderScope + MaterialApp.router）
├── core/                                  # 核心层
│   ├── theme/                             # 主题配置
│   │   ├── app_theme.dart                 #   Material 3 亮色/暗色主题定义
│   │   └── theme_provider.dart            #   Riverpod 主题状态管理 + SharedPreferences 持久化
│   ├── network/                           # 网络封装
│   │   └── dio_client.dart               #   Dio 5 封装（日志拦截器 + 错误拦截器）
│   ├── router/                           # 路由配置
│   │   └── app_router.dart                #   GoRouter 14 + StatefulShellRoute 底部导航
│   ├── constants/                         # 常量定义
│   │   └── app_constants.dart             #   API 地址、超时时间、存储 Key
│   └── utils/                             # 工具类
│       └── snack_bar_util.dart            #   统一 SnackBar 提示
├── features/                              # 功能模块（按功能划分）
│   ├── home/                              # 首页
│   │   ├── presentation/pages/            #   轮播横幅 + 功能入口 + 架构图示
│   │   └── providers/                     #   轮播数据 Provider
│   ├── counter/                           # 计数器
│   │   ├── presentation/pages/            #   计数器页面 + Riverpod 概念说明
│   │   └── providers/                     #   StateNotifier<Counter>
│   ├── users/                             # 用户列表（Clean Architecture 三层分离）
│   │   ├── data/                          #   ┌ 数据层
│   │   │   ├── models/user_model.dart     #   │ JSON ↔ Entity 转换
│   │   │   └── datasources/               #   │ 远程数据源（Dio 请求）
│   │   ├── domain/                        #   │ 领域层
│   │   │   └── entities/user.dart         #   │ 纯 Dart 业务实体
│   │   └── presentation/                 #   │ 展示层
│   │       ├── pages/users_page.dart       #   │ 四态 UI（加载/成功/错误/空）
│   │       └── providers/                  #   │ StateNotifier + sealed UiState
│   ├── animation/                         # 动画展示
│   │   └── presentation/pages/            #   隐式/显式/Hero 三类动画 Tab 页
│   └── settings/                          # 设置
│       └── presentation/pages/            #   主题切换 + 技术栈 + 项目结构图
└── shared/                                # 共享组件
    └── widgets/                           #   通用 Loading / Error 组件
```

## 功能模块

### 🏠 首页
- 自动轮播横幅（PageView + 自动滚动）
- 功能入口网格卡片（SliverGrid）
- Clean Architecture 三层架构图示

### 🔢 计数器
- **Riverpod** StateNotifier 状态管理
- `ref.watch` / `ref.read` 使用演示
- AnimatedSwitcher 数字切换动画
- Riverpod 核心概念说明卡片

### 👥 用户列表
- **Clean Architecture** 三层分离（Domain / Data / Presentation）
- **Dio 5** 网络请求 + JSONPlaceholder API
- `sealed class UiState` 四态处理（Initial / Loading / Success / Error）
- switch 表达式模式匹配渲染
- 用户卡片详情（公司信息 + 联系方式）

### 🎬 动画展示
- **隐式动画**：AnimatedContainer / AnimatedScale / AnimatedOpacity
- **显式动画**：AnimationController + CurvedAnimation（旋转+缩放）
- **Hero 过渡**：共享元素页面转场

### ⚙️ 设置
- 亮色 / 暗色 / 跟随系统主题切换
- SharedPreferences 本地持久化
- 技术栈说明 + 项目结构树形图

## 架构设计

### Clean Architecture 分层

```
┌──────────────────────────────────────────────────────┐
│  Presentation Layer                                  │
│  UI Widgets + Riverpod Provider/StateNotifier       │
│  ↓ ref.read(repositoryProvider)                     │
├──────────────────────────────────────────────────────┤
│  Domain Layer                                        │
│  Entity（纯 Dart）+ Repository 抽象接口              │
│  ↓ implemented by                                    │
├──────────────────────────────────────────────────────┤
│  Data Layer                                          │
│  DataSource（Dio）+ Model（JSON 序列化）             │
│  + Repository 实现                                   │
└──────────────────────────────────────────────────────┘
```

**核心原则：**
- **依赖规则**：外层依赖内层，内层不依赖外层
- **Domain Layer** 纯 Dart，不依赖 Flutter 框架
- **Data Layer** 实现 Domain 定义的 Repository 接口
- **Presentation Layer** 通过 Riverpod Provider 注入 Repository

### 状态管理架构

```
UiState<T> (sealed class)
├── UiInitial<T>     → 空状态页面
├── UiLoading<T>     → Loading 指示器
├── UiSuccess<T>     → 数据展示
└── UiError<T>       → 错误提示 + 重试按钮

StateNotifier<UiState<T>>
    ↑
    │ fetchUsers() / refresh()
    │
UserRepository (abstract)
    ↑ implements
UserRepositoryImpl
    ↑ depends on
UserRemoteDataSource (Dio)
```

### 路由架构

```
GoRouter
└── StatefulShellRoute.indexedStack
    ├── Branch 0: /           → HomePage
    ├── Branch 1: /counter    → CounterPage
    ├── Branch 2: /users     → UsersPage
    ├── Branch 3: /animation → AnimationPage
    └── Branch 4: /settings  → SettingsPage
        ↓
    AppShell (NavigationBar)
```

## 运行

```bash
# 获取依赖
flutter pub get

# 运行 (Android)
flutter run

# 运行 (Web)
flutter run -d chrome

# 构建 APK
flutter build apk --release

# 构建 Web
flutter build web --release
```

## 国内环境配置

项目已预配置国内镜像源，避免 SSL 证书和网络问题：

| 配置项 | 镜像源 |
|--------|--------|
| Gradle 下载 | `mirrors.cloud.tencent.com/gradle` |
| Maven 仓库 | `maven.aliyun.com/repository/google` |
| Maven 中央 | `maven.aliyun.com/repository/central` |
| Gradle 插件 | `maven.aliyun.com/repository/gradle-plugin` |
| Flutter 资源 | `storage.flutter-io.cn`（环境变量 `PUB_HOSTED_URL`） |

## 网络调试工具

### 1. OkHttp Profiler（Android Studio 集成）

Flutter Dio 请求默认不会出现在 Android Studio 的 OkHttp Profiler 中（因为不走 Android OkHttp 层）。本项目通过 **MethodChannel 桥接**，将 Dio 请求数据按 OkHttp Profiler 的 Logcat 协议写入，使其在 Profiler 中可见。

**原理：**
```
Dio Interceptor → MethodChannel → Android Log.v() → Logcat → OkHttp Profiler 插件读取
```

**使用方式：** 无需额外配置，运行 Android 版本后打开 AS 的 OkHttp Profiler 即可看到网络请求。

**涉及文件：**
- `lib/core/network/okhttp_profiler_interceptor.dart` — Dio 拦截器
- `android/app/.../MainActivity.kt` — MethodChannel 接收端

### 2. Pretty Dio Logger（控制台美化日志）

Debug 模式下自动在控制台输出格式化的网络请求日志：

```
┌───────────────────────────────────────────────────
│ POST /users
├───────────────────────────────────────────────────
│ Content-Type: application/json
│ Accept: application/json
├───────────────────────────────────────────────────
│ {"name": "test"}
├───────────────────────────────────────────────────
│ 200 OK (325ms)
│ [{"id":1,"name":"Leanne Graham"}]
└───────────────────────────────────────────────────
```

仅在 `kDebugMode` 下启用，Release 版本不会输出。

### 3. Sentry 远程日志（后台按日期查看）

集成 Sentry 实现远程日志查看，支持按日期筛选：

**Sentry 免费版额度：**
| 项目 | 额度 |
|------|------|
| 错误事件 | 5,000 条/月 |
| 网络请求追踪 (Spans) | 500 万条/月 |
| 结构化日志 | 5 GB/月 |
| 保留期 | 30 天 |

**配置步骤：**
1. 在 [sentry.io](https://sentry.io) 注册免费账号并创建 Flutter 项目
2. 获取 DSN（格式：`https://xxx@oxxx.ingest.sentry.io/xxx`）
3. 替换 `lib/core/constants/app_constants.dart` 中的 `sentryDsn`

```dart
// 替换为你的 Sentry DSN
static const String sentryDsn = 'https://yourPublicKey@yourOrg.ingest.sentry.io/yourProjectId';
```

**Sentry 控制台功能：**
- 📊 **Tracing** — 查看所有网络请求耗时、状态码
- 📝 **Structured Logs** — 按日期/级别/关键词筛选日志
- 🔗 **Breadcrumbs** — 查看请求上下文链路
- ❌ **Errors** — 错误自动关联网络请求

**Dio 拦截器链（按执行顺序）：**
```
1. OkHttpProfilerInterceptor  → Logcat 写入（仅 Android）
2. SentryTracingInterceptor   → Sentry 远程追踪
3. _ErrorInterceptor          → 统一错误处理
4. PrettyDioLogger            → 控制台美化（仅 Debug）
```
