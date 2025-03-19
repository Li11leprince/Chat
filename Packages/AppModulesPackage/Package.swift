// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Helpers

/// Decribes module dependency that can be external or internal
protocol AppModuleDependency {
    /// Provider module as `Target.Dependency`
    var targetDependency: Target.Dependency { get }
}

/// Decribes app module, can be product or test
final class AppModule: AppModuleDependency {
    /// Name
    let name: String
    /// Path to source code
    let path: String
    /// Path to app resources
    let resourcePath: String?
    /// Dependencies for current module
    let dependencies: [any AppModuleDependency]
    /// Describes whether it is test module
    let isTestModule: Bool
    /// Describes plugins are used
    let plugins: [Target.PluginUsage]

    var targetDependency: Target.Dependency { .target(name: name) }
    /// Provides module as library product
    var libraryProduct: Product { .library(name: name, targets: [name]) }
    /// Provides module as `Target`
    var target: Target { makeTarget() }

    /// Makes product module
    static func makeModule(name: String, resourcePath: String? = nil, dependencies: [AppModuleDependency] = [], plugins: [Target.PluginUsage] = []) -> AppModule {
        AppModule(
            name: name,
            path: "Sources/\(name)/Sources",
            resourcePath: resourcePath,
            dependencies: dependencies,
            isTestModule: false,
            plugins: plugins
        )
    }

    /// Makes test module
    static func makeTestModule(name: String, resourcePath: String? = nil, dependencies: [AppModuleDependency] = [], plugins: [Target.PluginUsage] = []) -> AppModule {
        let testedModuleName = name.dropLast("Tests".count)
        return AppModule(
            name: name,
            path: "Sources/\(testedModuleName)/Tests",
            resourcePath: resourcePath,
            dependencies: dependencies,
            isTestModule: true,
            plugins: plugins
        )
    }

    private init(name: String, path: String, resourcePath: String? = nil, dependencies: [AppModuleDependency] = [], isTestModule: Bool = false, plugins: [Target.PluginUsage] = []) {
        self.name = name
        self.path = path
        self.resourcePath = resourcePath
        self.dependencies = dependencies
        self.isTestModule = isTestModule
        self.plugins = plugins
    }

    private func makeTarget() -> Target {
        let deps = dependencies.map(\.targetDependency)
        let resources: [Resource]? = resourcePath.map { path in
            [Resource.process(path)]
        }

        if isTestModule {
            return .testTarget(name: name, dependencies: deps, path: path, resources: resources, plugins: plugins)
        } else {
            return .target(name: name, dependencies: deps, path: path, resources: resources, plugins: plugins)
        }
    }
}

/// Describes external package
final class ExternalPackage: AppModuleDependency {
    /// Product name to use as dependency
    let productName: String
    /// Package name in which product is defined
    let packageName: String
    /// `Package.Dependency` info
    let dependency: Package.Dependency

    var targetDependency: Target.Dependency { .product(name: productName, package: packageName) }

    init(productName: String, packageName: String? = nil, dependency: Package.Dependency) {
        self.productName = productName
        self.packageName = packageName ?? productName
        self.dependency = dependency
    }
}

// MARK: - Package Configuration

// swiftlint:disable orphaned_doc_comment
/// -----------------------------------------------------------------------
///
/// Configuration must be defined above of `let package` in the file
///
/// -----------------------------------------------------------------------
// swiftlint:enable orphaned_doc_comment

// MARK: - External Module Declarations

/// Describes External Modules
enum ExternalModules {
    static let iqKeyboardManager = ExternalPackage(
        productName: "IQKeyboardManagerSwift",
        packageName: "IQKeyboardManager",
        dependency: .package(
            url: "https://github.com/hackiftekhar/IQKeyboardManager.git",
            from: "6.5.0"
        )
    )
    static let tweeTextField = ExternalPackage(
        productName: "TweeTextField",
        dependency: .package(
            url: "https://github.com/oleghnidets/TweeTextField.git",
            from: "1.6.3"
        )
    )
    static let alamofire = ExternalPackage(
        productName: "Alamofire",
        dependency: .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.6.1"
        )
    )
    static let sdWebImage = ExternalPackage(
        productName: "SDWebImage",
        dependency: .package(
            url: "https://github.com/SDWebImage/SDWebImage.git",
            from: "5.1.0"
        )
    )
    static let sdWebImageWebPCoder = ExternalPackage(
        productName: "SDWebImageWebPCoder",
        dependency: .package(
            url: "https://github.com/SDWebImage/SDWebImageWebPCoder.git",
            from: "0.3.0"
        )
    )
    static let snapKit = ExternalPackage(
        productName: "SnapKit",
        dependency: .package(
            url: "https://github.com/SnapKit/SnapKit.git",
            from: "5.0.1"
        )
    )
    static let progressHUD = ExternalPackage(
        productName: "JGProgressHUD",
        dependency: .package(
            url: "https://github.com/JonasGessner/JGProgressHUD.git",
            from: "2.2.0"
        )
    )
    static let rSwift = ExternalPackage(
        productName: "RswiftLibrary",
        packageName: "R.swift",
        dependency: .package(
            url: "https://github.com/mac-cain13/R.swift.git",
            from: "7.8.0"
        )
    )
    static let firebaseAnalytics = ExternalPackage(
        productName: "FirebaseAnalytics",
        packageName: "Firebase",
        dependency: .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.6.0"
        )
    )
    static let firebaseAuth = ExternalPackage(
        productName: "FirebaseAuth",
        packageName: "firebase-ios-sdk",
        dependency: .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.6.0"
        )
    )
    static let firebaseCrashlytics = ExternalPackage(
        productName: "FirebaseCrashlytics",
        packageName: "Firebase",
        dependency: .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.6.0"
        )
    )
    static let firebaseFirestore = ExternalPackage(
        productName: "FirebaseFirestore",
        packageName: "Firebase",
        dependency: .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.6.0"
        )
    )
    static let firebaseMessaging = ExternalPackage(
        productName: "FirebaseMessaging",
        packageName: "Firebase",
        dependency: .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.6.0"
        )
    )
    static let firebaseCore = ExternalPackage(
        productName: "FirebaseCore",
        packageName: "firebase-ios-sdk",
        dependency: .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "11.6.0"
        )
    )
    static let lottie = ExternalPackage(
        productName: "Lottie",
        dependency: .package(
            url: "https://github.com/airbnb/lottie-spm.git",
            from: "4.5.1"
        )
    )
    static let toCropViewController = ExternalPackage(
        productName: "TOCropViewController",
        dependency: .package(
            url: "https://github.com/TimOliver/TOCropViewController.git",
            from: "2.7.4"
        )
    )
}

// MARK: - External plugins

enum ExternalPlugins {
    static let rSwiftPlugin: Target.PluginUsage = .plugin(
        name: "RswiftGeneratePublicResources",
        package: "R.swift"
    )
}

// MARK: - Internal Module Declarations

/// Describes Internal Modules
enum InternalModules {

    // MARK: - App Independant Modules

    static let utilitiesModule: AppModule = .makeModule(
        name: "Utilities",
        dependencies: [ExternalModules.iqKeyboardManager]
    )

    // MARK: - App Common Modules

    static let appEntitiesModule: AppModule = .makeModule(
        name: "AppEntities",
        dependencies: [utilitiesModule]
    )

    static let appDesignSystemModule: AppModule = .makeModule(
        name: "AppDesignSystem",
        resourcePath: "Resources",
        dependencies: [
            utilitiesModule,
            ExternalModules.tweeTextField,
            ExternalModules.progressHUD,
            ExternalModules.rSwift
        ],
        plugins: [
            ExternalPlugins.rSwiftPlugin
        ]
    )
    
    static let appDesignSystemTestsModule: AppModule = .makeTestModule(
        name: "AppDesignSystemTests",
        resourcePath: "Resources",
        dependencies: [
            utilitiesModule,
            appDesignSystemModule
        ]
    )

    static let appBaseFlowModule: AppModule = .makeModule(
        name: "AppBaseFlow",
        dependencies: [
            utilitiesModule,
            appDesignSystemModule,
            appEntitiesModule
        ]
    )

    static let appServicesModule: AppModule = .makeModule(
        name: "AppServices",
        dependencies: [
            utilitiesModule,
            appEntitiesModule,
            appBaseFlowModule,
            ExternalModules.alamofire,
            ExternalModules.sdWebImage,
            ExternalModules.sdWebImageWebPCoder,
            ExternalModules.firebaseAuth,
            ExternalModules.firebaseCore
        ]
    )
    static let appServicesTestsModule: AppModule = .makeTestModule(
        name: "AppServicesTests",
        resourcePath: "JsonFakes",
        dependencies: [appServicesModule]
    )

    // MARK: - Feature Flows
    
    static let signUpFlowModule: AppModule = .makeModule(
        name: "SignUpFlow",
        dependencies: [
            utilitiesModule,
            appDesignSystemModule,
            appEntitiesModule,
            appBaseFlowModule,
            appServicesModule,
            ExternalModules.snapKit,
            ExternalModules.tweeTextField
        ]
    )

    static let signInFlowModule: AppModule = .makeModule(
        name: "SignInFlow",
        dependencies: [
            utilitiesModule,
            appDesignSystemModule,
            appEntitiesModule,
            appBaseFlowModule,
            appServicesModule,
            ExternalModules.snapKit,
            ExternalModules.tweeTextField
        ]
    )

    static let chatsFlowModule: AppModule = .makeModule(
        name: "ChatsFlow",
        dependencies: [
            utilitiesModule,
            appDesignSystemModule,
            appEntitiesModule,
            appBaseFlowModule,
            appServicesModule,
            ExternalModules.snapKit,
            ExternalModules.tweeTextField
        ]
    )
    
    static let settignsFlowModule: AppModule = .makeModule(
        name: "SettingsFlow",
        dependencies: [
            utilitiesModule,
            appDesignSystemModule,
            appEntitiesModule,
            appBaseFlowModule,
            appServicesModule,
            ExternalModules.snapKit,
            ExternalModules.tweeTextField,
            ExternalModules.toCropViewController
        ]
    )
    
    static let contactsFlowModule: AppModule = .makeModule(
        name: "ContactsFlow",
        dependencies: [
            utilitiesModule,
            appDesignSystemModule,
            appEntitiesModule,
            appBaseFlowModule,
            appServicesModule,
            ExternalModules.snapKit,
            ExternalModules.tweeTextField
        ]
    )
}

// MARK: - Providing Module

private let appModulesPackageName = "AppModulesPackage"

/// Defines use of external packages
private let externalPackages: [ExternalPackage] = [
    ExternalModules.iqKeyboardManager,
    ExternalModules.tweeTextField,
    ExternalModules.alamofire,
    ExternalModules.sdWebImage,
    ExternalModules.sdWebImageWebPCoder,
    ExternalModules.snapKit,
    ExternalModules.progressHUD,
    ExternalModules.rSwift,
//    ExternalModules.firebaseAuth,
//    ExternalModules.firebaseAnalytics,
//    ExternalModules.firebaseFirestore,
//    ExternalModules.firebaseMessaging,
//    ExternalModules.firebaseCrashlytics,
    ExternalModules.firebaseCore,
    ExternalModules.toCropViewController
]

/// Defines use of product modules to build tha app
private let productAppModules: [AppModule] = [
    InternalModules.utilitiesModule,
    InternalModules.appDesignSystemModule,
    InternalModules.appEntitiesModule,
    InternalModules.appBaseFlowModule,
    InternalModules.appServicesModule,
    InternalModules.signUpFlowModule,
    InternalModules.signInFlowModule,
    InternalModules.chatsFlowModule,
    InternalModules.settignsFlowModule,
    InternalModules.contactsFlowModule
]

/// Defines use of test modules for testing
private let testAppModules: [AppModule] = [
    InternalModules.appDesignSystemTestsModule,
    InternalModules.appServicesTestsModule
]

// MARK: - Package

let package = Package(
    name: appModulesPackageName,
    platforms: [.iOS(.v16)],
    products: productAppModules.map(\.libraryProduct),
    dependencies: externalPackages.map(\.dependency),
    targets: (productAppModules + testAppModules).map(\.target)
)
