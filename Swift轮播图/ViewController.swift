//
//  ViewController.swift
//  Swift轮播图
//
//  Created by 李见辉 on 16/4/4.
//  Copyright © 2016年 李见辉. All rights reserved.
//

import UIKit

class ViewController: UIViewController,RotateViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCALE_WIDTH = UIScreen.mainScreen().bounds.size.width/376
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var rotateView: RotateView!
    @IBOutlet weak var serveView: UIView!
    
    //-------tableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    //---------viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        setHeaderView()
    }
    //-----------RotateView
    func setHeaderView() {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 390*SCALE_WIDTH)
        rotateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260*SCALE_WIDTH)
        rotateView.imageArray = [UIImage.init(named: "1.jpg"), UIImage.init(named: "2.jpg"), UIImage.init(named: "4.jpg")]
        rotateView.delegate = self
        headerView.addSubview(rotateView)
        setServeViewToView(headerView)
        tableView.tableHeaderView = headerView
    }
    //点击图片响应
    func clickCurrentImage(currentIndex: Int) {
        print(currentIndex)
    }
    //委托找房，投放房源，秒租礼包，秒赚佣金
    func setServeViewToView(toView:UIView) {
//        view.addSubview(getBuitton())
        toView.addSubview(serveView)
    }
    
    //--------tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BoutiqueCell", forIndexPath: indexPath) as? BoutiqueCell
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260*SCALE_WIDTH
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

