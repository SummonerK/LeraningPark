//
//  ViewController.swift
//  CCardTest
//
//  Created by Luofei on 2017/9/26.
//  Copyright © 2017年 FreeMud. All rights reserved.
//

import UIKit

/// 屏幕高度
let IBScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕宽度
let IBScreenWidth = UIScreen.main.bounds.size.width

func AnyColor(alpha:CGFloat)->UIColor{
    let anycolor = UIColor.init(hue: (CGFloat(Float(arc4random()%256) / 256.0)), saturation: (CGFloat(Float(arc4random()%256) / 256.0)), brightness: (CGFloat(Float(arc4random()%256) / 256.0)), alpha: alpha)
    return anycolor
}


class ViewController: UIViewController {
    
    @IBOutlet weak var CVMain: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContentView()
        
        
        
        self.CVMain.scrollToItem(at: IndexPath.init(row: 3, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setContentView() {
//        let flowLayout = UICollectionViewFlowLayout()
//        
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, IBScreenWidth*0.1, 0, IBScreenWidth*0.1)
//        
//        flowLayout.minimumLineSpacing = IBScreenWidth*0.1
//        
//        flowLayout.minimumInteritemSpacing = 0
//        
//        CVMain.collectionViewLayout = flowLayout
        
        let flowLayout = IBCardLayout()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, IBScreenWidth*0.08, 0, IBScreenWidth*0.08)
        
        flowLayout.minimumLineSpacing = IBScreenWidth*0.04
        
        flowLayout.minimumInteritemSpacing = 0
        
        CVMain.collectionViewLayout = flowLayout
        
//        CVMain.backgroundColor = UIColor.lightGray
        
        CVMain.register(UINib.init(nibName: "CCellTest", bundle: nil), forCellWithReuseIdentifier: "CCellTest")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
}

extension ViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellTest", for: indexPath) as! CCellTest
        
        cell.label_test.text = "第 \(indexPath.row) 目"
        
        return cell
        
    }
    
    
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize.init(width: IBScreenWidth*0.8, height: IBScreenHeight-120)
    }
    
}

