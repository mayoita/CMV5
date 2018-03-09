//
//  MenuBar.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 23/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
let numeroPulsanti = 6
let cellId = "cellIdMenu"

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var horizontalBarLeftAnchorConstraints: NSLayoutConstraint?
    var homeController: HomeController?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numeroPulsanti
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image =  MyConstants.immagini[indexPath.item]
        cell.imageNumber = indexPath.item
        if cell.isSelected {
            cell.imageView.image = MyConstants.immaginiSelezionate[indexPath.item]
        }
        return cell
    }
    
    //Per
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(numeroPulsanti), height: frame.height)
    }
    //Per eliminare lo spazio tra le celle
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = CGFloat(indexPath.item)*frame.width / 4
//        horizontalBarLeftAnchorConstraints?.constant = x
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = StyleKit.oro
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormnat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormnat(format: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        setupHorizontalBar()
    }
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = StyleKit.oroScuro
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraints = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraints?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/CGFloat(numeroPulsanti)).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class MenuCell: UICollectionViewCell {
   
    var imageNumber:Int = 0
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = StyleKit.imageOfMic()
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    override var isHighlighted: Bool {
        didSet {
            print(imageNumber)
            print(String(describing: imageView))
            imageView.image = isHighlighted ? MyConstants.immaginiSelezionate[imageNumber] : MyConstants.immagini[imageNumber]
        }
    }
    override var isSelected: Bool {
        didSet {
            imageView.image = isSelected ? MyConstants.immaginiSelezionate[imageNumber] : MyConstants.immagini[imageNumber]
           
        }
    }
    func setupViews () {
        backgroundColor = StyleKit.oro
        addSubview(imageView)
        addConstraintsWithFormnat(format: "H:[v0(40)]", views: imageView)
        addConstraintsWithFormnat(format: "V:[v0(40)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
