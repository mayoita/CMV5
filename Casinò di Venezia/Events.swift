//
//  Events.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 23/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import Foundation

class Events {
    var Book: String
    
    var Description: String
    var DescriptionDE: String
    var DescriptionES: String
    var DescriptionFR: String
    var DescriptionIT: String
    var DescriptionRU: String
    var DescriptionZH: String
    
    var ImageEvent1: String
    var ImageEvent2: String
    var ImageEvent3: String
    var ImageName: String
    
    var isSlotEvents: Bool
    
    var memo: String
    var memoDE: String
    var memoES: String
    var memoFR: String
    var memoIT: String
    var memoRU: String
    var memoZH: String
    
    var Name: String
    var NameDE: String
    var NameES: String
    var NameFR: String
    var NameIT: String
    var NameRU: String
    var NameZH: String
    
    var StartDate: NSDate
    var EndDate: NSDate
    var EventType: String
    var office: String
    var URL: String
    var URLBook: String
    
    init() {
        self.Book = ""
        self.Description = ""
        self.DescriptionDE = ""
        self.DescriptionES = ""
        self.DescriptionFR = ""
        self.DescriptionIT = ""
        self.DescriptionRU = ""
        self.DescriptionZH = ""
        self.ImageName = ""
        self.ImageEvent1 = ""
        self.ImageEvent2 = ""
        self.ImageEvent3 = ""
        self.isSlotEvents = false
        self.memo = ""
        self.memoDE = ""
        self.memoES = ""
        self.memoFR = ""
        self.memoIT = ""
        self.memoRU = ""
        self.memoZH = ""
        self.Name = ""
        self.NameDE = ""
        self.NameES = ""
        self.NameFR = ""
        self.NameIT = ""
        self.NameRU = ""
        self.NameZH = ""
        self.StartDate = NSDate()
        self.EndDate = NSDate()
        self.EventType = ""
        self.office = ""
        self.URL = ""
        self.URLBook = ""
    }
    
    init( Book: String,
          Description: String,
          DescriptionDE:String,
          DescriptionES:String,
          DescriptionFR:String,
          DescriptionIT:String,
          DescriptionRU:String,
          DescriptionZH:String,
          ImageEvent1:String,
          ImageEvent2:String,
          ImageEvent3:String,
          ImageName:String,
          isSlotEvents:Bool,
          memo:String,
          memoDE:String,
          memoES:String,
          memoFR:String,
          memoIT:String,
          memoRU:String,
          memoZH:String,
          Name:String,
          NameDE:String,
          NameES:String,
          NameFR:String,
          NameIT:String,
          NameRU:String,
          NameZH:String,
          StartDate:NSDate,
          EndDate:NSDate,
          EventType:String,
          office:String,
          URL:String,
          URLBook:String
        
        ){
        self.Book = Book
        self.Description = Description
        self.DescriptionDE = DescriptionDE
        self.DescriptionES = DescriptionES
        self.DescriptionFR = DescriptionFR
        self.DescriptionIT = DescriptionIT
        self.DescriptionRU = DescriptionRU
        self.DescriptionZH = DescriptionZH
        self.ImageName = ImageName
        self.ImageEvent1 = ImageEvent1
        self.ImageEvent2 = ImageEvent2
        self.ImageEvent3 = ImageEvent3
        self.isSlotEvents = isSlotEvents
        self.memo = memo
        self.memoDE = memoDE
        self.memoES = memoES
        self.memoFR = memoFR
        self.memoIT = memoIT
        self.memoRU = memoRU
        self.memoZH = memoZH
        self.Name = Name
        self.NameDE = NameDE
        self.NameES = NameES
        self.NameFR = NameFR
        self.NameIT = NameIT
        self.NameRU = NameRU
        self.NameZH = NameZH
        self.StartDate = StartDate
        self.EndDate = EndDate
        self.EventType = EventType
        self.office = office
        self.URL = URL
        self.URLBook = URLBook
        
    }
    func returnEventsAsDictionary()->NSDictionary{
        let eventsDictionary: NSDictionary = ["Book": Book,
                                            "Description": Description,
                                            "DescriptionDE": DescriptionDE,
                                            "DescriptionES": DescriptionES,
                                            "DescriptionFR": DescriptionFR,
                                            "DescriptionIT": DescriptionIT,
                                            "DescriptionRU": DescriptionRU,
                                            "DescriptionZH": DescriptionZH,
                                            "ImageName": ImageName,
                                            "ImageEvent1": ImageEvent1,
                                            "ImageEvent2": ImageEvent2,
                                            "ImageEvent3": ImageEvent3,
                                            "isSlotEvents": isSlotEvents,
                                            "memo": memo,
                                            "memoDE": memoDE,
                                            "memoES": memoES,
                                            "memoFR": memoFR,
                                            "memoIT": memoIT,
                                            "memoRU": memoRU,
                                            "memoZH": memoZH,
                                            "Name": Name,
                                            "NameDE": NameDE,
                                            "NameES": NameES,
                                            "NameFR": NameFR,
                                            "NameIT": NameIT,
                                            "NameRU": NameRU,
                                            "NameZH": NameZH,
                                            "StartDate": StartDate,
                                            "EndDate": EndDate,
                                            "EventType": EventType,
                                            "office": office,
                                            "URL": URL,
                                            "URLBook": URLBook,
                                            ]
        return eventsDictionary
    }

}
