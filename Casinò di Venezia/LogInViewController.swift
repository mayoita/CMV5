//
//  LogInViewController.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 12/07/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseStorage

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UITextField!

   
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
   
  
    var loginButton = FBSDKLoginButton()
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    let storage = Storage.storage()
    var storageRef = StorageReference()
    var providerID = ""
    var currentUser: User?
    var isAnonymous = true
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?

    func AddFacebookButton () {
        //self.loginButton.frame = CGRect(x: 16, y: 50, width: self.view.frame.width - 32, height: 50)
        self.loginButton.center = self.view.center
        self.loginButton.center.y += 100
        self.loginButton.delegate = self
        self.loginButton.readPermissions = ["email", "public_profile"]
        self.view.addSubview(self.loginButton)
        self.loginButton.isHidden = false
    }
   
   
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
        storageRef = storage.reference(forURL: "gs://cmv-gioco.appspot.com/")
        AddFacebookButton()
       
        
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE]
            
            self.currentUser = user
            self.isAnonymous = (user?.isAnonymous)!
            if let token = FBSDKAccessToken.current() {
                self.fetchProfile()
            }
            print("Current User ID: ", user?.uid as Any)
            // [END_EXCLUDE]
        }
        // [END auth_listener]
        
    }
    
    func fetchProfile() {
        let profilePicRef = storageRef.child("profile_images/").child((self.currentUser?.uid)!+".jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("User ID Unable to download image:", error.localizedDescription)
                self.fetchProfileFromFB(profilePicRef: profilePicRef)
            } else {
                if (data != nil) {
                    // Data for "profile_picjpg" is returned
                    self.profilePic.image = UIImage(data: data!)
                    self.name.text = self.currentUser?.displayName
                    self.emailTextField.text = self.currentUser?.email
                }
                
            }
        }
        
    }

    func fetchProfileFromFB (profilePicRef: StorageReference) {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "first_name, last_name, picture.type(large), name, email"]).start {
            (connection, result, err) in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            if err != nil {
                print("User ID FBSDKGraphRequest error:!!!", err?.localizedDescription ?? "")
                return
            }
            let dictionary = result as? NSDictionary
            if let email = dictionary!["email"] as? String {
                self.emailTextField.text = email
            }
            if let name = dictionary!["name"] as? String {
                self.name.text = name
                changeRequest?.displayName = name
            }
            if let picture = dictionary!["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                let data = NSData(contentsOf: URL(string: url)!)
                self.profilePic.image = UIImage(data: data! as Data)
                changeRequest?.photoURL = URL(string: url)!
                let uploadTask = profilePicRef.putData(data as! Data, metadata:nil) {
                    metadata, error in
                    if (error == nil) {
                        let downloadURL = metadata?.downloadURL()
                    } else {
                        print("Error in downloading")
                    }
                }
            }
           
            changeRequest?.commitChanges { (error) in
                // ...
                if (error != nil) {
                    print("User ID Error commit change request")
                }
            }
            let values = ["name": dictionary?.object(forKey: "name") as Any, "email": dictionary?.object(forKey: "email") as Any ,"isAnonymous": false] as [String : Any]
            let user = Auth.auth().currentUser?.uid
            self.appDelegate.ref.child("users").child(user!).setValue(values)
        }
    }
    
    

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        appDelegate.currentUser?.unlink(fromProvider: "facebook.com") { (user, error) in
            if error != nil {
                print("User ID Facebook Errore di unlink!!!", error?.localizedDescription ?? "")
                return
            }
            
            print("User ID Facebook did log out")
            self.profilePic.image = nil
            let values = ["name": "Anonymous", "email": "Anonymous", "isAnonymous": true] as [String : Any]
            self.appDelegate.ref.child("users").child((self.appDelegate.currentUser?.uid)!).setValue(values)
      
        }
        self.dismiss(animated: true, completion: nil)
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if error != nil {
            print("User ID Facebook Errore in logIn didCompleteWith", error.localizedDescription)
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        } else if (result.isCancelled) {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.firebaseAuth(tipo: "Facebook")
        }
        
    }
    
    func firebaseAuth (tipo:String) {
        switch tipo {
        case "Facebook":
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else {
                return
            }
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            currentUser?.link(with: credentials, completion: {
                (user, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                }
                print("User ID Link with Facebook credentials")
            })
            
            fetchProfile()
            break
        default:
            break;
        }
        
        
    }
   
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
