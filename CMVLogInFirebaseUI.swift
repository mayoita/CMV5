//
//  CMVLogInFirebaseUI.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 25/01/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

class CMVLogInFirebaseUI: UIViewController, FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            //Problem signing in
            login()
        }else {
            //User is in! Here is where we code after signing in
            
        }
    }
    
    override func viewDidLoad() {
        
        checkLoggedIn()
    }
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                let a = user?.displayName
                let b = user?.email
                let c = user?.isAnonymous
                print("Current User ID: ", user?.uid as Any)
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        let facebookProvider = FUIFacebookAuth()
        let googleProvider = FUIGoogleAuth()
        authUI?.delegate = self
        authUI?.providers = [googleProvider, facebookProvider]
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }

}
