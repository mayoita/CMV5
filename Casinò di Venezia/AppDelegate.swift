//
//  AppDelegate.swift
//  CMVG
//
//  Created by Massimo Moro on 22/06/17.
//  Copyright © 2017 Massimo Moro. All rights reserved.
//

import UIKit
import Firebase
import EventKit
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?
    var eventStore: EKEventStore?
    var locale: Locale?
    var ref = DatabaseReference()
    var currentUser: User?
    var currentUserIsAnonymous: Bool = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        locale = Locale.current
        ref = Database.database().reference()
//        let firebaseAuth = FIRAuth.auth()
//        do {
//            try firebaseAuth?.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        currentUser = Auth.auth().currentUser
        //LogIn Anonymous
        if currentUser == nil {
            
            // No user is signed in.
            Auth.auth().signInAnonymously(completion: {
                (user, error) in
                
                if error != nil {
                    print(error ?? "")
                }
                let values = ["name": "Anonymous", "email": "Anonymous","profileImageURL": "" ,"isAnonymous": true] as [String : Any]
                self.ref.child("users").child((user?.uid)!).setValue(values)
                
            })
        } else {
            ref.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                self.currentUserIsAnonymous = value?["isAnonymous"] as? Bool ?? true
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            print("Current User ID: ", currentUser?.uid as Any)
        }
        
        
        
        
       
        FBSDKApplicationDelegate.sharedInstance().application(application,  didFinishLaunchingWithOptions: launchOptions)
        
       
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.sourceApplication])
        
        return handled
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

