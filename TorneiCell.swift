//
//  TorneiCell.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 08/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit


class TorneiCell: Sezione {
    var feedArrayTornei = [Tornei]()
    override func fetchDatabase () {
        LoadDatabase.sharedInstance.loadTornei { (eventi: [Tornei]) in
            self.feedArrayTornei = eventi
            self.feedArrayTornei.sort(by: { $0.StartDate.compare($1.StartDate as Date) == ComparisonResult.orderedDescending })
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArrayTornei.count
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = frame.width*9/16
        
        if estimateRect(rect:frame, data: feedArrayTornei[indexPath.row].TournamentName)  > 21 {
            return CGSize(width: frame.width,height: height + 5 + 42 + 21 + 5 + 25 + 5 + 7)
        } else {
            return CGSize(width: frame.width,height: height + 5 + 21 + 21 + 5 + 25 + 5 + 7)
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "EventCellId",  for: indexPath) as! EventListCell
        formatter.dateFormat = "dd MMM"
        let myDate = formatter.string(from: feedArrayTornei[indexPath.row].StartDate as Date)
        let myDateEnd = formatter.string(from: feedArrayTornei[indexPath.row].EndDate as Date)
        
        
        
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
        if (feedArrayTornei[indexPath.row].EndDate != feedArrayTornei[indexPath.row].StartDate) {
            cell.QuandoLabel.text = "Dal \(myDate) al \(myDateEnd)".localized
        } else {
            cell.QuandoLabel.text = myDate
        }
        
        cell.titolo.text = feedArrayTornei[indexPath.row].TournamentName
        cell.intro.text = feedArrayTornei[indexPath.row].TournamentDescription
        cell.DoveLabel.text = sedi[feedArrayTornei[indexPath.row].office]
        cell.speakingText = feedArrayTornei[indexPath.row].TournamentDescription
        cell.image.sd_setImage(with: URL(string: feedArrayTornei[indexPath.row].ImageTournament), placeholderImage: UIImage(named: "sediciNoni"))
       
        
        if estimateRect(rect:cell.frame, data: feedArrayTornei[indexPath.row].TournamentName)  > 21{
            cell.titoloHeight?.constant = 42
        } else {
            cell.titoloHeight?.constant = 21
        }
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Set frame of cell
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
        openingFrame = CGRect(x: (frameToOpenFrom.origin.x), y: (frameToOpenFrom.origin.y) + 64, width: (frameToOpenFrom.size.width), height: (frameToOpenFrom.size.height))
        
        //Present view controller
        let expandedVC = storyboard.instantiateViewController(withIdentifier: "TorneoDetails") as! TorneiDetails
        expandedVC.transitioningDelegate = self
        expandedVC.modalPresentationStyle = .currentContext
        expandedVC.torneo = feedArrayTornei[indexPath.row]
        closeOnScrollDown.wireToViewController(viewController: expandedVC)
        if let keyWindow = UIApplication.shared.keyWindow?.rootViewController {
            keyWindow.present(expandedVC, animated: true, completion: nil)
        }
        
        //let viewLauncher = VideoLuncher()
        //viewLauncher.showVideoPlayer()
        
    }
}
