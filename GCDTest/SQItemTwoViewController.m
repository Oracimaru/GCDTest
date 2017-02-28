//
//  SQItemTwoViewController.m
//  GCDTest
//
//  Created by zhanghaibin on 17/2/27.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQItemTwoViewController.h"

@interface SQItemTwoViewController ()

@end

@implementation SQItemTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    
//    [self dispatch_barrier_async];
    [self aaa];
}

#pragma mark - 系统代理

#pragma mark - 点击事件

#pragma mark - 网络请求
- (void)sendNetWorking {
    
}

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"dispatch_barrier_async";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)aaa
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"11");
    [AFNet getJsonWithURL:testUrl success:^(id JSON) {
        NSLog(@"dispatch_async1 block回调");
        
    } failure:^(NSError *error) {
        
    }];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"22");

    [AFNet getJsonWithURL:testUrl success:^(id JSON) {
        NSLog(@"dispatch_async2 block回调");
        
    } failure:^(NSError *error) {
        
    }];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"33");

    [AFNet getJsonWithURL:testUrl success:^(id JSON) {
        NSLog(@"dispatch_async3 block回调");
        
    } failure:^(NSError *error) {
        
    }];
    });


}
// dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行
//完全按照dispatch_async1,2,barrier_async,3执行
- (void)dispatch_barrier_async {
    
    dispatch_queue_t queue = dispatch_queue_create("customIdenrifier", NULL);
    
    dispatch_sync(queue, ^{
        NSLog(@"dispatch_async1");
        [AFNet getJsonWithURL:testUrl success:^(id JSON) {
            NSLog(@"dispatch_async1 block回调");
            
        } failure:^(NSError *error) {
            
        }];
    });
    
    
    dispatch_sync(queue, ^{
        NSLog(@"dispatch_async2");
        [AFNet getJsonWithURL:testUrl success:^(id JSON) {
            NSLog(@"dispatch_async2 block回调");
            
        } failure:^(NSError *error) {
            
        }];
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"dispatch_barrier_async");
        [AFNet getJsonWithURL:testUrl success:^(id JSON) {
            NSLog(@"dispatch_barrier_async block回调");
            
        } failure:^(NSError *error) {
            
        }];
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"dispatch_async3");
        [AFNet getJsonWithURL:testUrl success:^(id JSON) {
            NSLog(@"dispatch_async3 block回调");
            
        } failure:^(NSError *error) {
            
        }];
    });
    
}


@end
