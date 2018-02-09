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

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
 
    var index: Int?
    var isMenuOpen = false
    var verticalConstraints: NSLayoutConstraint!

    var loginImage = UIImage()
    var loginButtonItem = UIBarButtonItem()
    var rightView:UIView = UIView()
    var imageViewRight:UIImageView = UIImageView()
    let cellId = "cellId"
    let cellIdTornei = "cellIdTornei"
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    let titoli = ["Home".localized, "Eventi".localized, "Tornei".localized, "Promozioni".localized,"Giochi".localized,"Slot".localized]


    
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
        //navigationItem.title = "  Home".localized
        //self.collectionView?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width - 32,height:  view.frame.height))
        titleLabel.text = titoli[0]
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        navigationItem.titleView = titleLabel
        setupCollectionView ()
        setupMenuBar()
        setupNavBarButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshButtonImage()
    }
    
    func setupCollectionView () {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.register(Sezione.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TorneiCell.self, forCellWithReuseIdentifier: cellIdTornei)
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
                    print(error.localizedDescription)
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
    func scrollToMenuIndex (menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        setTitleForIndex(index: menuIndex)
    }
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titoli[index])"
        }
    }
    func handledLogIn () {
        let logIn = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
        self.present(logIn, animated: true, completion: nil)
    }
    

    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    } ()
    
    private func setupMenuBar(){
       // navigationController?.hidesBarsOnSwipe = true
        let goldView = UIView()
        goldView.backgroundColor = StyleKit.fillColor
        view.addSubview(goldView)
        view.addConstraintsWithFormnat(format: "H:|[v0]|", views: goldView)
        view.addConstraintsWithFormnat(format: "V:[v0(50)]", views: goldView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormnat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormnat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraints?.constant = scrollView.contentOffset.x / CGFloat(numeroPulsanti)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
       menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
       setTitleForIndex(index: Int(index))
    }
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        if indexPath.item == 0 {
            identifier = cellId
        } else if indexPath.item == 1 {
            identifier = cellIdTornei
        } else {
            identifier = cellId
        }
        
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: identifier,  for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
<<<<<<< HEAD
    
    
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
        
=======
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
>>>>>>> 51756f7f0026a219a475a216c6ce34863d521afa
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numeroPulsanti
    }

   

    
}

