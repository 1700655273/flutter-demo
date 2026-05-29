# Flutter 主流框架 Demo

基于 **Clean Architecture** 架构，集成 Flutter 主流开发框架的示例项目。

## 技术栈

| 技术 | 包名 | 说明 |
|------|-------|------|
| 状态管理 | `flutter_riverpod` | Provider + StateNotifier 模式 |
| 路由管理 | `go_router` | 声明式路由 + ShellRoute |
| 网络请求 | `dio` | 拦截器 + 统一错误处理 |
| 本地存储 | `shared_preferences` | KV 持久化存储 |
| UI 框架 | Material 3 | 动态色彩设计系统 |

## 项目结构

```
lib/
├── main.dart                          # 应用入口
├── core/                               # 核心层
│   ├── theme/                          # 主题配置 + Provider
│   ├── network/                        # Dio 网络封装
│   ├── router/                        # GoRouter 路由配置
│   ├── constants/                      # 常量定义
│   └── utils/                          # 工具类
├── features/                           # 功能模块
│   ├── home/                           # 首页（轮播图 + 功能入口）
│   ├── counter/                        # 计数器（Riverpod 状态管理）
│   ├── users/                          # 用户列表（Clean Architecture）
│   │   ├── data/                       # 数据层
│   │   │   ├── models/                 # 数据模型（JSON 序列化）
│   │   │   └── datasources/            # 远程数据源
│   │   ├── domain/                     # 领域层
│   │   │   └── entities/               # 业务实体
│   │   └── presentation/               # 展示层
│   │       ├── pages/                   # 页面
│   │       └── providers/               # 状态管理
│   ├── animation/                      # 动画展示
│   └── settings/                       # 设置（主题切换）
└── shared/                             # 共享组件
    └── widgets/                        # 通用组件
```

## 功能模块

### 首页
- 自动轮播横幅
- 功能入口网格卡片
- Clean Architecture 三层架构图示

### 计数器
- Riverpod StateNotifier 状态管理
- `ref.watch` / `ref.read` 使用演示
- AnimatedSwitcher 动画计数

### 用户列表
- **Clean Architecture** 三层分离
- Dio 网络请求 + JSONPlaceholder API
- 加载/成功/错误/空 四态处理
- 下拉刷新

### 动画展示
- 隐式动画：AnimatedContainer / AnimatedScale / AnimatedOpacity
- 显式动画：AnimationController + CurvedAnimation
- Hero 过渡动画

### 设置
- 亮色/暗色/跟随系统 主题切换
- SharedPreferences 本地持久化
- 技术栈说明 + 项目结构图

## 运行

```bash
# 获取依赖
flutter pub get

# 运行 (Web)
flutter run -d chrome

# 运行 (macOS)
flutter run -d macos

# 构建 Web
flutter build web --release
```

## 架构设计

### Clean Architecture 分层

```
┌─────────────────────────────────┐
│     Presentation Layer          │  UI + Riverpod Provider
├─────────────────────────────────┤
│     Domain Layer                │  Entity + Repository 接口
├─────────────────────────────────┤
│     Data Layer                  │  DataSource + Model + Repository 实现
└─────────────────────────────────┘
```

- **依赖规则**：外层依赖内层，内层不依赖外层
- **Domain Layer** 纯 Dart，不依赖 Flutter
- **Data Layer** 实现 Domain 定义的仓库接口
- **Presentation Layer** 通过 Provider 注入 Repository
