//
//  AppDelegate.swift
//  mileshareApp
//
//  Created by 森田宣広 on 2018/03/03.
//  Copyright © 2018年 森田宣広. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookCore
import FacebookLogin


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case let LoginResult.failed(error):
            // いい感じのエラー処理
            break
        case let LoginResult.success(grantedPermissions, declinedPermissions, token):
            let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
            // Firebaseにcredentialを渡してlogin
            Auth.auth().signIn(with: credential) { (fireUser, fireError) in
                if let error = fireError {
                    // いい感じのエラー処理
                    return
                }
                // ログイン用のViewControllerを閉じるなど
                if let loginVC = self.window?.rootViewController?.presentedViewController{
                    loginVC.dismiss(animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        do {
            try Auth.auth().signOut()
            //重なっているviewを全て削除して、rootiewに戻る
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
    }
    
   

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions as? [UIApplicationLaunchOptionsKey : Any])
        // 4. application:openUrl:options:を追加
        @available(iOS 9.0, *)
        func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
            -> Bool {
                return SDKApplicationDelegate.shared.application(application,
                                                                 open: url,
                                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                 annotation: [:])
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled:Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }


}

