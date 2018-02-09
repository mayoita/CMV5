//
//  TorneiDetails.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 09/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class TorneiDetails: EventDetails {
    var torneo = Tornei()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventDetails.handledTap))
        self.view.addGestureRecognizer(tapGesture)
        image.sd_setImage(with: URL(string: torneo.ImageTournament), placeholderImage: UIImage(named: "sediciNoni"))
        
        titolo.text = torneo.TournamentName
        
        formatter.dateFormat = "dd MMM"
        let myDate = formatter.string(from: torneo.StartDate as Date)
        data.text = myDate
        corpo.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0);
        corpo.text = torneo.TournamentDescription
        
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
