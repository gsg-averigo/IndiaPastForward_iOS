//
//  ArticlesViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "ArticlesViewController.h"
#import "RootViewController.h"
#import "TabsViewController.h"
#import "MapViewController.h"
#import "Article.h"
#import "Request.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "TabsViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#import "Reachability.h"

@interface ArticlesViewController ()

@end

@implementation ArticlesViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)init{
    
    
    if (IPAD)
    {
        self = [super initWithNibName:@"ArticlesViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"ArticlesViewController" bundle:nil];
    }
    
    //self = [super initWithNibName:@"ArticlesViewController" bundle:nil];
    if(self){
        
    }
    return self;
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self connected])
    {
        if([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }

    else
    {
        NSLog(@"This View is not Working ");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Internet acess" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.articles.count !=0) {
//        return self.articles.count;
//    }
//    else if (self.articles.count !=0)
//    {
//    }
    //return self.tabsViewController.articles.count;
    NSLog(@"the artical Count %lu", (unsigned long)self.articles.count);
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.imageView.image = [UIImage imageNamed:@"wp_list_icon"];
    }
    
    Article *article = [self.articles objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"wp_list_icon"];
//    if(article.mediaFileType == W)
//    {
//        cell.imageView.image = [UIImage imageNamed:@"wp_list_icon"];
//    }
    
    cell.textLabel.text = article.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self connected])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Scanner"];

        //    Article *article = [self.articles objectAtIndex:indexPath.row];
        //    [[UIApplication sharedApplication] openURL:article.url];
        Article *article = [self.articles objectAtIndex:indexPath.row];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_BROWSE];
        [detailViewController setDetailObject:article];
        // [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:NO];
    }
    else
    {
        NSLog(@"NO Internet Access");
    }

}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (IPAD) {
//        return 100;
//    }
//    else
//    {
//         return 64;
//        
//    }
//  
//    
//    }

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Set the background color of our header/footer.
    header.contentView.backgroundColor = [UIColor whiteColor];
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


@end
