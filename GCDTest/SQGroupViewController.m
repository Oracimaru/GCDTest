//
//  SQitemOneViewController.m
//  GCDTest
//
//  Created by zhanghaibin on 17/2/27.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQGroupViewController.h"

@interface SQGroupViewController (){
    NSInteger ticketCount;
}

@end

@implementation SQGroupViewController

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    ticketCount = 10;
    [self basicSetting];
    
    
    [self initUI];
    
    [self dispatch_group_async];
    [self dispatch_apply];
    [self 卖票];
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
- (void)卖票
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    
    dispatch_after(popTime, queue, ^{
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, ^{
            [self gcdSaleTicketWithName:@"gcd-1"];
        });
        dispatch_group_async(group, queue, ^{
            [self gcdSaleTicketWithName:@"gcd-2"];
        });
        dispatch_group_notify(group, queue, ^{
            NSLog(@"卖完了");
        });
    });
}
- (void)gcdSaleTicketWithName:(NSString *)name
{
    while (YES) {
        //同步锁要锁的范围,对被抢夺资源修改/读取的代码部分
        @synchronized (self) {
            if (ticketCount>0) {
                ticketCount--;
                NSString * log = [NSString stringWithFormat:@"剩余票数 %ld,线程名称 %@",ticketCount,name];
                NSLog(@"%@",log);
            }
            else{
                break;
            }
        }
        
        if ([name isEqualToString:@"gcd-1"]) {
            [NSThread sleepForTimeInterval:1];
        }
        else{
            [NSThread sleepForTimeInterval:0.2f];
        }
    }

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
//        [AFNet getJsonWithURL:testUrl  success:^(id JSON) {
//            NSLog(@"group1 block回调");
//        } failure:^(NSError *error) {
//            
//        }];
       NSString*responseString  =  [AFNet getJsonWithURL:nil];
        NSLog(@"grou1  ---%@",responseString);
    });
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"group2");
        
        // 你的网络请求代码
        NSString*responseString  =  [AFNet getJsonWithURL:nil];
        NSLog(@"grou2  ---%@",responseString);
    });
    
    // 在group队列组中队列
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"group3");
        
        // 你的网络请求代码
        NSString*responseString  =  [AFNet getJsonWithURL:nil];
        NSLog(@"grou3  ---%@",responseString);
    });
    
    //dispatch_group_wait用于阻塞等待所有group完成,测试会卡界面
   // dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    NSLog(@"wait--1,2,3请求完成回调");

    // 回到主队列中,刷新UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"1,2,3请求完成回调");
    });
    
}
//10s后在后台线程同步执行请求3次.
- (void)dispatch_apply
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    
    dispatch_after(popTime, queue, ^{
        
        dispatch_async(queue, ^{
            
            dispatch_apply(3, queue, ^(size_t index) {
                
                NSString* responseString = [AFNet getJsonWithURL:nil];
                
                NSLog(@"apply  ---%@", responseString);
                
                NSLog(@"%@", dispatch_get_current_queue());
            });
            NSLog(@"apply--1,2,3请求完成回调");
        });
    });
}
@end
