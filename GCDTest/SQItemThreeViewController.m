//
//  SQItemThreeViewController.m
//  GCDTest
//
//  Created by zhanghaibin on 17/2/27.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "SQItemThreeViewController.h"

@interface SQItemThreeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation SQItemThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"控制并发数";
    
    [self addTableView];
    
    [self createData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idetifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
       
       UIImageView* imageview = ({
            UIImageView * imgView = [[UIImageView alloc]init];
           imgView.tag = indexPath.row + 100;
           imgView.image = [UIImage imageNamed:@"videoBackImage"];
            [cell.contentView addSubview:imgView];
            imgView;
        });
        [ imageview   mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@150);
            make.center.equalTo(cell.contentView);
        }];
    }
    UIImageView* imageview = (UIImageView*)[cell.contentView viewWithTag:indexPath.row + 100];
    [self loadImage:imageview];
    
    return cell;
}
- (void)loadImage:(UIImageView*)imageView
{
//     semaphore = dispatch_semaphore_create(2);
//    [NSThread sleepForTimeInterval:1];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW);
    dispatch_async(queue, ^{
        NSURL * url = [NSURL URLWithString:@"https://gd2.alicdn.com/imgextra/i1/0/TB1p6QnOFXXXXbFXFXXXXXXXXXX_!!0-item_pic.jpg"];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                dispatch_semaphore_signal(self.semaphore);
                NSLog(@"下载完成一个,恢复下载");
            });
            [NSThread sleepForTimeInterval:2];

        }
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addTableView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)createData
{
    
    [self.tableView reloadData];
}

#pragma mark - setter & getter

- (UITableView *)tableView
{
    if (!_tableView)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.rowHeight = 150;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}
- (dispatch_semaphore_t)semaphore
{
    if (!_semaphore) {
        self.semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

@end
