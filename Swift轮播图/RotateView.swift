//
//  RotateView.swift
//  Swift轮播图
//
//  Created by 李见辉 on 16/4/4.
//  Copyright © 2016年 李见辉. All rights reserved.
//

import UIKit

//点击图片处理的代理
@objc protocol RotateViewDelegate {
    optional func clickCurrentImage(currentIndex: Int)
}

class RotateView: UIView {
    
    var currentIndex = Int()
    
    var delegate : RotateViewDelegate?
    
    private var timer : NSTimer!
    private var index = Int()//当前数组里对应的元素下标
    private var showImageView = UIImageView()//当前显示的图片
    private var pageControl = UIPageControl()
    
    //需要轮播的图片数组
    var imageArray:[AnyObject!]!{
        //监听数组的变化
        willSet(newValue) {
            self.imageArray = newValue
        }
        didSet {
            setImageView()
            setPageControl()
            //添加定时器
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.transitionIsRight(_:)), userInfo: nil, repeats: true)
        }
    }
    //设置imageView
    func setImageView() {
        index = 0
        showImageView.frame = self.bounds;
        showImageView.userInteractionEnabled = true
        self.addSubview(showImageView)
        if self.imageArray.count > 0 {
            loadImageWithIndex(0)
        }
        //左滑手势
        let liftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(self.liftSwipeAction(_:)))
        liftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        //右滑手势
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(self.rightSwipeAction(_:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        //点击手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapSwipeAction(_:)))
        //添加手势
        showImageView.addGestureRecognizer(liftSwipe)
        showImageView.addGestureRecognizer(rightSwipe)
        showImageView.addGestureRecognizer(tap)
    }
    //添加pageControl
    func setPageControl() {
        //添加一个pageControl
        pageControl.frame = CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40)
        pageControl.backgroundColor = UIColor.lightTextColor()
        pageControl.numberOfPages = imageArray.count
        pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        showImageView.addSubview(pageControl)
        self.bringSubviewToFront(pageControl)
        pageControl.userInteractionEnabled = false
    }
    //加载图片
    func loadImageWithIndex(index: Int) {
        if imageArray[index].isKindOfClass(UIImage) {
            showImageView.image = imageArray[index] as? UIImage
        }
        if imageArray[index].isKindOfClass(NSString) {
            showImageView.sd_setImageWithURL(NSURL.init(string: (imageArray[index] as? String)!), placeholderImage: UIImage.init(named: "carousel_default.jpg"))
        }
    }
    //左滑手势
    func liftSwipeAction(sender:UISwipeGestureRecognizer) {
        transitionIsRight(false)
        timer.invalidate()
        timer = nil
        if sender.state == UIGestureRecognizerState.Ended {
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.transitionIsRight(_:)), userInfo: nil, repeats: true)
        }
    }
    //右滑手势
    func rightSwipeAction(sender:UISwipeGestureRecognizer) {
        transitionIsRight(true)
        timer.invalidate()
        timer = nil
        if sender.state == UIGestureRecognizerState.Ended {
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.transitionIsRight(_:)), userInfo: nil, repeats: true)
        }
    }
    //设置滑动动画
    func transitionIsRight(isRight:Bool) {
        //创建动画
        let transition = CATransition()
        transition.type = "cube"
        if !isRight {//左滑
            index += 1
            transition.subtype = kCATransitionFromRight
        }else{
            if index == 0 {
                index = imageArray.count - 1
            }else{
                self.index -= 1
            }
            transition.subtype = kCATransitionFromLeft
        }
        transition.duration = 0.7;
        let currentIndex = index % self.imageArray.count
        loadImageWithIndex(currentIndex)//设置动画后的新图
        showImageView.layer .addAnimation(transition, forKey: "animation")//开启动画
        self.currentIndex = currentIndex
        self.pageControl.currentPage = currentIndex
    }
    //点击图片响应
    func tapSwipeAction(sender:UITapGestureRecognizer) {
        self.delegate?.clickCurrentImage!(currentIndex)
    }

   
    
    deinit {
        timer.invalidate()
        timer = nil
    }

}
