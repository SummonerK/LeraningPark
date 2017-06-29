//
//  chooseVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/28.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class chooseVC: UIViewController {

    @IBOutlet weak var imageVsub: UIImageView!
    
    @IBOutlet weak var label_count: UILabel!
    
    @IBOutlet weak var collection_main: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageVsub.image = createImageWithColor(color: UIColor.white)
        setRadiusFor(toview: imageVsub, radius: 3, lineWidth: 0, lineColor: UIColor.white)
   
    }
    @IBAction func closeCover(_ sender: Any) {
        
    }
    
    //支付
    @IBAction func buyNow(_ sender: Any) {
//        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsPayVC") as! GoodsPayVC
//        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    //添加数量
    @IBAction func countAdd(_ sender: Any) {
        
    }
    //减少商品数量
    @IBAction func countFls(_ sender: Any) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
