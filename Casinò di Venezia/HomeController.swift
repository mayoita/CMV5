//
//  ViewController.swift
//  CMVG
//
//  Created by Massimo Moro on 22/06/17.
//  Copyright © 2017 Massimo Moro. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var databaseRef:FIRDatabaseReference!
    var feedArray = [Events]()
    let formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatabase()
        navigationItem.title = "Home"
        collectionView?.backgroundColor = UIColor.white
       // collectionView?.register(UICollectionViewCell.self,forCellWithReuseIdentifier:"cellId")
    }

   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "cellId",  for: indexPath) as! EventListCell
        formatter.dateFormat = "dd/MM"
        let myDate = formatter.string(from: feedArray[indexPath.row].StartDate as Date)
        cell.backgroundColor = UIColor.red
        cell.titolo.text = feedArray[indexPath.row].Name
        cell.intro.text = feedArray[indexPath.row].Description
        cell.data.text = myDate
        cell.image.sd_setImage(with: URL(string: feedArray[indexPath.row].ImageName), placeholderImage: UIImage(named: "sediciNoni"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,height: view.frame.width * Constants.sediciNoni)
    }
    
    func loadDatabase(){
        databaseRef = FIRDatabase.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        let events = databaseRef.child("Events")
        events.observe(.value, with: {(eventsSnapshot)in
            let eventsDictionary = eventsSnapshot.value as! NSDictionary
            for(p) in eventsDictionary {
                let events = p.value as! NSDictionary
          
                var Book = "OFF"
                if (events.value(forKey: "Book") != nil) {
                    Book = events.value(forKey: "Book") as! String!
                }
                var Description = ""
                if (events.value(forKey: "Description") != nil) {
                    Description = events.value(forKey: "Description") as! String!
                }
                var DescriptionDE = ""
                if (events.value(forKey: "DescriptionDE") != nil) {
                    DescriptionDE = events.value(forKey: "DescriptionDE") as! String!
                }
                
                var DescriptionES = ""
                if (events.value(forKey: "DescriptionES") != nil) {
                    DescriptionES = events.value(forKey: "DescriptionES") as! String!
                }
                
                var DescriptionFR = ""
                if (events.value(forKey: "DescriptionFR") != nil) {
                    DescriptionFR = events.value(forKey: "DescriptionFR") as! String!
                }
                
                var DescriptionIT = ""
                if (events.value(forKey: "DescriptionIT") != nil) {
                    DescriptionIT = events.value(forKey: "DescriptionIT") as! String!
                }
             
                var DescriptionRU = ""
                if (events.value(forKey: "DescriptionRU") != nil) {
                    DescriptionRU = events.value(forKey: "DescriptionRU") as! String!
                }
               
                var DescriptionZH = ""
                if (events.value(forKey: "DescriptionZH") != nil) {
                    DescriptionZH = events.value(forKey: "DescriptionZH") as! String!
                }
              
                var ImageEvent1 = ""
                if (events.value(forKey: "ImageEvent1") != nil) {
                    ImageEvent1 = events.value(forKey: "ImageEvent1") as! String!
                }
                
                var ImageEvent2 = ""
                if (events.value(forKey: "ImageEvent2") != nil) {
                    ImageEvent2 = events.value(forKey: "ImageEvent2") as! String!
                }
                
                var ImageEvent3 = ""
                if (events.value(forKey: "ImageEvent3") != nil) {
                    ImageEvent3 = events.value(forKey: "ImageEvent3") as! String!
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
                if (events.value(forKey: "memo") != nil) {
                    memo = events.value(forKey: "memo") as! String!
                }
             
                var memoDE = ""
                if (events.value(forKey: "memoDE") != nil) {
                    memoDE = events.value(forKey: "memoDE") as! String!
                }
                
                var memoES = ""
                if (events.value(forKey: "memoES") != nil) {
                    memoES = events.value(forKey: "memoES") as! String!
                }
           
                var memoFR = ""
                if (events.value(forKey: "memoFR") != nil) {
                    memoFR = events.value(forKey: "memoFR") as! String!
                }
             
                var memoIT = ""
                if (events.value(forKey: "memoIT") != nil) {
                    memoIT = events.value(forKey: "memoIT") as! String!
                }
                
                var memoRU = ""
                if (events.value(forKey: "memoRU") != nil) {
                    memoRU = events.value(forKey: "memoRU") as! String!
                }
              
                var memoZH = ""
                if (events.value(forKey: "memoZH") != nil) {
                    memoZH = events.value(forKey: "memoZH") as! String!
                }
              
                var Name = ""
                if (events.value(forKey: "Name") != nil) {
                    Name = events.value(forKey: "Name") as! String!
                }
               
                var NameDE = ""
                if (events.value(forKey: "NameDE") != nil) {
                    NameDE = events.value(forKey: "NameDE") as! String!
                }
               
                var NameES = ""
                if (events.value(forKey: "NameES") != nil) {
                    NameES = events.value(forKey: "NameES") as! String!
                }
               
                var NameFR = ""
                if (events.value(forKey: "NameFR") != nil) {
                    NameFR = events.value(forKey: "NameFR") as! String!
                }
                
                var NameIT = ""
                if (events.value(forKey: "NameIT") != nil) {
                    NameIT = events.value(forKey: "NameIT") as! String!
                }
              
                var NameRU = ""
                if (events.value(forKey: "NameRU") != nil) {
                    NameRU = events.value(forKey: "NameRU") as! String!
                }
               
                var NameZH = ""
                if (events.value(forKey: "NameZH") != nil) {
                    NameZH = events.value(forKey: "NameZH") as! String!
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
                
                
                self.feedArray.append(Events(Book: Book, Description: Description, DescriptionDE: DescriptionDE, DescriptionES: DescriptionES, DescriptionFR: DescriptionFR, DescriptionIT: DescriptionIT, DescriptionRU: DescriptionRU, DescriptionZH: DescriptionZH, ImageEvent1: ImageEvent1, ImageEvent2: ImageEvent2, ImageEvent3: ImageEvent3, ImageName: ImageName, isSlotEvents: isSlotEvents, memo: memo, memoDE: memoDE, memoES: memoES, memoFR: memoFR, memoIT: memoIT, memoRU: memoRU, memoZH: memoZH, Name: Name, NameDE: NameDE, NameES: NameES, NameFR: NameFR, NameIT: NameIT, NameRU: NameRU, NameZH: NameZH, StartDate: StartDate, EndDate: EndDate, EventType: EventType, office: office, URL: URL, URLBook: URLBook))
                self.collectionView?.reloadData()
            }
        })
        
    }
    
}

