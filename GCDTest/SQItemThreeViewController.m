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
@property (nonatomic, strong) NSArray * urlArray;

@end

@implementation SQItemThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"控制并发数";
    _urlArray = @[ @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488279705944&di=41b236699b506cbc827d228c396e37ff&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fc%2F50b4813b427e7.jpg",
        @"https://gd2.alicdn.com/imgextra/i1/0/TB1p6QnOFXXXXbFXFXXXXXXXXXX_!!0-item_pic.jpg",
        @"https://gss0.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=d6b8bd09abd3fd1f365caa3c007e0927/b3b7d0a20cf431ad9fdc6d1e4836acaf2edd988e.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488279920788&di=76b47189c492dca21caa286ac594c7fa&imgtype=0&src=http%3A%2F%2Fimage.tianjimedia.com%2FuploadImages%2F2013%2F259%2FDL4HC7PK25S4.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488279920788&di=517d6ffe01db25ddee5ffdd688ac565a&imgtype=0&src=http%3A%2F%2F5.26923.com%2Fdownload%2Fpic%2F000%2F329%2F63f6c1808fcd7f55e1e7d47d1172f418.jpg",
        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488279920788&di=0aaeefacb39c2b98e6e45bfe7b017a8b&imgtype=0&src=http%3A%2F%2Fwww.kenphoto.com%2Fdesktop%2F2013-l-12a.jpg" ];
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
    [self loadImage:imageview row:indexPath.row];
    
    return cell;
}
- (void)loadImage:(UIImageView*)imageView row:(NSInteger)row
{
    //     semaphore = dispatch_semaphore_create(2);
    //    [NSThread sleepForTimeInterval:1];
    NSLog(@"开始请求-----%ld",row);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW);
        dispatch_async(queue, ^{
            NSURL* url = [NSURL URLWithString:_urlArray[row % 6]];
            
            NSData* data = [[NSData alloc] initWithContentsOfURL:url];
            UIImage* image = [[UIImage alloc] initWithData:data];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                    dispatch_semaphore_signal(self.semaphore);
                    NSLog(@"下载完成-----%ld",row);
                });
            }
        });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        self.semaphore = dispatch_semaphore_create(3);
    }
    return _semaphore;
}

@end
