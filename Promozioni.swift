//
//  Promozioni.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 20/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class Promozioni: UICollectionViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate  {
    
   
   
    let cellPromo = "Promozione"
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //Property for interaction controller
    let closeOnScrollDown = CloseOnScrollDown()
    
    lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UINib(nibName: "Promozione", bundle: nil), forCellWithReuseIdentifier: cellPromo)

        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
   
    var promos:[PromozioneStruct] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        Promo.sharedInstance.caricaPromo { (promozioni: [PromozioneStruct]) in
            self.promos = promozioni
            self.collectionView.reloadData()
        }
    }
    
    func setupViews() {
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
        addConstraintsWithFormnat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormnat(format: "V:|[v0]|", views: collectionView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPromo, for: indexPath as IndexPath) as! AnnotatedPhotoCell
        cell.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        cell.promo = promos[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
     var openingFrame: CGRect?
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let vc = storyboard.instantiateViewController(withIdentifier: "Promozione") as! Promozione
        
        if let imageCell = collectionView.cellForItem(at: indexPath) as? AnnotatedPhotoCell {
            vc.cc_setZoomTransition(originalView: imageCell.imageView)
            vc.cc_swipeBackDisabled = false
        }
        vc.promo = promos[indexPath.row]
        if let keyWindow = UIApplication.shared.keyWindow?.rootViewController {
            keyWindow.present(vc, animated: true, completion: nil)
        }
        
        return false
    }
    //MARK: Transition delegate
    
   

}
extension Promozioni: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        //return promos[indexPath.item].image.size.height
        return 180
    }
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
