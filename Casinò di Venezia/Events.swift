//
//  Events.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 23/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import Foundation

class Events: NSObject {
    var Book: String
    
    var Description: String
    
    var ImageEvent1: String
    var ImageEvent2: String
    var ImageEvent3: String
    var ImageName: String
    
    var isSlotEvents: Bool
    
    var memo: String
    
    var Name: String
    
    var StartDate: NSDate
    var EndDate: NSDate
    var EventType: String
    var office: String
    var URL: String
    var URLBook: String
    var eventoOriginale: Events?
    override init() {
        self.Book = ""
        self.Description = ""
        self.ImageName = ""
        self.ImageEvent1 = ""
        self.ImageEvent2 = ""
        self.ImageEvent3 = ""
        self.isSlotEvents = false
        self.memo = ""
        self.Name = ""
        self.StartDate = NSDate()
        self.EndDate = NSDate()
        self.EventType = ""
        self.office = ""
        self.URL = ""
        self.URLBook = ""
    }
    
    init( Book: String,
          Description: String,
          ImageEvent1:String,
          ImageEvent2:String,
          ImageEvent3:String,
          ImageName:String,
          isSlotEvents:Bool,
          memo:String,
          Name:String,
          StartDate:NSDate,
          EndDate:NSDate,
          EventType:String,
          office:String,
          URL:String,
          URLBook:String
          
        
        ){
        self.Book = Book
        self.Description = Description
        self.ImageName = ImageName
        self.ImageEvent1 = ImageEvent1
        self.ImageEvent2 = ImageEvent2
        self.ImageEvent3 = ImageEvent3
        self.isSlotEvents = isSlotEvents
        self.memo = memo
        self.Name = Name
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
                                            "ImageName": ImageName,
                                            "ImageEvent1": ImageEvent1,
                                            "ImageEvent2": ImageEvent2,
                                            "ImageEvent3": ImageEvent3,
                                            "isSlotEvents": isSlotEvents,
                                            "memo": memo,
                                            "Name": Name,
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
