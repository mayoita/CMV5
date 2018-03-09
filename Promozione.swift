//
//  Promozione.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 23/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class Promozione: UIViewController {

    @IBOutlet weak var altezzaQR: NSLayoutConstraint!
    @IBOutlet weak var dove: UILabel!
    @IBOutlet weak var validita: UILabel!
    @IBOutlet weak var qrimage: UIImageView!
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var immagine: UIImageView!
    @IBOutlet weak var testo: UITextView!
    let formatter = DateFormatter()
    let nomeSedi = ["VE":"Ca' Vendramin Calergi", "CN":"Ca' Noghera"]
    var promo:PromozioneStruct? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "dd MMM"
        let myDate = formatter.string(from: (promo?.Inizio)!)
        let myDateEnd = formatter.string(from: (promo?.Fine)!)
        titolo.text = promo?.Name
        immagine.sd_setImage(with: URL(string: (promo?.image)!), placeholderImage: UIImage(named: "sediciNoni"))
        qrimage.image = generateQRCode(from: (promo?.QR)!)
        testo.text = promo?.Descrizione
        if (promo?.Fine != promo?.Inizio) {
            validita.text = "Dal \(myDate) al \(myDateEnd)".localized
        } else {
            validita.text = myDate
        }
        var leSedi = "A ".localized
        if promo?.Sedi.count == 1 {
            for sede in (promo?.Sedi)! {
                leSedi = leSedi + nomeSedi[sede]!
            }
        } else {
            for sede in (promo?.Sedi)! {
                leSedi = leSedi + " e ".localized + nomeSedi[sede]!
            }
        }
        if promo?.QR == "" {
            altezzaQR.constant = 0
        }
        dove.text = leSedi
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
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
