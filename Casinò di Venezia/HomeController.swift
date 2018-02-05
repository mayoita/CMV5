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
import FirebaseStorage
import FBSDKLoginKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
   
   
    var databaseRef:DatabaseReference!
    var sedi:[String:String] = ["CN":"Ca' Noghera","VE":"Venezia"]
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
    var loginImage = UIImage()
    var loginButtonItem = UIBarButtonItem()
    var rightView:UIView = UIView()
    var imageViewRight:UIImageView = UIImageView()
    
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    
    
    //Property for interaction controller
    private let closeOnScrollDown = CloseOnScrollDown()
    
    //MARK: Methods

    func buttonAction() {
        
            isMenuOpen = !isMenuOpen
            verticalConstraints.constant = isMenuOpen ? 60 : 0
        
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
        
  
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
     //   if let index = self.index {
            //self.label.text = "Page " + String(index)
            //self.promptLabel.isHidden = index != 1
      //  }
      
        loadDatabase()
        navigationItem.title = "Home".localized
        //self.collectionView?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width - 32,height:  view.frame.height))
        titleLabel.text = "Home".localized
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        navigationItem.titleView = titleLabel
        collectionView?.backgroundColor = UIColor.white
       
        setupMenuBar()
       setupNavBarButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshButtonImage()
    }
    func refreshButtonImage() {
        if let token = FBSDKAccessToken.current() {
            let storage = Storage.storage()
            var storageRef = StorageReference()
            storageRef = storage.reference(forURL: "gs://cmv-gioco.appspot.com/")
            let profilePicRef = storageRef.child("profile_images/").child((Auth.auth().currentUser?.uid)!+".jpg")
            profilePicRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    
                } else {
                    if (data != nil) {
                        self.loginImage = UIImage(data: data!)!.withRenderingMode(.alwaysOriginal)
                        self.imageViewRight.image = self.loginImage
                    }
                }
            }
        } else {
            loginImage = (UIImage(named: "user")?.withRenderingMode(.alwaysOriginal))!
            imageViewRight.image = loginImage
        }
    }
    func setupNavBarButtons(){
        
        imageViewRight.frame = CGRect(x:0,y: 0,width: 40,height: 40)
        loginImage = UIImage(named: "user")!
        imageViewRight.image = loginImage
        //put the imageView inside a uiview
        rightView.frame = imageViewRight.frame
        rightView.layer.cornerRadius = imageViewRight.frame.size.width/2
        rightView.layer.borderColor = UIColor.white.cgColor
        rightView.layer.borderWidth = 1.0
        rightView.clipsToBounds = true
        rightView.addSubview(imageViewRight)
        //create the tap gesture recognizer for that uiview
        let rightGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handledLogIn))
        rightView.addGestureRecognizer(rightGestureRecognizer)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
    
    func handledLogIn () {
        let logIn = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
        self.present(logIn, animated: true, completion: nil)
    }
    

    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    } ()
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        let a = UIView()
        let myNewView=UIView(frame: CGRect(x: 10, y: 100, width: 300, height: 200))
        
        self.view.addSubview(myNewView)
        let views = ["view": menuBar]
      
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints =  NSLayoutConstraint.constraints(withVisualFormat: "V:[view(50)]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
    }
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "cellId",  for: indexPath) as! EventListCell
        formatter.dateFormat = "dd MMM"
        let myDate = formatter.string(from: feedArray[indexPath.row].StartDate as Date)
        let myDateEnd = formatter.string(from: feedArray[indexPath.row].EndDate as Date)
       
        
        
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
        if (feedArray[indexPath.row].EndDate != feedArray[indexPath.row].StartDate) {
            cell.QuandoLabel.text = "Dal \(myDate) al \(myDateEnd)".localized
        } else {
            cell.QuandoLabel.text = myDate
        }
        
        cell.titolo.text = feedArray[indexPath.row].Name
        cell.intro.text = feedArray[indexPath.row].Description
        cell.DoveLabel.text = sedi[feedArray[indexPath.row].office]
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
    //Metodo utilizzato per dimensionare la cella - deve essere impostato il delegate UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let height = view.frame.width*9/16
        
        if estimateRect(rect:view.frame, data: feedArray[indexPath.row].Name)  > 21 {
            return CGSize(width: view.frame.width,height: height + 5 + 42 + 21 + 5 + 25 + 5 + 7)
        } else {
            return CGSize(width: view.frame.width,height: height + 5 + 21 + 21 + 5 + 25 + 5 + 7)
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
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Set frame of cell
        let attributes = self.collectionView?.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = self.collectionView?.convert(attributesFrame!, to: self.collectionView?.superview)
        openingFrame = CGRect(x: (frameToOpenFrom?.origin.x)!, y: (frameToOpenFrom?.origin.y)! + 64, width: (frameToOpenFrom?.size.width)!, height: (frameToOpenFrom?.size.height)!)
        
        //Present view controller
        let expandedVC = storyboard?.instantiateViewController(withIdentifier: "EventDetails") as! EventDetails
        expandedVC.transitioningDelegate = self
        expandedVC.modalPresentationStyle = .currentContext
        expandedVC.event = feedArray[indexPath.row]
        closeOnScrollDown.wireToViewController(viewController: expandedVC)
        present(expandedVC, animated: true, completion: nil)
    }
    
    //MARK: Transition delegate
    
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
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return closeOnScrollDown.hasStarted ? closeOnScrollDown : nil
    }
    
    func loadDatabase(){
       
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.current
        let events = databaseRef.child("Events")
        events.observe(.value, with: {(eventsSnapshot)in
            
            let eventsDictionary = eventsSnapshot.value as! NSDictionary
            // creo un array temporaneo per la conversione del dizionario in Specialist
            var specialistArray: [Events] = []
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
                
                let event = Events(Book: Book, Description: Description, ImageEvent1: ImageEvent1, ImageEvent2: ImageEvent2, ImageEvent3: ImageEvent3, ImageName: ImageName, isSlotEvents: isSlotEvents, memo: memo, Name: Name, StartDate: StartDate, EndDate: EndDate, EventType: EventType, office: office, URL: URL, URLBook: URLBook)
                
                specialistArray.append(event)
                
            }
            self.feedArray = specialistArray
            self.feedArray.sort(by: { $0.StartDate.compare($1.StartDate as Date) == ComparisonResult.orderedDescending })
            self.collectionView?.reloadData()
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

