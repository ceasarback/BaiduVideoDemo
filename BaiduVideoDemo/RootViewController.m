//
//  RootViewController.m
//  BaiduVideoDemo
//
//  Created by Ceasarback on 14-1-3.
//  Copyright (c) 2014年 _CompanyName_. All rights reserved.
//

#import "RootViewController.h"
#import "VideoCell1.h"
#import "VideoCell2.h"
#import "SectionView.h"
#import "ScrollView.h"
#import "DPHTTPRequest.h"
#import "Model.h"
#import "UIImageView+WebImage.h"
#import "DetailViewController.h"


#define kVideoList @"http://app.video.baidu.com/iphnativeindex/?version=2.9.0"

@interface RootViewController ()

@property (retain, nonatomic) IBOutlet  UITableView *tableView;
@property (nonatomic, retain)           ScrollView*scrollView;

@property (nonatomic, retain)           NSMutableArray  *amuseData;
@property (nonatomic, retain)           NSMutableArray  *childComicData;
@property (nonatomic, retain)           NSMutableArray  *indexFlashData;
@property (nonatomic, retain)           NSMutableArray  *comicData;
@property (nonatomic, retain)           NSMutableArray  *infoData;

@property (nonatomic, retain)           NSMutableArray  *sectionArray;
@property (nonatomic, retain)           NSMutableArray  *sectionTitle;

@property (nonatomic, retain)           UILabel         *label;
@property (nonatomic, retain)           UIPageControl   *pageContorl;

@end

@implementation RootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)downloadFinished:(DPHTTPRequest *)request
{
    NSDictionary *dict = [NSJSONSerialization  JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *data in [dict objectForKey:@"amuse_hot"])
    {
        Model *m = [[Model alloc] initWithData:data];
        [self.amuseData addObject:m];
        [m release];
    }
    
    for (NSDictionary *data in [dict objectForKey:@"child_comic_hot"])
    {
        Model *m = [[Model alloc] initWithData:data];
        [self.childComicData addObject:m];
        [m release];
    }
    
    for (NSDictionary *data in [dict objectForKey:@"comic_hot"])
    {
        Model *m = [[Model alloc] initWithData:data];
        [self.comicData addObject:m];
        [m release];
    }
    
    for (NSDictionary *data in [dict objectForKey:@"index_flash"])
    {
        Model *m = [[Model alloc] initWithData:data];
        [self.indexFlashData addObject:m];
        [m release];
    }
    
    for (NSDictionary *data in [dict objectForKey:@"info_hot"])
    {
        Model *m = [[Model alloc] initWithData:data];
        [self.infoData addObject:m];
        [m release];
    }
    
    [_tableView reloadData];
    [self loadScrollViewData];
}

- (void)loadScrollViewData
{
    int i = 0;
    for (Model *m in _indexFlashData)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 150)];
        [imageView setImageWithURLString:m.img_url];
        [_scrollView addSubview:imageView];
        [imageView release];
        i++;
    }
    
    _scrollView.contentSize = CGSizeMake(i*320, 150);
}

- (void)downloadFailed:(DPHTTPRequest *)request
{
    NSLog(@"%@", request.responseError);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView = [[[NSBundle mainBundle] loadNibNamed:@"ScrollView" owner:self options:nil] lastObject];
    _scrollView.frame = CGRectMake(0, 0, 320, 150);
    _scrollView.backgroundColor = [UIColor blueColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _tableView.tableHeaderView = _scrollView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"VideoCell1" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"VideoCell2" bundle:nil] forCellReuseIdentifier:@"cell2"];
//    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.childComicData = nil;
    self.indexFlashData = nil;
    self.amuseData = nil;
    self.comicData = nil;
    self.infoData = nil;
    
    _amuseData = [[NSMutableArray alloc] initWithCapacity:0];
    _indexFlashData = [[NSMutableArray alloc] initWithCapacity:0];
    _childComicData = [[NSMutableArray alloc] initWithCapacity:0];
    _comicData = [[NSMutableArray alloc] initWithCapacity:0];
    _infoData = [[NSMutableArray alloc] initWithCapacity:0];
    
    _sectionArray = [[NSMutableArray alloc] initWithObjects:_amuseData, _childComicData, _comicData, _infoData, nil];
    _sectionTitle = [[NSMutableArray alloc] initWithObjects:@"娱乐", @"动画片", @"动漫", @"资讯", nil];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 81, 150, 21)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"lalala";
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor whiteColor];
    [self.view addSubview:_label];
    
    _pageContorl = [[UIPageControl alloc] initWithFrame:CGRectMake(220, 76, 100, 21)];
    _pageContorl.numberOfPages = 5;
    [self.view addSubview:_pageContorl];
    
    DPHTTPRequest *request = [DPHTTPRequest requestWithURLString:kVideoList andDelegate:self];
    request.didFailedSeletor = @selector(downloadFailed:);
    request.didFinishedSeletor = @selector(downloadFinished:);
    [request sendWithAsync];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapHandel:(UITapGestureRecognizer *)tap
{
    NSInteger section = tap.view.tag / 100;
    NSInteger index = tap.view.tag % 100;
    
    Model *m = [[_sectionArray objectAtIndex:section] objectAtIndex:index];
    
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.m = m;
    [self.navigationController pushViewController:dvc animated:YES];
    [dvc release];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<2)
        return [[_sectionArray objectAtIndex:section] count]/2;
    
    return [[_sectionArray objectAtIndex:section] count]/3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<2)
    {
        return 190;
    }
    else
    {
        return 225;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionView *sv = [[[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:self options:nil] lastObject];
    sv.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1.0f];
    sv.type.text = [_sectionTitle objectAtIndex:section];
    sv.moreInfo.text = @"更多";
    return sv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 2)
    {
        NSInteger index1 = indexPath.row * 2;
        NSInteger index2 = index1+1;
        Model *m1 = [[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:index1];
        Model *m2 = [[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:index2];
        
        VideoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell.v1 setImageWithURLString:m1.img_url];
        cell.v1.tag = indexPath.section*100+index1;
        [cell.v2 setImageWithURLString:m2.img_url];
        cell.v2.tag = indexPath.section*100+index2;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandel:)];
        [cell.v1 addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandel:)];
        [cell.v2 addGestureRecognizer:tap2];
        
        cell.t1.text = m1.title;
        cell.t2.text = m2.title;
        
        cell.m1.text = m1.duration;
        cell.m2.text = m2.duration;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSInteger index1 = indexPath.row * 3;
        NSInteger index2 = index1+1;
        NSInteger index3 = index2+1;
        Model *m1 = [[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:index1];
        Model *m2 = [[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:index2];
        Model *m3 = [[_sectionArray objectAtIndex:indexPath.section] objectAtIndex:index3];
        
        VideoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell.v1 setImageWithURLString:m1.img_url];
        cell.v1.tag = indexPath.section*100+index1;
        [cell.v2 setImageWithURLString:m2.img_url];
        cell.v2.tag = indexPath.section*100+index2;
        [cell.v3 setImageWithURLString:m3.img_url];
        cell.v3.tag = indexPath.section*100+index3;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandel:)];
        [cell.v1 addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandel:)];
        [cell.v2 addGestureRecognizer:tap2];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandel:)];
        [cell.v3 addGestureRecognizer:tap3];
        
        cell.t1.text = m1.title;
        cell.t2.text = m2.title;
        cell.t3.text = m3.title;
        
        cell.st1.text = m1.brief;
        cell.st2.text = m2.brief;
        cell.st3.text = m3.brief;
        
        cell.m1.text = m1.duration;
        cell.m2.text = m2.duration;
        cell.m3.text = m3.duration;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / 320;
    _pageContorl.currentPage = index;
    Model *m = [_indexFlashData objectAtIndex:index];
    _label.text = m.title;
}


- (void)dealloc {
    [_tableView release];
    
    self.scrollView = nil;
    self.childComicData = nil;
    self.indexFlashData = nil;
    self.amuseData = nil;
    self.comicData = nil;
    self.infoData = nil;
    self.sectionArray = nil;
    self.pageContorl = nil;
    self.label = nil;
    
    [super dealloc];
}
@end
