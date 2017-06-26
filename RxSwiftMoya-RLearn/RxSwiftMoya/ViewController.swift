//
//  ViewController.swift
//  RxSwiftMoya
//
//  Created by Chao Li on 9/20/16.
//  Copyright © 2016 ERStone. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import SwiftyJSON

//封装的日志输出功能（T表示不指定日志信息参数类型）
func PrintFM<T>(_ message:T, file:String = #file, function:String = #function,
             line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("☆☆【☆】\(fileName)\t【☆】ATLine:\(line)\t【☆】\(function)\n【☆】LOG:\(message)")
    #endif
}

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel  = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        /*方法二
        let myQueue = DispatchQueue(label: "第一条线程")
        
        let group = DispatchGroup()
        
        myQueue.async {
            self.viewModel.getPosts()
                .subscribe(onNext: { (posts: [Post]) in
                    //do something with posts
                    print(posts.count)
                    
                },onError:{error in
                    
                    print("11111111Error//////Error \((error as! RxSwiftMoyaError).rawValue)")
                    
                    sleep(10)
                    
                })
                .addDisposableTo(self.disposeBag)
        }
        
        myQueue.async {
            self.viewModel.getVCode(cTel: "15600703631", type: "1")
                .subscribe(onNext: { (post: PostCV) in
                    //do something with post
                    
                    print("3333333333\(post.description)")
                    sleep(5)
                    
                    
                },onError:{error in
                    print("3333333333Error//////Error \(error)")
                    
                })
                .addDisposableTo(self.disposeBag)
            //            PrintFM("Q3")
        }
        
        myQueue.async(group: nil, qos: .default, flags: .barrier) { 
            PrintFM("完成")
        }
        
        */
        
        
        let myQueue = DispatchQueue(label: "第一条线程")
        
        let group = DispatchGroup()
        
        myQueue.async {
            self.viewModel.getPosts()
                .subscribe(onNext: { (posts: [Post]) in
                    //do something with posts
                    print(posts.count)
                    
                },onError:{error in
                    
                    print("11111111Error//////Error \((error as! RxSwiftMoyaError).rawValue)")
                    
                    sleep(10)
                    
                })
                .addDisposableTo(self.disposeBag)
        }
        
        myQueue.async {
            self.viewModel.getVCode(cTel: "15600703631", type: "1")
                .subscribe(onNext: { (post: PostCV) in
                    //do something with post
                    
                    print("3333333333\(post.description)")
                    sleep(5)
                    
                    
                },onError:{error in
                    print("3333333333Error//////Error \(error)")
                    
                })
                .addDisposableTo(self.disposeBag)
            //            PrintFM("Q3")
        }
        
        myQueue.async(group: nil, qos: .default, flags: .barrier) {
            PrintFM("完成")
        }

        /* 方法1 信号量
        let globalQ = DispatchQueue.global(qos:.default)
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 3)
        
//        group.wait(timeout: DispatchTime(uptimeNanoseconds: 10*NSEC_PER_SEC))
        
        let _ = semaphore.wait(timeout: DispatchTime.now() + 2.0) //阻碍时等两秒信号量还是为0时将不再等待, 继续执行下面的代码
        globalQ.async(group: group, execute: {
            
            self.viewModel.getPosts()
                .subscribe(onNext: { (posts: [Post]) in
                    //do something with posts
                    print(posts.count)
                    
                },onError:{error in
                    
                    print("11111111Error//////Error \((error as! RxSwiftMoyaError).rawValue)")
                    
                    sleep(10)
                    
                })
                .addDisposableTo(self.disposeBag)
            
//            PrintFM("Q1")
        })
        
        let _ = semaphore.wait(timeout: DispatchTime.now() + 2.0) //阻碍时等两秒信号量还是为0时将不再等待, 继续执行下面的代码
        
        globalQ.async(group: group, execute: {
            let dic_temp = NSMutableDictionary()
            let dic = ["key":"value"]
            
            dic_temp.setValue(dic, forKey: "newkey")
            
            self.viewModel.createPost(title: "Title 1", body: "Body 1", userId: 1)
                .subscribe(onNext: { (post: Post) in
                    //do something with post
                    print("if PostData \(post.title!)")
                    post.id = 1
                    print("if Post Des \(post.description)")
                    
                    
                },onError:{error in
                    print("22222222Error//////Error \((error as! RxSwiftMoyaError).rawValue)")
                    
                    sleep(10)
                    
                })
                .addDisposableTo(self.disposeBag)
            
//            PrintFM("Q2")
        })
        
        let _ = semaphore.wait(timeout: DispatchTime.now() + 2.0) //阻碍时等两秒信号量还是为0时将不再等待, 继续执行下面的代码
        globalQ.async(group: group, execute: {
            self.viewModel.getVCode(cTel: "15600703631", type: "1")
                .subscribe(onNext: { (post: PostCV) in
                    //do something with post
                    
                    print("3333333333\(post.description)")
                    sleep(5)
                    
                    
                },onError:{error in
                    print("3333333333Error//////Error \(error)")
                    
                })
                .addDisposableTo(self.disposeBag)
//            PrintFM("Q3")
        })
        
        group.notify(queue: globalQ) {
            
            PrintFM("完成")
        }
        let result = group.wait(timeout: .now() + 10.0)
        switch result {
        case .success:
            print("不超时, 上面的两个任务都执行完")
        case .timedOut:
            print("超时了, 上面的任务还没执行完执行这了")
        }
        
        print("接下来的操作")
 
 */
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

