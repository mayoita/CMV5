//
//  Tornei.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 08/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class Tornei: NSObject {
 
    
    var TournamentDescription: String
    var ImageTournament: String
    var TournamentName: String
    var StartDate: NSDate
    var EndDate: NSDate
    var TournamentType: String
    var office: String
    var TournamentURL: String

    
    override init() {
       
        self.TournamentDescription = ""
        self.ImageTournament = ""
        self.TournamentName = ""
        self.StartDate = NSDate()
        self.EndDate = NSDate()
        self.TournamentType = ""
        self.office = ""
        self.TournamentURL = ""
  
    }
    
    init( TournamentDescription: String,
          ImageTournament:String,
          TournamentName:String,
          StartDate:NSDate,
          EndDate:NSDate,
          TournamentType:String,
          office:String,
          TournamentURL:String
        
        ){
        self.TournamentDescription = TournamentDescription
        self.ImageTournament = ImageTournament
        self.TournamentName = TournamentName
        self.StartDate = StartDate
        self.EndDate = EndDate
        self.TournamentType = TournamentType
        self.office = office
        self.TournamentURL = TournamentURL

        
    }
    func returnTorneiAsDictionary()->NSDictionary{
        let torneiDictionary: NSDictionary = ["TournamentDescription": TournamentDescription,
                                              "ImageTournament": ImageTournament,
                                              "TournamentName": TournamentName,
                                              "StartDate": StartDate,
                                              "EndDate": EndDate,
                                              "TournamentType": TournamentType,
                                              "office": office,
                                              "TournamentURL": TournamentURL,
                                              
                                              ]
        return torneiDictionary
    }

}
