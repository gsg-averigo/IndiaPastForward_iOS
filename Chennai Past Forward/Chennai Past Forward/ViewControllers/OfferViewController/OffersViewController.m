//
//  OffersViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "OffersViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "TabsViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "OffersTableViewCell.h"
#import "offersiPhoneTableViewCell.h"
#import "Offer.h"
#import "Message.h"
#import "Request.h"
#import "UIImageView+WebCache.h"
#import "AlertView.h"
#import "Categories.h"
#import "NSObject+Parser.h"
#import "Reachability.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface OffersViewController ()

@end

@implementation OffersViewController
@synthesize arrCount, addition;
- (id)init{
    
    if (IPAD) {
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

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![self connected])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Internet acess" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        if([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            
            NSLog(@"the offers is%lu", (unsigned long)self.offers.count);
        }
        arrCount  = [[NSMutableArray alloc]init];
        [self.tableView reloadData];
    //[self.tableView registerClass:[OffersViewController class] forCellReuseIdentifier:@"CellO"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSLog(@"the offers is%lu", (unsigned long)self.offers.count);
    return self.offers.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   

   
    
    if (IPAD) {
        
        OffersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        
        [tableView registerNib:[UINib nibWithNibName:@"OffersTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.descLabel.font = [UIFont systemFontOfSize:16];
        cell.dateLabel.font = [UIFont boldSystemFontOfSize:15];
        
        cell.descLabel.numberOfLines = 3;
        cell.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.descLabel setFont:[UIFont boldSystemFontOfSize:15]];
        cell.offerImages.image = [UIImage imageNamed:@"icon_offer"];
        if([[self.offers objectAtIndex:indexPath.row] isKindOfClass:[Offer class]])
        {
            Offer *offer = [self.offers objectAtIndex:indexPath.row];
            
            cell.offerImages.image = [UIImage imageNamed:@"icon_offer"];
            cell.titleLabel.hidden = YES;
            cell.dateLabel.hidden = YES;
            cell.descLabel.hidden = YES;
            if([offer.count isEqualToString:@"none"])
            {
                
                UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 400, 70)];
                [lbl1 setFont:[UIFont boldSystemFontOfSize:25]];
                [lbl1 setTextColor:[UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1]];
                lbl1.text = @"Coming Soon!!";
                [cell addSubview:lbl1];
                
            }
            else
            {
                
                UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 400, 70)];
                [lbl1 setTextColor:[UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1]];
                [lbl1 setFont:[UIFont boldSystemFontOfSize:25]];
                lbl1.text = offer.title;
                [cell addSubview:lbl1];
                
                
                
            }
        }
        else if([[self.offers objectAtIndex:indexPath.row] isKindOfClass:[Message class]])
        {
            Message *message = [self.offers objectAtIndex:indexPath.row];
            NSString * messagetype = message.messageType;
            
            cell.titleLabel.hidden = NO;
            cell.dateLabel.hidden = NO;
            cell.descLabel.hidden = NO;
            cell.descLabel.textColor = [UIColor grayColor];
            
            
            
            if ([messagetype isEqualToString:@"N"])
            {
                
                cell.offerImages.image = [UIImage imageNamed:@"icon_promo"];
            }
            else
            {
                
                NSString *urlString;
                
                
                
                
                urlString = [ROOT_URL  stringByAppendingPathComponent:@"admin/uploadedFiles"];
                urlString = [urlString stringByAppendingPathComponent:message.messageGUID];
                urlString = [urlString stringByAppendingPathComponent:message.photoString];
                NSLog(@"url string:%@",urlString);
                [cell.offerImages setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"] options:SDWebImageRefreshCached];
                //        NSData *data0 = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                //        UIImage *image = [UIImage imageWithData:data0];
                
                cell.offerImages.contentMode = UIViewContentModeScaleAspectFill;
                cell.offerImages.clipsToBounds = YES;
//                NSURL *url = [NSURL URLWithString:urlString];
//                NSData *data = [NSData dataWithContentsOfURL:url];
//                UIImage *img = [[UIImage alloc] initWithData:data];
//                [cell.offerImages setImage:img];
                
                //            [cell.offerImages setImage:[UIImage imageNamed:@"xl_big_stub.png"]];
                
                
            }
            //        view = cell.contentView;
            //        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 100, 50)];
            //        dateLabel.textColor = [UIColor blackColor];
            //        dateLabel.font =[UIFont boldSystemFontOfSize:15];
            //        [view addSubview:dateLabel];
            //
            //        view = cell.contentView;
            //
            //        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake (98, -15, 768, 50)];
            //        titleLabel.textColor = [UIColor blackColor];
            //        titleLabel.font =[UIFont boldSystemFontOfSize:20];
            //        [view addSubview:titleLabel];
            //        view = cell.contentView;
            
            
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMM dd"];
            
            NSString *dates2 = [format stringForObjectValue:message.date];
            
            
            
            
            cell.dateLabel.text = dates2;
            
            NSString * messagetype1 = message.messageTitle;
            
            
            
            
            cell.titleLabel.text = [NSString stringWithFormat:@"%@", messagetype1];;
            //        NSLog(@"the textlab %@", message.messageDescription);
            
            NSString *stripped = [NSString stringWithFormat:@"%@", message.messageDescription];
            
            
            NSString* myString = [stripped stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
            NSString* myString1 = [myString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
            NSString* myString2 = [myString1 stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@""];
            NSString* myString3 = [myString2 stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            
            NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[myString3 dataUsingEncoding:NSUTF8StringEncoding]
                                                                        options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                  NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                             documentAttributes:nil
                                                                          error:nil];
            NSString *finalString = [attr string];
            
            cell.descLabel.text = finalString;
            
            //        for (int i = 0; i < self.offers.count; i++) {
            //
            //
            //            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (100, 0, 300, 50)];
            //            label1.textColor = [UIColor blackColor];
            //            label1.font =[UIFont boldSystemFontOfSize:20];
            //
            //            label1.tag = (indexPath.row)*100 + i;  //you can create n labels in a row.
            //            label1.text = message.messageTitle;
            //            [cell.contentView addSubview:label1];
            //            
            //               }
            //        
            
            
        }
        return cell;
        
    }
    
    else
    {
        
       offersiPhoneTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"myCellss"];
    
        [tableView registerNib:[UINib nibWithNibName:@"offersiPhoneTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCellss"];
        cell1 = [tableView dequeueReusableCellWithIdentifier:@"myCellss"];
        
        
   
    
        cell1.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        cell1.descLabel.font = [UIFont systemFontOfSize:12];
        cell1.dateLabel.font = [UIFont boldSystemFontOfSize:12];
    
    
    
    cell1.descLabel.numberOfLines = 3;
    cell1.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   // [cell1.descLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    
    
    cell1.offerImages.image = [UIImage imageNamed:@"icon_offer"];
    
    
    
    if([[self.offers objectAtIndex:indexPath.row] isKindOfClass:[Offer class]]){
        Offer *offer = [self.offers objectAtIndex:indexPath.row];
        
        cell1.offerImages.image = [UIImage imageNamed:@"icon_offer"];
        cell1.titleLabel.hidden = YES;
        cell1.dateLabel.hidden = YES;
      cell1.descLabel.hidden = YES;
        if([offer.count isEqualToString:@"none"])
        {
//            cell1.textLabel.text = @"Coming Soon!!";
//            cell1.textLabel.textColor=[UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1];
//            cell1.textLabel.font = [UIFont boldSystemFontOfSize:15];
//  
            //[cell1.descLabel sizeToFit];
            
            
            UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 350, 50)];
            [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
            [lbl1 setTextColor:[UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1]];
            lbl1.text = @"Coming Soon!!";
            lbl1.font = [UIFont boldSystemFontOfSize:15];
            [cell1 addSubview:lbl1];
            
        }
        else
        {
            
            UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 350, 50)];
            [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
            [lbl1 setTextColor:[UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1]];
            lbl1.text = offer.title;
            lbl1.font = [UIFont boldSystemFontOfSize:15];
            [cell1 addSubview:lbl1];
            
//            cell1.textLabel.font = [UIFont boldSystemFontOfSize:15];
//            cell1.textLabel.text = offer.title;
//            [cell1.textLabel sizeToFit];
        }
    }
    else if([[self.offers objectAtIndex:indexPath.row] isKindOfClass:[Message class]]){
        Message *message = [self.offers objectAtIndex:indexPath.row];
        NSString * messagetype = message.messageType;
        
        cell1.titleLabel.hidden = NO;
        cell1.dateLabel.hidden = NO;
         cell1.descLabel.hidden = NO;
        if ([messagetype isEqualToString:@"N"])
        {
            
            cell1.offerImages.image = [UIImage imageNamed:@"icon_promo"];
        }
        else
        {
            NSString *urlString;
            
            
            
            
            urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
            urlString = [urlString stringByAppendingPathComponent:message.messageGUID];
            urlString = [urlString stringByAppendingPathComponent:message.photoString];
            NSLog(@"url string:%@",urlString);
            //        NSData *data0 = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            //        UIImage *image = [UIImage imageWithData:data0];
            
           cell1.offerImages.contentMode = UIViewContentModeScaleAspectFill;
            cell1.offerImages.clipsToBounds = YES;
            
            [cell1.offerImages setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"] options:SDWebImageRefreshCached];
            
           // cell1.offerImages.image = [UIImage imageNamed:@"icon_offer"];
        }
        //        view = cell.contentView;
        //        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 100, 50)];
        //        dateLabel.textColor = [UIColor blackColor];
        //        dateLabel.font =[UIFont boldSystemFontOfSize:15];
        //        [view addSubview:dateLabel];
        //
        //        view = cell.contentView;
        //
        //        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake (98, -15, 768, 50)];
        //        titleLabel.textColor = [UIColor blackColor];
        //        titleLabel.font =[UIFont boldSystemFontOfSize:20];
        //        [view addSubview:titleLabel];
        //        view = cell.contentView;
        
        
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM dd"];
        
        NSString *dates2 = [format stringForObjectValue:message.date];
        
        
        
        
        cell1.dateLabel.text = dates2;
        
        NSString * messagetype1 = message.messageTitle;
        
        
        
        
        cell1.titleLabel.text = [NSString stringWithFormat:@"%@", messagetype1];;
        NSLog(@"the textlab %@", message.messageDescription);
        
        NSString *stripped = [NSString stringWithFormat:@"%@", message.messageDescription];
        
        
        NSString* myString = [stripped stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
        NSString* myString1 = [myString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
        NSString* myString2 = [myString1 stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@""];
        NSString* myString3 = [myString2 stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[myString3 dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                         documentAttributes:nil
                                                                      error:nil];
        NSString *finalString = [attr string];
        cell1.descLabel.textColor = [UIColor grayColor];
        cell1.descLabel.text = finalString;
        
        //        for (int i = 0; i < self.offers.count; i++) {
        //
        //
        //            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (100, 0, 300, 50)];
        //            label1.textColor = [UIColor blackColor];
        //            label1.font =[UIFont boldSystemFontOfSize:20];
        //
        //            label1.tag = (indexPath.row)*100 + i;  //you can create n labels in a row.
        //            label1.text = message.messageTitle;
        //            [cell.contentView addSubview:label1];
        //            
        //               }
        //        
        
        
        
        
        
    }
    return cell1;
}

   
    /*else if([[self.offers objectAtIndex:indexPath.row] isKindOfClass:[Message class]]){
     Message *message = [self.offers objectAtIndex:indexPath.row];
     if(message.message_type == MESSAGE_TYPE_O){
     cell.imageView.image = [UIImage imageNamed:@"icon_offer"];
     }
     else if(message.message_type == MESSAGE_TYPE_N){
     cell.imageView.image = [UIImage imageNamed:@"icon_promo"];
     }
     cell.textLabel.text = message.messageTitle;
     }*/
   
    [tableView reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IPAD) {
        return 100;
    }
    else
    {
        return 75;
    }
}




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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (IPAD) {
        return 100;
    }
    else
    {
       return 75;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"tgeejhhjejej %ld", (long)indexPath.row);
    Offer *offer = [_offers objectAtIndex:indexPath.row];
    
    if([[self.offers objectAtIndex:indexPath.row] isKindOfClass:[Offer class]]){
        if(![offer.count isEqualToString:@"none"])
        {
              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
            DetailViewController *detailViewController = [[DetailViewController alloc] init];
            [detailViewController setRootViewController:self.rootViewController];
            [detailViewController setDetailType:DETAIL_TYPE_OFFER];
             detailViewController.heritagePlaces=self.heritagePlaces;
            [detailViewController setDetailObject:[self.offers objectAtIndex:indexPath.row]];
            [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
            [self.rootViewController pushViewController:detailViewController animated:YES];
        }
    }
    else if([[self.offers objectAtIndex:indexPath.row] isKindOfClass:[Message class]])
    {
        Message *message = [self.offers objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_MESSAGE];
        NSLog(@"the Addition ffff %@", self.addition);
        detailViewController.Photos = self.addition;
        detailViewController.heritagePlaces=self.heritagePlaces;
        [detailViewController setDetailObject:[self.offers objectAtIndex:indexPath.row]];
        if ([message.messageType isEqualToString:@"N"])
        {
            detailViewController.flagString = @"Y";
        }
        [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:YES];
        
        }
}

@end
