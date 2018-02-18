//
//  Sezione.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 07/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class Sezione: UICollectionViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    
    var sedi:[String:String] = ["CN":"Ca' Noghera","VE":"Venezia"]
    var feedArray = [Events]()
    let formatter = DateFormatter()
    
    var currentMaxDisplayedCell = 0
    var currentMaxDisplayedSection = 0
    var cellZoomXScaleFactor = 1.25;
    var cellZoomYScaleFactor = 1.25;
    var cellZoomAnimationDuration = 0.70;
    var cellZoomInitialAlpha = 0.3;
    var cellZoomXOffset = 0;
    var cellZoomYOffset = 0;
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    //Property for interaction controller
    let closeOnScrollDown = CloseOnScrollDown()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UINib(nibName: "EventCell", bundle: nil), forCellWithReuseIdentifier: "EventCellId")
        cv.register(UINib(nibName: "GiochiCell", bundle: nil), forCellWithReuseIdentifier: "giochiCellId")
        //cv.register(EventListCell.self, forCellWithReuseIdentifier: "EventCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    func fetchDatabase () {
        LoadDatabase.sharedInstance.loadDatabase { (eventi: [Events]) in
            self.feedArray = eventi
            self.feedArray.sort(by: { $0.StartDate.compare($1.StartDate as Date) == ComparisonResult.orderedDescending })
            self.collectionView.reloadData()
        }
    }
    func setupViews() {
        fetchDatabase()
        addSubview(collectionView)
        addConstraintsWithFormnat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormnat(format: "V:|[v0]|", views: collectionView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return feedArray.count
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "EventCellId",  for: indexPath) as! EventListCell
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

    //Metodo utilizzato per dimensionare la cella - deve essere impostato il delegate UICollectionViewDelegateFlowLayout
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
            let height = frame.width*9/16
    
            if estimateRect(rect:frame, data: feedArray[indexPath.row].Name)  > 21 {
                return CGSize(width: frame.width,height: height + 5 + 42 + 21 + 5 + 25 + 5 + 7)
            } else {
                return CGSize(width: frame.width,height: height + 5 + 21 + 21 + 5 + 25 + 5 + 7)
            }
    
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Set frame of cell
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
        openingFrame = CGRect(x: (frameToOpenFrom.origin.x), y: (frameToOpenFrom.origin.y) + 64, width: (frameToOpenFrom.size.width), height: (frameToOpenFrom.size.height))
        
        //Present view controller
        let expandedVC = storyboard.instantiateViewController(withIdentifier: "EventDetails") as! EventDetails
        expandedVC.transitioningDelegate = self
        expandedVC.modalPresentationStyle = .currentContext
        expandedVC.event = feedArray[indexPath.row]
        closeOnScrollDown.wireToViewController(viewController: expandedVC)
        if let keyWindow = UIApplication.shared.keyWindow?.rootViewController {
            keyWindow.present(expandedVC, animated: true, completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    
    //Funzione per calcolare l'altezza dell'etichetta titolo - la proprietà number lines è impostata a 2 nella storyboard
    func estimateRect(rect: CGRect, data: String) -> CGFloat {
        let size = CGSize(width: rect.width - 8 - 8 - 25 - 8, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let estimateRect = NSString(string: data).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return estimateRect.size.height
    }
    
    func resetViewedCells() {
        currentMaxDisplayedSection = 0
        currentMaxDisplayedCell = 0
    }
    

    
}
