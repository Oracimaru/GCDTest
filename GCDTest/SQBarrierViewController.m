//
//  SQItemTwoViewController.m
//  GCDTest
//
//  Created by zhanghaibin on 17/2/27.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQBarrierViewController.h"

@interface SQBarrierViewController ()

@end

@implementation SQBarrierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self basicSetting];
    
    
    [self dispatch_barrier_async];
    [self dispatch_barrier_async2];
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

// dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行
//完全按照dispatch_async1,2,barrier_async,3执行
//dispatch_sync会卡界面
- (void)dispatch_barrier_async {
    
    dispatch_queue_t queue = dispatch_queue_create("customIdenrifier", NULL);
    
    dispatch_async(queue, ^{
        NSLog(@"dispatch_async1");
        NSString*responseString  =  [AFNet getJsonWithURL:nil];
        NSLog(@"[  ---%@",responseString);

    });
    
    
    dispatch_async(queue, ^{
        NSLog(@"dispatch_async2");
        NSString*responseString  =  [AFNet getJsonWithURL:nil];
        NSLog(@"dispatch_async2  ---%@",responseString);

      
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier_async");
        NSString*responseString  =  [AFNet getJsonWithURL:nil];
        NSLog(@"dispatch_barrier_async  ---%@",responseString);

         });
    
    dispatch_async(queue, ^{
        NSLog(@"dispatch_async3");
        NSString*responseString  =  [AFNet getJsonWithURL:nil];
        NSLog(@"dispatch_async3  ---%@",responseString);

    });
    
}
- (void)dispatch_barrier_async2
{
    //生成 Serial Dispatch Queue (如main线程)时，像该源代码这样，将第二个参数指定为NULL。生成 Concurrent Dispatch Queue 时，指定为 DISPATCH_QUEUE_CONCURRENT
    //读取处理只是与读取处理并行执行,写入处理单独,不能与写入或者读取处理并行执行
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:@"1"];
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.ForBarrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSString* value in array) {
            NSLog(@"array---%@", value);
        }
        
    });
    
    dispatch_async(queue, ^{
        for (NSString* value in array) {
            NSLog(@"array---%@", value);
        }
        
    });
    dispatch_barrier_async(queue, ^{
        for (int i = 2; i < 4; i++) {
            [array addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
    });
    
    dispatch_async(queue, ^{
        for (NSString* value in array) {
            NSLog(@"array---%@", value);
        }
        
    });
}

@end
