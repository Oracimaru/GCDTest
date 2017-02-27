//
//  SQitemOneViewController.m
//  GCDTest
//
//  Created by zhanghaibin on 17/2/27.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQItemOneViewController.h"

@interface SQItemOneViewController ()

@end

@implementation SQItemOneViewController

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    
    [self initUI];
    
    [self dispatch_group_async];
}

#pragma mark - 系统代理

#pragma mark - 点击事件

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"dispatch_group_async";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI布局
- (void)initUI {
    
    
}

- (void)dispatch_group_async {
    
    /**
     dispatch_group_async可以实现监听一组任务是否完成，完成后得到通知执行其他的操作。这个方法很有用，比如你执行三个下载任务，当三个任务都下载完成后你才通知界面说完成的了。下面是一段例子代码
     */
    
    //1. 获取一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2. 创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"group1");
        
        // 你的网络请求代码
        [AFNet getJsonWithURL:testUrl  success:^(id JSON) {
            NSLog(@"group1 block回调");
        } failure:^(NSError *error) {
            
        }];
    });
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"group2");
        
        // 你的网络请求代码
        [AFNet getJsonWithURL:testUrl success:^(id JSON) {
            NSLog(@"group2 block回调");
  
        } failure:^(NSError *error) {
            
        }];
    });
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"group3");
        
        // 你的网络请求代码
        [AFNet getJsonWithURL:@""  success:^(id JSON) {
            NSLog(@"group3 block回调");
        } failure:^(NSError *error) {
            NSLog(@"group3 block失败回调");

        }];

    });
    
    
    // 回到主队列中,刷新UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"1,2,3请求完成回调");
    });
    
    /** 非ARC下销毁group对象
     dispatch_release(group);
     */
}

@end
