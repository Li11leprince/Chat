//  Copyright © 2021 My organization. All rights reserved.

import UIKit
import Utilities
import AppServices
import FirebaseCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private static var logger = LoggerFactory.default

    @Injected(\.appCoordinator) private var appCoordinator
    @Injected(\.env) private var env

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        initializeStartupServices()
        appCoordinator.start()

        logApplicationStartedEvent()

        return true
    }

    private func initializeStartupServices() {
        KeyboardHealper.firstEnableKeyboardManager()
        FirebaseApp.configure()
    }
}

private extension AppDelegate {

    private func logApplicationStartedEvent() {
        Self.logger.info(
            message: "Application started! Environment: \(env.description)"
        )
    }
}
