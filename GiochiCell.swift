//
//  GiochiCell.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 14/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class GiochiCell: Sezione {
    let giochiDBURL: URL = Bundle.main.url(forResource: "Giochi",   withExtension: "plist")!
    typealias Settings = [giochiDB]
    var giochi: Settings?
    

    override func fetchDatabase () {
        do {
            let data = try Data.init(contentsOf: giochiDBURL)
            let decoder = PropertyListDecoder()
            giochi = try decoder.decode(Settings.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (giochi?.count)!
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = frame.width*9/16
        return CGSize(width: frame.width,height: height + 5 + 16 + 67 + 5)
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: "giochiCellId",  for: indexPath) as! GiochiCella

        
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

        
        cell.titolo.text = giochi![indexPath.row].titolo
        //cell.titolo.font = UIFont(name: "VeniceCasino-Regular", size: 18)
        cell.intro.text = giochi![indexPath.row].main
        cell.image.image = UIImage(named: giochi![indexPath.row].immagine)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Set frame of cell
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
        openingFrame = CGRect(x: (frameToOpenFrom.origin.x), y: (frameToOpenFrom.origin.y) + 64, width: (frameToOpenFrom.size.width), height: (frameToOpenFrom.size.height))
        
        //Present view controller
        let expandedVC = storyboard.instantiateViewController(withIdentifier: "GiochiDettaglio") as! GiochiDettaglio
        expandedVC.transitioningDelegate = self
        expandedVC.modalPresentationStyle = .currentContext
        //expandedVC.torneo = feedArrayTornei[indexPath.row]
        expandedVC.gioco = giochi?[indexPath.row]
        closeOnScrollDown.wireToViewController(viewController: expandedVC)
        if let keyWindow = UIApplication.shared.keyWindow?.rootViewController {
            keyWindow.present(expandedVC, animated: true, completion: nil)
        }
        
        //let viewLauncher = VideoLuncher()
        //viewLauncher.showVideoPlayer()
        
    }
    
}
