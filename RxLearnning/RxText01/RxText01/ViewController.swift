//
//  ViewController.swift
//  RxText01
//
//  Created by Luofei on 2018/8/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

class ViewController: UIViewController {
    
    //tableView对象
    @IBOutlet weak var tableView: UITableView!
    
    //歌曲列表数据源
    let musicListViewModel = MusicListViewModel()
    
    //负责对象销毁
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: "TCellMusic", bundle: nil), forCellReuseIdentifier: "TCellMusic")
        
        //将数据源数据绑定到tableView上
        musicListViewModel.data
            .bind(to: tableView.rx.items(cellIdentifier:"TCellMusic")) { _, music, cell in
                (cell as! TCellMusic).label_title.text = music.name
                (cell as! TCellMusic).label_subtitle.text = music.singer
            }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { music in
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
    }
    
    @IBAction func actionNext(_ sender: Any) {
        
        let VC = MYCalendarVC.init(nibName: "MYCalendarVC", bundle: nil)
        
        self.present(VC, animated: true, completion: nil)
        
    }
}

//
//class ViewController: UIViewController {
//    
//    //tableView对象
//    @IBOutlet weak var tableView: UITableView!
//    
//    //歌曲列表数据源
//    let musicListViewModel = MusicListViewModel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.register(UINib.init(nibName: "TCellMusic", bundle: nil), forCellReuseIdentifier: "TCellMusic")
//        
//        tableView.reloadData()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
//extension ViewController: UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 90
//    }
//    //返回单元格数量
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return musicListViewModel.data.count
//    }
//    
//    //返回对应的单元格
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
//        -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellMusic", for: indexPath) as! TCellMusic
//            let music = musicListViewModel.data[indexPath.row]
//            cell.label_title?.text = music.name
//            cell.label_subtitle?.text = music.singer
//            return cell
//    }
//}
//
//extension ViewController: UITableViewDelegate {
//    //单元格点击
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("你选中的歌曲信息【\(musicListViewModel.data[indexPath.row])】")
//    }
//}

