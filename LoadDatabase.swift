//
//  LoadDatabase.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 08/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class LoadDatabase: NSObject {

    var databaseRef:DatabaseReference  = Database.database().reference()
    static let sharedInstance = LoadDatabase()
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    func loadDatabase(completion:  @escaping ([Events]) -> ()){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        let events = databaseRef.child("Events")
        events.observe(.value, with: {(eventsSnapshot)in
            let eventsDictionary = eventsSnapshot.value as! NSDictionary
            var feedArrayHelper = [Events]()
            //var arrayEventi = [Events]()
            //for dic in eventsDictionary {
               // let aaa = dic.value as! [String: AnyObject]
                //var evento = Events()
                //evento.setValuesForKeys(aaa)
               // arrayEventi.append(evento)
           // }
            for(p) in eventsDictionary {
                let events = p.value as! NSDictionary
                
                var Book = "OFF"
                if (events.value(forKey: "Book") != nil) {
                    Book = events.value(forKey: "Book") as! String!
                }
                var Description = ""
                let DescriptionLocale = "Description" + self.getLocale()
                if (events.value(forKey: DescriptionLocale) != nil) {
                    Description = events.value(forKey: DescriptionLocale) as! String!
                }
                
                
                var ImageEvent1 = ""
                if (events.value(forKey: "ImageEvent1") != nil) {
                    let fileName = events.value(forKey: "ImageEvent1") as! String!
                    ImageEvent1 = "https://firebasestorage.googleapis.com/v0/b/cmv-gioco.appspot.com/o/Events%2F" + fileName! + "?alt=media&token=b6d4d280-da7d-4428-a508-02db6a6ed526"
                }
                
                var ImageEvent2 = ""
                if (events.value(forKey: "ImageEvent2") != nil) {
                    let fileName = events.value(forKey: "ImageEvent2") as! String!
                    ImageEvent2 = "https://firebasestorage.googleapis.com/v0/b/cmv-gioco.appspot.com/o/Events%2F" + fileName! + "?alt=media&token=b6d4d280-da7d-4428-a508-02db6a6ed526"
                }
                
                var ImageEvent3 = ""
                if (events.value(forKey: "ImageEvent3") != nil) {
                    let fileName = events.value(forKey: "ImageEvent3") as! String!
                    ImageEvent3 = "https://firebasestorage.googleapis.com/v0/b/cmv-gioco.appspot.com/o/Events%2F" + fileName! + "?alt=media&token=b6d4d280-da7d-4428-a508-02db6a6ed526"
                }
                
                var ImageName = ""
                if (events.value(forKey: "ImageName") != nil) {
                    let fileName = events.value(forKey: "ImageName") as! String!
                    ImageName = "https://firebasestorage.googleapis.com/v0/b/cmv-gioco.appspot.com/o/Events%2F" + fileName! + "?alt=media&token=b6d4d280-da7d-4428-a508-02db6a6ed526"
                }
                
                var isSlotEvents = false
                if (events.value(forKey: "isSlotEvents") != nil) {
                    isSlotEvents = events.value(forKey: "isSlotEvents") as! Bool!
                }
                
                var memo = ""
                let memoLocale = "memo" + self.getLocale()
                if (events.value(forKey: memoLocale) != nil) {
                    memo = events.value(forKey: memoLocale) as! String!
                }
                
                var Name = ""
                let NameLocale = "Name" + self.getLocale()
                if (events.value(forKey: NameLocale) != nil) {
                    Name = events.value(forKey: NameLocale) as! String!
                }
                
                var StartDate = NSDate()
                if (events.value(forKey: "StartDate") != nil) {
                    StartDate = dateFormatter.date(from: events.value(forKey: "StartDate") as! String)! as NSDate
                }
                
                var EndDate = NSDate()
                if (events.value(forKey: "EndDate") != nil) {
                    EndDate = dateFormatter.date(from: events.value(forKey: "EndDate") as! String)! as NSDate
                }
                
                var EventType = ""
                if (events.value(forKey: "EventType") != nil) {
                    EventType = events.value(forKey: "EventType") as! String!
                }
                
                var office = ""
                if (events.value(forKey: "office") != nil) {
                    office = events.value(forKey: "office") as! String!
                }
                
                var URL = ""
                if (events.value(forKey: "URL") != nil) {
                    URL = events.value(forKey: "URL") as! String!
                }
                
                var URLBook = ""
                if (events.value(forKey: "URLBook") != nil) {
                    URLBook = events.value(forKey: "URLBook") as! String!
                }
                
                
                feedArrayHelper.append(Events(Book: Book, Description: Description, ImageEvent1: ImageEvent1, ImageEvent2: ImageEvent2, ImageEvent3: ImageEvent3, ImageName: ImageName, isSlotEvents: isSlotEvents, memo: memo, Name: Name, StartDate: StartDate, EndDate: EndDate, EventType: EventType, office: office, URL: URL, URLBook: URLBook))
                
            }
            
            completion(feedArrayHelper)
            
            
        })
        
    }
    func loadTornei(completion:  @escaping ([Tornei]) -> ()){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        let events = databaseRef.child("Tournaments")
        events.observe(.value, with: {(eventsSnapshot)in
            let eventsDictionary = eventsSnapshot.value as! NSDictionary
            var feedArrayHelper = [Tornei]()
            //var arrayEventi = [Events]()
            //for dic in eventsDictionary {
            // let aaa = dic.value as! [String: AnyObject]
            //var evento = Events()
            //evento.setValuesForKeys(aaa)
            // arrayEventi.append(evento)
            // }
            for(p) in eventsDictionary {
                let events = p.value as! NSDictionary
                
                var tournamentDescription = ""
                if (events.value(forKey: "TournamentDescription") != nil) {
                    tournamentDescription = events.value(forKey: "TournamentDescription") as! String!
                }
                
                var imageTournament = ""
                if (events.value(forKey: "ImageTournament") != nil) {
                    let fileName = events.value(forKey: "ImageTournament") as! String!
                    imageTournament = "https://firebasestorage.googleapis.com/v0/b/cmv-gioco.appspot.com/o/Tournaments%2F" + fileName! + "?alt=media&token=b6d4d280-da7d-4428-a508-02db6a6ed526"
                }
                
                var tournamentName = ""
                if (events.value(forKey: "TournamentName") != nil) {
                    tournamentName = events.value(forKey: "TournamentName") as! String!
                }
                
                var StartDate = NSDate()
                if (events.value(forKey: "StartDate") != nil) {
                    StartDate = dateFormatter.date(from: events.value(forKey: "StartDate") as! String)! as NSDate
                }
                
                var EndDate = NSDate()
                if (events.value(forKey: "EndDate") != nil) {
                    EndDate = dateFormatter.date(from: events.value(forKey: "EndDate") as! String)! as NSDate
                }
                
                var tournamentType = ""
                if (events.value(forKey: "TournamentType") != nil) {
                    tournamentType = events.value(forKey: "TournamentType") as! String!
                }
                
                var office = ""
                if (events.value(forKey: "office") != nil) {
                    office = events.value(forKey: "office") as! String!
                }
                
                var URL = ""
                if (events.value(forKey: "TournamentURL") != nil) {
                    URL = events.value(forKey: "TournamentURL") as! String!
                }

                
                feedArrayHelper.append(Tornei(TournamentDescription: tournamentDescription, ImageTournament: imageTournament, TournamentName: tournamentName, StartDate: StartDate, EndDate: EndDate, TournamentType: tournamentType, office: office, TournamentURL: URL))
                
            }
            
            completion(feedArrayHelper)
            
            
        })
        
    }
    func getLocale() -> String {
        var locale = ""
        if appDelegate.locale?.languageCode != "en" {
            locale = (appDelegate.locale?.languageCode?.uppercased())!
            return locale
        }
        
        return locale
    }
}
