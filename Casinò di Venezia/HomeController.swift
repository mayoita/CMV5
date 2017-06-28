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
import QuartzCore

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var tabBarView: TabBarView!
    var databaseRef:FIRDatabaseReference!
    var feedArray = [Events]()
    let formatter = DateFormatter()
    var index: Int?
    var isMenuOpen = false
    var verticalConstraints: NSLayoutConstraint!
    var currentMaxDisplayedCell = 0
    var currentMaxDisplayedSection = 0
    var cellZoomXScaleFactor = 1.25;
    var cellZoomYScaleFactor = 1.25;
    var cellZoomAnimationDuration = 0.70;
    var cellZoomInitialAlpha = 0.3;
    var cellZoomXOffset = 0;
    var cellZoomYOffset = 0;
    
    //MARK: Methods
    func customization()  {
     
        
        //TabbarView setup
        self.view.addSubview(self.tabBarView)
        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
        
        let descHorizontal = "H:|[tabBarView]|"
        let descVertical = "V:|[tabBarView(60)]|"
        
        let viewsDict = ["tabBarView": tabBarView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descHorizontal,
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: viewsDict)
        //verticalConstraints.constraints(withVisualFormat: descVertical,
                                                                  // options: NSLayoutFormatOptions(rawValue: 0),
                                                                //   metrics: nil,
                                                                //   views: viewsDict)
        verticalConstraints = NSLayoutConstraint.init(item: self.tabBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints([verticalConstraints])
        
        let btn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btn.backgroundColor = UIColor.green
        btn.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        btn.tag = 1
        self.view.addSubview(btn)
       
        
//        let _ = NSLayoutConstraint.init(item: self.view, attribute: .top, relatedBy: .equal, toItem: self.tabBarView, attribute: .top, multiplier: 1.0, constant: -64).isActive = true
//        let _ = NSLayoutConstraint.init(item: self.view, attribute: .left, relatedBy: .equal, toItem: self.tabBarView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
//        let _ = NSLayoutConstraint.init(item: self.view, attribute: .right, relatedBy: .equal, toItem: self.tabBarView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
//        self.tabBarView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        //ViewController init
        
        }
    func buttonAction() {
        
            isMenuOpen = !isMenuOpen
            verticalConstraints.constant = isMenuOpen ? 60 : 0
        
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = self.index {
            //self.label.text = "Page " + String(index)
            //self.promptLabel.isHidden = index != 1
        }
        self.customization()
        loadDatabase()
        navigationItem.title = "Home"
        //self.collectionView?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width - 32,height:  view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        navigationItem.titleView = titleLabel
        collectionView?.backgroundColor = UIColor.white
       
        setupMenuBar()
    }

    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    } ()
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        let views = ["view": menuBar]
      
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints =  NSLayoutConstraint.constraints(withVisualFormat: "V:|[view(50)]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
    }
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "cellId",  for: indexPath) as! EventListCell
        formatter.dateFormat = "dd"
        let myDate = formatter.string(from: feedArray[indexPath.row].StartDate as Date)
        formatter.dateFormat = "MMM"
        let myMonth = formatter.string(from: feedArray[indexPath.row].StartDate as Date)
        
        
        //  Converted with Swiftify v1.0.6381 - https://objectivec2swift.com/
        if (indexPath.section == 0 && currentMaxDisplayedCell == 0) || indexPath.section > currentMaxDisplayedSection {
            //first item in a new section, reset the max row count
            currentMaxDisplayedCell = -1
            //-1 because the check for currentMaxDisplayedCell has to be > rather than >= (otherwise the last cell is ALWAYS animated), so we need to set this to -1 otherwise the first cell in a section is never animated.
        }
     //   if indexPath.section >= currentMaxDisplayedSection && indexPath.row > currentMaxDisplayedCell {
            //this check makes cells only animate the first time you view them (as you're scrolling down) and stops them re-animating as you scroll back up, or scroll past them for a second time.
            //now make the image view a bit bigger, so we can do a zoomout effect when it becomes visible
            cell.contentView.alpha = CGFloat(cellZoomInitialAlpha)
            let transformScale = CGAffineTransform(scaleX: CGFloat(cellZoomXScaleFactor), y: CGFloat(cellZoomYScaleFactor))
            let transformTranslate = CGAffineTransform(translationX: CGFloat(cellZoomXOffset), y: CGFloat(cellZoomYOffset))
            cell.contentView.transform = transformScale.concatenating(transformTranslate)
            collectionView.bringSubview(toFront: cell.contentView)
            UIView.animate(withDuration: cellZoomAnimationDuration, delay: 0.1, options: .allowUserInteraction, animations: {() -> Void in
                cell.contentView.alpha = 1
                //clear the transform
                cell.contentView.transform = CGAffineTransform.identity
            }, completion: { _ in })
            currentMaxDisplayedCell = indexPath.row
            currentMaxDisplayedSection = indexPath.section
     //   }
        
        cell.titolo.text = feedArray[indexPath.row].Name
        cell.intro.text = feedArray[indexPath.row].Description
        cell.data.text = myDate
        cell.data.layer.masksToBounds = true
        cell.data.layer.cornerRadius = 5.0
        cell.mese.text = myMonth
        cell.speakingText = feedArray[indexPath.row].Description
        cell.image.sd_setImage(with: URL(string: feedArray[indexPath.row].ImageName), placeholderImage: UIImage(named: "sediciNoni"))
       
        if estimateRect(rect:cell.frame, data: feedArray[indexPath.row].Name)  > 21{
            cell.titoloHeight?.constant = 42
        } else {
            cell.titoloHeight?.constant = 21
        }
        
        return cell
    }
    func resetViewedCells() {
        currentMaxDisplayedSection = 0
        currentMaxDisplayedCell = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = view.frame.width*9/16
      
        
        if estimateRect(rect:view.frame, data: feedArray[indexPath.row].Name)  > 21 {
            return CGSize(width: view.frame.width,height: height + 5 + 42 + 21 + 5 + 7)
        } else {
            return CGSize(width: view.frame.width,height: height + 5 + 21 + 21 + 5 + 7)
        }
       
    }
    
    //Funzione per calcolare l'altezza dell'etichetta titolo - la proprietà number lines è impostata a 2 nella storyboard
    func estimateRect(rect: CGRect, data: String) -> CGFloat {
        let size = CGSize(width: rect.width - 10 - 42 - 10, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let estimateRect = NSString(string: data).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return estimateRect.size.height
    }
    
    var openingFrame: CGRect?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimator.animator
        presentationAnimator.openingFrame = openingFrame!
        presentationAnimator.transitionMode = .Present
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = ExpandAnimator.animator
        presentationAnimator.openingFrame = openingFrame!
        presentationAnimator.transitionMode = .Dismiss
        return presentationAnimator
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Set frame of cell
        let attributes = self.collectionView?.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = self.collectionView?.convert(attributesFrame!, to: self.collectionView?.superview)
        openingFrame = frameToOpenFrom
        
        //Present view controller
        let expandedVC = EventDetails()
        expandedVC.transitioningDelegate = self
        expandedVC.modalPresentationStyle = .custom
        present(expandedVC, animated: true, completion: nil)
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
                
            }
            self.feedArray.sort(by: { $0.StartDate.compare($1.StartDate as Date) == ComparisonResult.orderedDescending })
            self.collectionView?.reloadData()
        })
        
    }
    
}

