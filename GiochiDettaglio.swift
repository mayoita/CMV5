//
//  GiochiDettaglio.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 15/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class GiochiDettaglio: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, CAAnimationDelegate{
    
    
    @IBOutlet weak var probabilita: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var immagine_tavolo: UIImageView!
    @IBOutlet weak var immagine: UIImageView!
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var main: UITextView!
    @IBOutlet weak var tabella: UITableView!
    var gioco: giochiDB?
    var twoDimensionalArray = [regoleHelp]()
    struct regoleHelp {
        var isExpanded: Bool
        let regole: [String:String]
    }
    let nero = UIView()
    let probabilitaV = Probabilita()
  
     let transition = CircularTransition()
    //Property for interaction controller
    let closeOnScrollDown = CloseOnScrollDown()
    let tableCellID = "RegolaCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabella.delegate = self
        tabella.dataSource = self
        for item in (gioco?.regola)! {
            let helper = regoleHelp.init(isExpanded: false, regole: item)
            twoDimensionalArray.append(helper)
        }
        map.setImage(StyleKit.imageOfMic(), for: .normal)
        tabella.rowHeight = UITableViewAutomaticDimension
        tabella.estimatedRowHeight = 100
        titolo.text = gioco?.titolo
        titolo.font = UIFont(name: "VeniceCasino-Regular", size: 14)
        immagine.image = UIImage(named: (gioco?.immagine)!)
        main.text = gioco?.main
        immagine_tavolo.image = UIImage(named: (gioco?.immagine_tavolo)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
     
        return twoDimensionalArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let view = UIView()
        view.backgroundColor = StyleKit.fillColor
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
  
        let label = UILabel()
        label.text = gioco?.regola[section].keys.first
        label.font = UIFont(name: "VeniceCasino-Regular", size: 14)
        
        view.addSubview(label)
        view.addSubview(button)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["label": label, "button": button, "view": view]
        
        let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[label]-5-[button]-5-|", options: .alignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontallayoutContraints)
        
        let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalLayoutContraint)

     
        return view

    }

    func handleExpandClose(button: UIButton){
        
        var indexPaths = [IndexPath]()
      
        indexPaths.append(IndexPath(row: 0, section: button.tag))
   
        let isExpanded = twoDimensionalArray[button.tag].isExpanded
        button.setTitle(isExpanded ? "+" : "-", for: .normal)
        twoDimensionalArray[button.tag].isExpanded = !isExpanded
        if isExpanded {
            tabella.deleteRows(at: indexPaths, with: .fade)
        } else {
             tabella.insertRows(at: indexPaths, with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].isExpanded {
            return 0
        }
   
        return twoDimensionalArray[section].regole.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! RegolaCell
        
        cell.testo.text = twoDimensionalArray[indexPath.section].regole.values.first
        return cell
    }
    

    //MARK: Transition delegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.openingFrame = self.map
        transition.origin = self.map.center
        
        return transition
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.openingFrame = self.map
        transition.origin = self.map.center
        
        return transition
    }
    @IBAction func mappa(_ sender: Any) {
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapsViewController
        mapVC.sediNome = gioco?.office
      
        mapVC.transitioningDelegate = self
        mapVC.modalPresentationStyle = .custom
        present(mapVC, animated: true, completion: nil)
    }
   
    @IBAction func probabilita_pressed(_ sender: Any) {
          let pop = PopUp()
        pop.presentaPopUp(sender: self, icona: probabilita, vista: view, gioco: gioco!.probabilita, titolo: "PROBABILITÀ DI VINCITA".localized)
//        if let window = UIApplication.shared.keyWindow {
//            nero.frame = view.frame
//            nero.backgroundColor = .black
//            nero.alpha = 0
//            nero.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
//            window.addSubview(nero)
//
//            probabilitaV.testo.text = gioco?.probabilita
//            probabilitaV.contentView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//            probabilitaV.contentView.center = self.probabilita.center
//            probabilitaV.alpha = 0
//            probabilitaV.backgroundColor = .white
//
//            probabilitaV.contentView.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
//            window.addSubview(probabilitaV)
//            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//                self.probabilitaV.contentView.transform = CGAffineTransform.identity
//                self.probabilitaV.contentView.center = self.view.center
//                self.probabilitaV.alpha = 1
//                self.nero.alpha = 0.7
//            }, completion: nil)
//
//        }
//
       
    }
    func handleDismiss() {
        UIView.animate(withDuration: 0.3) {
            self.nero.alpha = 0
            self.probabilitaV.alpha = 0
        }
    }

  
    @IBAction func orari_pressed(_ sender: Any) {
        let pop = PopUp()
        pop.presentaPopUp(sender: self, icona: probabilita, vista: view, gioco: gioco!.probabilita, titolo: "ORARI DI GIOCO".localized)
    }
    
    
}
