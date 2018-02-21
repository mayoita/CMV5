//
//  FacebookViewController.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 21/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FacebookShare



class FacebookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let likeButton = LikeButton(frame: CGRect(x:0, y:0, width: 150, height: 20), object: .page(objectId: "https://www.facebook.com/casinovenezia/"))
        
       // likeButton.likeControlStyle = .boxCount
        likeButton.center = view.center
        view.addSubview(likeButton)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
