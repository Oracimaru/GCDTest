//
//  SQSyncViewController.m
//  GCDTest
//
//  Created by zhanghaibin on 17/3/6.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQSyncViewController.h"

@interface SQSyncViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArrayM;

@end

@implementation SQSyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self createData];

    [self basicSetting];
    
}

#pragma mark - 系统代理

#pragma mark - 实现方法
#pragma mark 基本设置
- (void)basicSetting {
    self.title = @"dispatch_barrier_async";
    self.view.backgroundColor = [UIColor whiteColor];
}
/*
 
 dispatch_async与dispatch_sync主要用于提交Job（作业，就是干活），也就是说当我们想向一个队列提交Job时，只要调用这个函数，
 传入一个队列和一个block就OK了。但他们也有很大区别，从名字上看就可以看出前者是异步的，后者是同步的，也就是说dispatch_async 
 函数在调用后会立即返回, block会在后台异步执行；而dispatch_sync会等待block中的代码执行完成才返回。  就是当你在方法中
 使用同步分配时，GCD就会把这个task放到你声明的这个方法所属的线程中去运行。即sync所属线程为声明的方法所属线程.
 */
- (void)dispatch_async
{
    
    [self getCurrentQueue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self getCurrentQueue];
    });
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_sync(queue, ^{
          NSString* responString = [AFNet getJsonWithURL:nil];
            NSLog(@"responString=%@",responString);

            [AFNet getJsonWithURL:testUrl success:^(id JSON) {
            } failure:nil];
        });
        dispatch_sync(queue, ^{
            for (int i = 100; i<200; i++) {
                NSLog(@"%d",i);
            }
        });
        for (int i = 300; i<400; i++) {
            NSLog(@"i===%d",i);
        }
    });
    
}
//同步向并行队列派发任务
- (void)dispatch_sync
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<3; i++) {
        NSLog(@"进入队列:%ld", i);
        dispatch_sync(queue, ^{
            sleep(1);
            NSLog(@"执行任务:%ld", i);
        });
    }
    });

}
//同步向串行队列派发任务
- (void)dispatch_sync2
{
    dispatch_queue_t queue = dispatch_queue_create("com.test.queue", DISPATCH_QUEUE_SERIAL);
    //dispatch_async(queue, ^{//死锁
    for (NSInteger i = 0; i<3; i++) {
        NSLog(@"进入队列:%ld", i);
        dispatch_sync(queue, ^{
            sleep(1);
            NSLog(@"执行任务:%ld", i);
        });
    }
    //});
}
//异步向串行队列派发任务
- (void)dispatch_sync3
{
    dispatch_queue_t queue = dispatch_queue_create("com.test.queue.concurrent", DISPATCH_QUEUE_SERIAL);
    for (NSInteger i = 0; i<3; i++) {
        NSLog(@"进入队列:%ld", i);
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"执行任务:%ld", i);
        });
    }
}
//异步向并行队列派发任务
- (void)dispatch_sync4
{
    dispatch_queue_t queue = dispatch_queue_create("com.test.queue.concurrent.2", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i = 0; i<3; i++) {
        NSLog(@"进入队列:%ld", i);
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"执行任务:%ld", i);
        });
    }
}
/*
 串行队列：队列中可以有很多任务，但是只能向一个线程一个接一个的派发的任务（一个线程一次只能执行一个任务）Serial Diapatch Queue
 并行队列：相比串行队列的一个线程，并行队列可以同时给多个线程派发任务，至于同时有多少个线程取决于当前系统的状态Concurrent Dispatch Queue

 dispatch_async 非同步向队列中添加任务,该函数直接返回.
 dispatch_sync 同步向队列中添加任务，如果上一个任务没有完成，那就一直等待.该函数会等待block中的代码执行完成才返回

 导致死锁的原因一定是：
 在某一个串行队列中，同步的向这个队列添加block。
 原因:在串行队列中,同步方法block执行完之前都不会返回,不返回就阻塞了主线程.异步方法是直接返回的.同步则block当前串行队列不执行,别的队列无权执行.
 解释2:串行派发任务是完成一个任务再从队列中取，输出的顺序是1 3 2,按照同步操作输出的顺序是1 2 3.只有输出1时不矛盾，然后就矛盾执行不了了.
 
 */
- (void)死锁
{
    dispatch_queue_t queue = dispatch_queue_create("com.mtry.demo.test", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"1");
        dispatch_sync(queue, ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
 
}
- (void)getCurrentQueue
{
    NSLog(@"当前线程 %@",dispatch_get_current_queue());

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idetifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
    }
    
    cell.textLabel.text = self.dataArrayM[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self dispatch_async];
    } else if (indexPath.row == 1) {
        [self dispatch_sync];
    } else if (indexPath.row == 2) {
        [self dispatch_sync2];
    } else if (indexPath.row == 3) {
        [self dispatch_sync3];
    }
    else if (indexPath.row == 4){
        [self dispatch_sync4];
    }
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.rowHeight = 50;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}
- (void)addTableView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (NSMutableArray *)dataArrayM
{
    if (!_dataArrayM)
    {
        self.dataArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArrayM;
}

- (void)createData
{
    NSArray * array = @[@"异步",@"同步向并行队列派发任务",@"同步向串行队列派发任务",@"异步向串行队列派发任务",@"异步向并行队列派发任务"];
    
    self.dataArrayM = [NSMutableArray arrayWithArray:array];
    
    [self.tableView reloadData];
}

@end
