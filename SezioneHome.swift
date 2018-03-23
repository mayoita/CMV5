//
//  SezioneHome.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 21/03/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import FoldingCell
import MarqueeLabel
import Firebase

class SezioneHome: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let kCloseCellHeight: CGFloat = 250
    let kOpenCellHeight: CGFloat = 588
    let kRowsCount = 2
    var cellHeights: [CGFloat] = []
    var festivita:[String] = []
    
    lazy var tableView: UITableView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UITableView(frame: .zero)
        cv.register(UINib(nibName: "FoldingCellView", bundle: nil), forCellReuseIdentifier: "FoldingCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let sediDBURL: URL = Bundle.main.url(forResource: "SediList",   withExtension: "plist")!
    typealias Settings = [sediDB]
    var sediDB: Settings?
    var databaseRef:DatabaseReference  = Database.database().reference()
    let feedNews = MarqueeLabel()
   
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        
        return dateFormatter
    }()
    
    func fetchDatabase () {
        do {
            let data = try Data.init(contentsOf: sediDBURL)
            let decoder = PropertyListDecoder()
            sediDB = try decoder.decode(Settings.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        LoadDatabase.sharedInstance.loadFestivita { (eventi: [String]) in
            self.festivita = eventi
            self.tableView.reloadData()
            
        }
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        let feed = databaseRef.child("News")
        feed.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let text = value?["feed"] as? String ?? ""
            if text != "" {
                self.feedNews.text = "** NEWS ** " + text
                self.feedNews.frame = CGRect(x: 0, y: 3, width: self.frame.width, height: 30)
                self.addConstraintsWithFormnat(format: "V:|-30-[v0]|", views: self.tableView)
                
            } else {
                self.feedNews.text = ""
                self.feedNews.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
                self.addConstraintsWithFormnat(format: "V:|[v0]|", views: self.tableView)
            }
            
        })
        feedNews.tag = 201
        feedNews.textColor = StyleKit.oroScuro
        feedNews.font = UIFont(name: "VeniceCasino-Regular", size: 18)
        feedNews.type = .continuous
        feedNews.textAlignment = .right
        feedNews.lineBreakMode = .byTruncatingHead
        feedNews.speed = .rate(60)
        feedNews.fadeLength = 15.0
        
        feedNews.leadingBuffer = 30.0
        feedNews.trailingBuffer = 20
        feedNews.animationCurve = .easeInOut
        feedNews.isUserInteractionEnabled = true // Don't forget this, otherwise the gesture recognizer will fail (UILabel has this as NO by default)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        feedNews.addGestureRecognizer(tapRecognizer)
        
        addSubview(feedNews)
        
        addSubview(tableView)
        fetchDatabase()
        addConstraintsWithFormnat(format: "H:|[v0]|", views: tableView)
        
        cellHeights = Array(repeating: kCloseCellHeight, count: (sediDB?.count)!)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
    }
    @objc func pauseTap(_ recognizer: UIGestureRecognizer) {
        let continuousLabel2 = recognizer.view as! MarqueeLabel
        if recognizer.state == .ended {
            continuousLabel2.isPaused ? continuousLabel2.unpauseLabel() : continuousLabel2.pauseLabel()
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sediDB?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! DemoCell
        
        cell.titolo.text = sediDB![indexPath.row].titolo
        cell.storiaTEsto.text = sediDB![indexPath.row].storia
        cell.dalleAlle.text = sediDB![indexPath.row].orari
        cell.telefono = sediDB![indexPath.row].telefono
        cell.immagine.image = UIImage(named:sediDB![indexPath.row].immagine)
        cell.sediNome = [sediDB![indexPath.row].sede]
        cell.titoloSede.text = sediDB![indexPath.row].titolo
        cell.orari2.text = sediDB![indexPath.row].orari2
        cell.sabato.text = sediDB![indexPath.row].aperto2
        cell.oggiAperto.text = impostaOrariApertura(sede: sediDB![indexPath.row].sede)
        return cell
    }
     func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        
    }
     func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func impostaOrariApertura(sede: String) -> String {
        let oggi = formatter.string(from: Date())
    
        let weekday = Calendar.current.component(.weekday, from: Date())
        if weekday == 7 || festivita.contains(oggi) {
            if sede == "VE" {
                return "Aperto dalle 11:00 alle 3:15".localized
            } else {
                return  "Aperto dalle 11:00 alle 3:45".localized
            }
        } else {
            if sede == "VE" {
                return  "Aperto dalle 11:00 alle 2:45".localized
            } else {
                return "Aperto dalle 11:00 alle 3:15".localized
            }
        }
    }
    
    
}
