//
//  PromozioneStruct.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 08/03/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class PromozioneStruct: NSObject {
    var Name: String = ""
    var Descrizione = ""
    var image = ""
    var QR = ""
    var Inizio = Date()
    var Fine = Date()
    var Attiva = true
    var Sedi:[String] = []
    init(nome: String, descrizione: String, image: String, qr: String, inizio: Date, fine: Date, attiva: Bool, sedi: [String]) {
        self.Name = nome
        self.image = image
        self.Descrizione = descrizione
        self.QR = qr
        self.Inizio = inizio
        self.Fine = fine
        self.Attiva = attiva
        self.Sedi = sedi
    }
}
