//
//  ViewController.swift
//  CTDemo228
//
//  Created by Luofei on 2018/2/28.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelPhone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Random(_ sender: Any) {
        
//        labelPhone.text = "".randomPhoneNumber()
        
        labelPhone.text =  RandomString.sharedInstance.getPhoneNum()
    }

    @IBAction func creazyCall(_ sender: Any) {
        
        
    }

}


extension String{
    
    func randomPhoneNumber() -> String{
        
        let num = arc4random_uniform(89999999) + 10000000
        
        let str = "135\(num)"
        
        return str
    }
    
    
}

/// 随机字符串生成
class RandomString {
    let characters = "0123456789"
    
    /**
     生成随机字符串,
     
     - parameter length: 生成的字符串的长度
     
     - returns: 随机生成的字符串
     */
    func getRandomStringOfLength(length: Int) -> String {
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.characters.count)))
            ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return ranStr
        
    }
    
    func getPhoneNum() -> String {
        return "156" + getRandomStringOfLength(length: 8)
    }
    
    
    private init() {
        
    }
    static let sharedInstance = RandomString()
}

