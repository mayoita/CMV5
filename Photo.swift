/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase
import FirebaseStorage

class Promo: NSObject {
  

  var databaseRef:DatabaseReference  = Database.database().reference()
static let sharedInstance = Promo()
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  


    func caricaPromo(completion:  @escaping ([PromozioneStruct]) -> ()){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        let promos = databaseRef.child("Promozioni")
        promos.observe(.value, with: {(promoSnapshot)in
            var promo = [PromozioneStruct]()
            let promoDictionary = promoSnapshot.value as! NSDictionary
            for(p) in promoDictionary {
                let promoDic = p.value as! NSDictionary
                
                var Nome = ""
                let NomeLocale = "Nome" + self.getLocale()
                if (promoDic.value(forKey: NomeLocale) != nil) {
                    Nome = promoDic.value(forKey: NomeLocale) as! String!
                }
                var Descrizione = ""
                if (promoDic.value(forKey: "Descrizione") != nil) {
                    Descrizione = promoDic.value(forKey: "Descrizione") as! String!
                }
                var image = ""
                if (promoDic.value(forKey: "image") != nil) {
                    let fileName = promoDic.value(forKey: "image") as! String!
                    image = "https://firebasestorage.googleapis.com/v0/b/cmv-gioco.appspot.com/o/Promotions%2F" + fileName! + "?alt=media&token=b6d4d280-da7d-4428-a508-02db6a6ed526"
                }
                var QR = ""
                if (promoDic.value(forKey: "QR") != nil) {
                    QR = promoDic.value(forKey: "QR") as! String!
                }
                var Inizio = Date()
                if (promoDic.value(forKey: "Inizio") != nil) {
                    Inizio = dateFormatter.date(from: promoDic.value(forKey: "Inizio") as! String)! as! Date
                }
                var Fine = Date()
                if (promoDic.value(forKey: "Fine") != nil) {
                    Fine = dateFormatter.date(from: promoDic.value(forKey: "Fine") as! String)! as! Date
                }
                var Attiva = true
                if (promoDic.value(forKey: "Attiva") != nil) {
                    Attiva = promoDic.value(forKey: "Attiva") as! Bool!
                }
                var Sedi:[String] = []
                if (promoDic.value(forKey: "Sedi") != nil) {
                    Sedi = (promoDic.value(forKey: "Sedi")) as! [String]
                }
                if Attiva {
                    promo.append(PromozioneStruct(nome: Nome, descrizione: Descrizione, image: image, qr: QR, inizio: Inizio, fine: Fine, attiva: Attiva, sedi: Sedi))
                }
                
            }
            completion(promo)
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
