//
//  TweetsViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 01/09/15.
//  Copyright (c) 2015 Harish. All rights reserved.
//

#import "TweetsViewController.h"
#import "RootViewController.h"
#import "TabsViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import "Request.h"
#import "AlertView.h"
#import "NSObject+Parser.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "TabsViewController.h"
#import "TwitteriPadTableViewCell.h"
#import "TwitteriPhoneTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"

@interface TweetsViewController ()

@end

@implementation TweetsViewController

- (id)init{
    
    
    if (IPAD)
    {
        self = [super initWithNibName:@"TweetsViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"TweetsViewController" bundle:nil];
    }
    
    //self = [super initWithNibName:@"ArticlesViewController" bundle:nil];
    if(self){
        
    }
    return self;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self connected])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Internet acess" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if (IPAD)
        {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 600, 0);
        }
        UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
        
        refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.tintColor = [UIColor redColor];
        //[refreshControl addTarget:self action:@selector(requestResponse) forControlEvents:UIControlEventValueChanged];
        NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
        [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, refreshString.length)];
        refreshControl.attributedTitle = refreshString;
        [refreshView addSubview:refreshControl];
        
        //  [self.view addSubview:self.tableView];
        
        
        
        [Request makeRequestWithIdentifier:TWEETS_DATA parameters:nil delegate:self];
        [AlertView showProgress];
        double delayInSeconds = 25.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [AlertView hideAlert];
        });

    }
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y < -110 && ![refreshControl isRefreshing]) {
//        [refreshControl beginRefreshing];
//        //your code for refresh
//        [refreshControl endRefreshing];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
//                             CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:
//                UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//    }
    
    if (IPAD) {
        
        
        TwitteriPadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        
        
        [tableView registerNib:[UINib nibWithNibName:@"TwitteriPadTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        
        cell.twImages.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.DesLabel.textColor = [UIColor grayColor];

       
            [cell.DesLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.nameLabel setFont:[UIFont boldSystemFontOfSize:20]];

     
       
        
     
        
       
        NSDictionary *tempDictionary= [self.tweets objectAtIndex:indexPath.row];
        self.statusArray=[tempDictionary objectForKey:@"Status"];
        cell.nameLabel.text=[self.statusArray[0] valueForKey:@"name"];
        cell.DesLabel.numberOfLines = 3;
        cell.DesLabel.text=[self.statusArray[0] valueForKey:@"text"];
        //    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.statusArray[0] valueForKey:@"image"]]]];
        NSString *image1 = [NSString stringWithFormat:@"%@", [self.statusArray[0] valueForKey:@"image"]];
       
        
        [cell.twImages setImageWithURL:[NSURL URLWithString:image1] placeholderImage:[UIImage imageNamed:@"thumb_stub.png"] options:SDWebImageRefreshCached];
        
    [AlertView hideAlert];
    return cell;
    }
    else
    {
        
        TwitteriPhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCellss"];
        
        
        [tableView registerNib:[UINib nibWithNibName:@"TwitteriPhoneTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCellss"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCellss"];
        
        [cell.DesLabel setFont:[UIFont systemFontOfSize:11]];
        cell.DesLabel.textColor = [UIColor grayColor];
        [cell.nameLabel setFont:[UIFont boldSystemFontOfSize:15]];
        
        NSDictionary *tempDictionary= [self.tweets objectAtIndex:indexPath.row];
        self.statusArray=[tempDictionary objectForKey:@"Status"];
        cell.nameLabel.text=[self.statusArray[0] valueForKey:@"name"];
        cell.DesLabel.numberOfLines = 3;
        cell.DesLabel.text=[self.statusArray[0] valueForKey:@"text"];
        //    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.statusArray[0] valueForKey:@"image"]]]];
        NSString *image1 = [NSString stringWithFormat:@"%@", [self.statusArray[0] valueForKey:@"image"]];
        cell.twImages.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell.twImages setImageWithURL:[NSURL URLWithString:image1] placeholderImage:[UIImage imageNamed:@"thumb_stub.png"] options:SDWebImageRefreshCached];
[AlertView hideAlert];
         return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IPAD) {
        return 88;
    }
    else
    {
        return 75;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempDictionary= [self.tweets objectAtIndex:indexPath.row];
    self.statusArray=[tempDictionary objectForKey:@"Status"];
    NSString *StatusUrl=[self.statusArray[0] valueForKey:@"url"];
    if([StatusUrl isEqualToString:@" "])
    {
        //[AlertView showAlertMessage:@"Link Not Found!!"];
    }
    else
    {
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_TWEET];
        [detailViewController setDetailObject:[self.statusArray[0] valueForKey:@"url"]];
        [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:YES];
    }
}
#pragma mark -

- (void)connection:(Connection *)connection didReceiveData:(id)data{
    [AlertView hideAlert];
    if([data isKindOfClass:[NSString class]])
    {
        data = [data jsonValue];
    }
    
    if(connection.connectionIdentifier == TWEETS_DATA)
    {
        self.tweets=[data objectForKey:@"Tweets"];
        
       
        [self.tableView reloadData];
        [AlertView hideAlert];
        [refreshControl endRefreshing];
    }
}


- (void)connection:(Connection *)connection didFailWithError:(NSError *)error{
    [AlertView hideAlert];
}
-(void)requestResponse
{
    
    [Request makeRequestWithIdentifier:TWEETS_DATA parameters:nil delegate:self];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -110 && ![refreshControl isRefreshing]) {
        [refreshControl beginRefreshing];
        [self requestResponse];
        
        
    }}



@end
