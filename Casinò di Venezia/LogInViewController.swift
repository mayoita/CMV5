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

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
   
    var loginButton = FBSDKLoginButton()
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    var storage = FIRStorage()
    var storageRef = FIRStorageReference()
    var profilePicRef = FIRStorageReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = FIRStorage.storage()
        storageRef = storage.reference(forURL: "gs://cmv-gioco.appspot.com")
        profilePicRef = self.storageRef.child("/profile_images/" + (self.appDelegate.currentUser?.uid)! + ".jpg")

        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
       // self.loginButton.isHidden = true
        activityIndicator.isHidden = true
        
        FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
            // ...
         //   if let user = user {
          //      let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapsViewController
            //    self.present(mapVC, animated: true, completion: nil)
                
          //  } else {
                self.loginButton.frame = CGRect(x: 16, y: 50, width: self.view.frame.width - 32, height: 50)
                self.loginButton.delegate = self
                self.loginButton.readPermissions = ["email", "public_profile"]
                self.view.addSubview(self.loginButton)
                self.loginButton.isHidden = false
            
            
            
            
            
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            self.profilePicRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("L'utente è anonimo")
                    self.profilePic.image = nil
                } else {
                    // Data for images is returned
                    print("L'utente ha già un immagine e non occorre il download da Facebook")
                    self.profilePic.image = UIImage(data: data!)
                }
            }
          //  }
//            self.currentUser = FIRAuth.auth()?.currentUser
//            let a = self.currentUser?.providerData.count
//            for profile in (self.currentUser?.providerData)! {
//                // Id of the provider (ex: facebook.com)
//                print(profile.email ?? "Nothing")
//                print(profile.providerID)
//            }
          
            
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
    }
    }
    @IBAction func createAccountAction(_ sender: Any) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
   
    

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out")
        appDelegate.currentUser?.unlink(fromProvider: "facebook.com") { (user, error) in
            if error != nil {
                print("Errore di unlink!!!", error?.localizedDescription ?? "")
            }
            let values = ["name": "Anonymous", "email": "Anonymous", "isAnonymous": true] as [String : Any]
            self.appDelegate.ref.child("users").child((self.appDelegate.currentUser?.uid)!).setValue(values)
        
            // Delete the file
            self.profilePicRef.delete { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("Errore nella cancellazione del file: ", error.localizedDescription)
                } else {
                    // File deleted successfully
                    print("File cancellato!")
                    self.profilePic.image = nil
                }
            }
        }
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        if error != nil {
            print("Errore in logIn didCompleteWith", error.localizedDescription)
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        } else if (result.isCancelled) {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            self.firebaseAuth()
        }
        
    }
    
    func firebaseAuth () {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        appDelegate.currentUser?.link(with: credentials, completion: {
            (user, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            print("Link with Facebook credentials")
        })

        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            let dictionary = result as? NSDictionary
            let values = ["name": dictionary?.object(forKey: "name") as Any, "email": dictionary?.object(forKey: "email") as Any,"isAnonymous": false] as [String : Any]
            self.appDelegate.ref.child("users").child((self.appDelegate.currentUser?.uid)!).setValue(values)
        }


        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profilePicRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Errore in data.(withMaxSize", error.localizedDescription)
            } else {
                // Data for images is returned
                print("L'utente ha già un immagine e non occorre il download da Facebook")
               self.profilePic.image = UIImage(data: data!)
            }
        }
        if (self.profilePic.image == nil) {
            let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height": 300, "width":300, "redirect": false], httpMethod: "GET")
            profilePic?.start(completionHandler: {
                (connection, result, error) in
                if (error == nil) {
                    // result è un dizionario, quindi..
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    
                    let urlPic = ((data as AnyObject).object(forKey: "url")) as? String
                    if let imageData = NSData(contentsOf: NSURL(string:urlPic!)! as URL) {
                        
                        let uploadTask = self.profilePicRef.put(imageData as Data, metadata:nil) {
                            metadata, error in
                            if (error == nil) {
                                let downloadUrl = metadata!.downloadURL
                            } else {
                                print("Error in downloading")
                            }
                        }
                        self.profilePic.image = UIImage(data: imageData as Data)
                        
                    }
                }
            })
        }
        
    }
   
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
