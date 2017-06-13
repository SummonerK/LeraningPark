//
//  HomeHeaderV.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/12.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol HomeHeaderDelegate{
    func activitiesAction(path : String)
    func itemActionWithIndexPath(indexPath : IndexPath)
}

class HomeHeaderV: UITableViewCell {
    
    var delegate:HomeHeaderDelegate?
    
    @IBOutlet weak var imgv_HomeHeader: UIImageView!
    
    @IBOutlet weak var CollectionV_HomeHeader: UICollectionView!
    
    @IBOutlet weak var search_homeHeader: UISearchBar!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }
    
    @IBAction func HomeImageVAction(_ sender:Any){
        
        self.delegate?.activitiesAction(path: "homePath")
    }
    
    
    func setupView(){
        CollectionV_HomeHeader.register(UINib.init(nibName: "CCellHomeHeader", bundle: nil), forCellWithReuseIdentifier: "CCellHomeHeader")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension HomeHeaderV:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        self.delegate?.itemActionWithIndexPath(indexPath: indexPath)
        
    }
    
}

extension HomeHeaderV:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellHomeHeader", for: indexPath) as! CCellHomeHeader
        
        return cell
        
    }
    
}

extension HomeHeaderV:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: IBScreenWidth/5, height: self.CollectionV_HomeHeader.frame.height/2)
    }
    
}

