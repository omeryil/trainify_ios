//
//  AppDelegate.swift
//  trainig
//
//  Created by omer yildirim on 17.01.2025.
//

import UIKit
import FirebaseCore
import UserNotifications
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate  {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.lightGray
        ]
        FirebaseApp.configure()
        
        //requestNotificationPermission()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func logoutUser() {
        // Token'ı temizle
        Messaging.messaging().deleteToken { error in
            if let error = error {
                print("❌ Token silme hatası: \(error.localizedDescription)")
            } else {
                print("✅ Token başarıyla silindi")
            }
        }
    }
    func updateFCMTokenForNewUser() {
        Messaging.messaging().token { token, error in
            if let token = token {
                print("🔄 Yeni Kullanıcı İçin FCM Token: \(token)")
                Statics.updateToken(token: token) // Token'ı sunucuya gönder
            } else if let error = error {
                print("❌ FCM Token alınamadı: \(error.localizedDescription)")
            }
        }
    }
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        self.fetchFCMToken()
                    }
                    print("✅ Notification permission granted!")
                } else {
                    print("❌ Notification permission denied.")
                }
            }
        }
    }
    func checkIfRegisteredForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    if UIApplication.shared.isRegisteredForRemoteNotifications {
                        //self.fetchFCMToken()
                        print("✅ Remote notifications are already registered")
                    } else {
                        
                    }
                }
            } else {
                print("❌ Remote notifications were never registered (Permission not granted)")
            }
        }
    }
    func registerForPushNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationPermission()
                break
            case .denied:
                break
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            @unknown default:
                print("⚠️ Unknown status")
            }
        }
    }
    func fetchFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
            } else if let token = token {
                print("FCM Token: \(token)")
                Statics.updateToken(token: token)
                // Save or send the token to your server
            }
        }
    }
    // 📌 Cihaz Push Token’ını Al
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("📲 APNs Token: \(tokenString)")
        
        // Firebase'a Token'ı gönder
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 📌 Firebase FCM Token’ı Al
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔥 Firebase FCM Token: \(fcmToken ?? "Token alınamadı")")
        if let tk = fcmToken {
            Statics.updateToken(token: tk)
        }
        
        // Token'ı sunucuya gönderin
    }
    
    // 📌 Bildirim Geldiğinde Çalışır
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("📩 FCM Push Notification Received: \(userInfo)")
        handleNotificationData(userInfo: userInfo)
        completionHandler(.newData)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotificationData(userInfo: userInfo)
        completionHandler()
    }
    // 📌 Uygulama Açıkken Bildirim Geldiğinde
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("📩 Foreground Notification: \(userInfo)")
        if let keyValue = userInfo["key"] as? String {
            print("Key value: \(keyValue)")
        }
        if let keyValue = userInfo["screen"] as? String {
            print("Key value: \(keyValue)")
        }
        //handleNotificationData(userInfo: userInfo)
        // Bildirimi göster (alert, ses, badge)
        completionHandler([.banner, .sound, .badge])
    }
    private func handleNotificationData(userInfo: [AnyHashable: Any]) {
        var screen: String = ""
        if let customData = userInfo["custom_data"] as? [String: Any] { return
            screen = customData["screen"] as? String ?? ""
        }else if let scr = userInfo["screen"] as? String {
            screen = scr
        }
        
        
        getUINavşgationController(screen: screen)
    }
    func getUINavşgationController(screen:String) {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let rootVC = sceneDelegate.window?.rootViewController as? UINavigationController {
                self.navigateToScreen(screen: screen, rootVC: rootVC)
            }
            
        }
    }
    private func navigateToScreen(screen: String, rootVC: UINavigationController) {
        
        switch screen {
        case "notifications":
            let n = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "noti")  as! Notifications
            checkTokenAndNavigate(scr: n)
            
        case "settings":
            let n = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "sett")  as! SettingsController
            checkTokenAndNavigate(scr: n)
//            let homeVC = Notifications()
//            rootVC.pushViewController(homeVC, animated: true)
        default:
            print("Unknown screen: \(screen)")
        }
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first {
            handleNotificationData(userInfo: userActivity.userInfo ?? [:])
        }
        
        if let notificationResponse = connectionOptions.notificationResponse {
            handleNotificationData(userInfo: notificationResponse.notification.request.content.userInfo)
        }
    }
    func checkTokenAndNavigate(scr:UIViewController) {
        let token = CacheData.getToken()
       
        if token == nil  {
            navigateToRoot()
        } else {
            navigateToHome(scr: scr)
        }
    }
    func navigateToRoot() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            let appearance = UINavigationBar.appearance()
            appearance.tintColor = UIColor.lightGray
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let rootVC = storyboard.instantiateViewController(withIdentifier: "loginout") as? ViewController {
                let navController = UINavigationController(rootViewController: rootVC)
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }

    func navigateToHome(scr:UIViewController) {
        let userData=CacheData.getUserData()!
        let isFirst:Bool!
        if userData.object(forKey: "isFirst") != nil {
            isFirst = userData["isFirst"] as? Bool
        } else {
            isFirst = false
        }
        
        let role=userData["role"] as! String
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            let appearance = UINavigationBar.appearance()
            appearance.tintColor = UIColor.lightGray
            var n:UIViewController!
            let role=userData["role"] as! String
            var x:UITabBarController!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if isFirst {
                n = storyboard.instantiateViewController(withIdentifier: "vpager") as! ViewPager
            }else{
                
                if role=="user"{
                    n = storyboard.instantiateViewController(withIdentifier: "upage") as! UserTabViewController
                    x = n as? UITabBarController
                }else{
                    n = storyboard.instantiateViewController(withIdentifier: "tpage") as! TrainerTabViewController
                    x = n as? UITabBarController
                    
                }
                
            }
            let navController = UINavigationController(rootViewController: n)
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
            if let firstNavController = x {
                navController.pushViewController(scr, animated: true)
            }
            
        }
    }
    
}

