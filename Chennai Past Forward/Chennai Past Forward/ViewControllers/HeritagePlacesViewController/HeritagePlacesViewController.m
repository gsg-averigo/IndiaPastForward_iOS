//
//  HeritagePlacesViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "HeritagePlacesViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "TabsViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "HeritagePlace.h"
#import "AlertView.h"
#import "Request.h"
#import "NSObject+Parser.h"
#import "UIDevice+IdentifierAddition.h"
#import "Reachability.h"
#import "HeritageBuildingInfo.h"
#import "Article.h"
#import "Offer.h"
#import "CustomIndicator.h"
#import "DatabaseHelper.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface HeritagePlacesViewController ()
{
    NSMutableArray  *arr,*arr1;
    CustomIndicator *activityIndicator;
    NSMutableArray  *imageArray ;
    NSMutableArray  *nameArray,*adreesArray,*pincodeArray ,*descriptionArr;
    BOOL *already_updated;
}
@end

@implementation HeritagePlacesViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)init
{
    if (IPAD)
    {
        self = [super initWithNibName:@"HeritagePlacesViewController~iPad" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"HeritagePlacesViewController" bundle:nil];
    }
    
    //self = [super initWithNibName:@"HeritagePlacesViewController" bundle:nil];
    if(self){
        
    }
    return self;
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray  = [[NSMutableArray alloc]init];
    imgData = [[NSData alloc]init];
    imgData = [[NSData alloc]init];
    already_updated=0;
    NSString * pushmsg= [[NSUserDefaults standardUserDefaults]stringForKey:@"PushMsg"];
    if ([pushmsg isEqualToString:@"Y"])
    {
    }
    
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (IPAD)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 600, 0);
    }
    [self reload_data];
    [self performSelector:@selector(zoom)  withObject:nil afterDelay:0.1
     ];
    
}
-(void)reload_data
{
    if ([self connected])
    {
      
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
          dispatch_async(dispatch_get_main_queue(), ^{
        
                locationManager = [[CLLocationManager alloc] init];
                locationManager.delegate = self;
                locationManager.distanceFilter = kCLDistanceFilterNone;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
              
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                [locationManager requestWhenInUseAuthorization];
                NSLog(@"bfore updagted %d",already_updated);
                if(!already_updated)
                {
                already_updated=1;
                NSLog(@"already updated %d",already_updated);
                [locationManager startUpdatingLocation];
                }
                
               // [self.tableView reloadData];
            });
           
          
            
            
            
            [AlertView hideAlert];
            
       });
    }else
    {
        DatabaseHelper *databasehelper = [[DatabaseHelper alloc] init];
        [databasehelper createDatabaseInstance];
        _sqliteHeritagePlaces = [databasehelper getAllRecords];
        NSLog(@"_sqliteHeritagePlaces:%@",_sqliteHeritagePlaces);
        [AlertView hideAlert];
    }
    
    if ([_sqliteHeritagePlaces count]!=0)
    {
        nameArray = [_sqliteHeritagePlaces valueForKey:@"name"];
        adreesArray = [_sqliteHeritagePlaces valueForKey:@"streetName"];
        pincodeArray = [_sqliteHeritagePlaces valueForKey:@"pincode"];
        descriptionArr = [_sqliteHeritagePlaces valueForKey:@"Description"];
        imageArray = [_sqliteHeritagePlaces valueForKey:@"ThumbnailPhoto"];
        [self.tableView reloadData];
    }
  
}

-(void)zoom
{
    if(!self.tabsViewController.isIndiaTab)
    {
    [self.tabsViewController.homeViewController.mapViewController zoomInToMyLocation];
    }

}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   //
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     double old_lat=[defaults doubleForKey:@"latitude"];
     double old_long=[defaults doubleForKey:@"longitude"];
     CLLocation *locB = [[CLLocation alloc] initWithLatitude:old_lat longitude:old_long];
    double k = [[NSUserDefaults standardUserDefaults]integerForKey:@"Adding"];
    NSLog(@"k %f",k);
     if (old_lat == newLocation.coordinate.latitude)
     {
        
     }
     else
     {
        [defaults setDouble:newLocation.coordinate.latitude forKey:@"latitude"];
        [defaults setDouble:newLocation.coordinate.longitude forKey:@"longitude"];
        int distance = [newLocation distanceFromLocation:locB];
        NSLog(@"calculated distance %d",distance);
        if(distance > 50 )
        {
            NSLog(@"Distance is   %d",distance);
            
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                
                
                double k = [[NSUserDefaults standardUserDefaults]integerForKey:@"Adding"];
        NSLog(@"k %f",k);
                if (k != 10)
                {
                    DatabaseHelper *databasehelper = [[DatabaseHelper alloc] init];
                    NSArray *guidarr = [_sqliteHeritagePlaces valueForKey:@"heritagebuildinginfoguid"];
                   
                    if(_heritagePlaces.count!=0)
                    {
                    [databasehelper deleteheritageplaces];
                    for (int i =0; i < _sqliteHeritagePlaces.count; i++)
                    {
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsPath = [paths objectAtIndex:0];
                        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:i]]];
                        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                    }
                    }
                    NSLog(@"heritage place count %lu",(unsigned long)_heritagePlaces.count);
                    if(guidarr.count==0)
                    {
                    for (int i = 0; i < _heritagePlaces.count; i++)
                    {
                    HeritagePlace *place = [_heritagePlaces objectAtIndex:i];
                    NSString *guid = [NSString stringWithFormat:@"%@", place.heritagebuildinginfoguid];
                    NSString *name = [NSString stringWithFormat:@"%@", place.name];
                    NSString *alternative_name=[NSString stringWithFormat:@"%@",place.alternativeNames];
                    NSString *category=[NSString stringWithFormat:@"%@",place.category];
                    NSString *latt = [NSString stringWithFormat:@"%f",  place.latitude];
                    NSString *longt = [NSString stringWithFormat:@"%f",  place.longitude];
                    NSString *description  =[NSString stringWithFormat:@"%@",  place.hp_description];
                    NSString *location = [NSString stringWithFormat:@"%@",place.location];
                    NSString *pincode = [NSString stringWithFormat:@"%@",place.pincode];
                    NSString *distance = [NSString stringWithFormat:@"%f",place.distance];
                    NSString *photo=[NSString stringWithFormat:@"%@",place.photo];
                    NSString *thumbnailImage =[NSString stringWithFormat:@"%@",place.thumbnailphoto];
                    NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",place.heritagebuildinginfoguid, place.thumbnailphoto]];
                        NSLog(@"directory url %@",url);
                        
                        if (url.absoluteString.length != 0)
                        {
                            NSData * imageData;
                            if ([place.thumbnailphoto isEqualToString:@""])
                            {
                                UIImage  *uiImage = [UIImage imageNamed:@"thumb_stub"];
                                imageData  = UIImagePNGRepresentation(uiImage);
                            }else
                            {
                                NSData   *data = [[NSData alloc] initWithContentsOfURL:url];
                                UIImage  *uiImage   = [UIImage imageWithData:data];
                                imageData = UIImagePNGRepresentation(uiImage);
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                              NSString *documentsPath = [paths objectAtIndex:0];
                                 NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",thumbnailImage]];
                                NSLog(@"filepath %@",filePath);
                                [imageData writeToFile:filePath atomically:YES];
                            }

                            
                        [databasehelper insert:guid andName:name andAlternative:alternative_name andCategory:category andDistance:distance andDescription:description andLattitude:latt andLongitide:longt andPincode:pincode andPhoto:photo andThumbnailPhoto:thumbnailImage andLocation:location];
                        }
                    }
                    }
                  
                }
            });
            [locationManager stopUpdatingLocation];
            locationManager = nil;
 
        }
        
       
    }
    
       
    
}

- (NSArray *)parseHeritagePlaces:(NSDictionary *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"HeritageBuildingInfo"])
    {
        data = [data objectForKey:@"HeritageBuildingInfo"];
        
        for (NSDictionary *heritagePlaceDictionary in data)
        {
            [array addObject:[HeritagePlace objectFromDictionary:heritagePlaceDictionary]];
        }
    }
    
    return array;
}


- (void)didReceiveMemoryWarning
{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([_heritagePlaces count]!= 0)
    {
        [_tabsViewController.sqliteHeritagePlaces removeAllObjects];
        return _tabsViewController.heritagePlaces.count;
        
    }
    else if([_tabsViewController.sqliteHeritagePlaces count]!= 0)
    {
        NSLog(@"Heritage count ====>>>%lu",(unsigned long)_tabsViewController.sqliteHeritagePlaces.count);
        return _tabsViewController.sqliteHeritagePlaces.count;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellH";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *imageView;
    UILabel *nameLabel, *addressLabel, *distanceLabel;
    UIButton *postCard;

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        imageView = [[UIImageView alloc] init];
        imageView.tag = 1000;
        imageView.origin = CGPointMake(8, 8);
        imageView.size = CGSizeMake(72, 72);
        [cell.contentView addSubview:imageView];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.tag = 1001;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.origin = CGPointMake(imageView.right + 8, 8);
        nameLabel.adjustsFontSizeToFitWidth = NO;
        
        if (IPAD) {
            
            nameLabel.size = CGSizeMake(cell.contentView.width+250 - nameLabel.left - 8, 18);
            //nameLabel.size=CGSizeMake(cell.contentView.width-nameLabel.left-8, 18);
        }
        else
        {
           //nameLabel.size = CGSizeMake(cell.contentView.width+100 - nameLabel.left - 8, 18);
            nameLabel.size=CGSizeMake(cell.contentView.width-nameLabel.left-8, 18);
             nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
        }
       
        [cell.contentView addSubview:nameLabel];
        
        addressLabel = [[UILabel alloc] init];
        addressLabel.tag = 1002;
        addressLabel.font = [UIFont systemFontOfSize:13];
        addressLabel.textColor = [UIColor grayColor];
        addressLabel.numberOfLines = 0;
        addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        addressLabel.left = imageView.right + 8;
        addressLabel.origin = CGPointMake(imageView.right + 8, nameLabel.bottom + 4);
        addressLabel.size = CGSizeMake(cell.contentView.width - addressLabel.left - 8, 32);
        [cell.contentView addSubview:addressLabel];
        
        distanceLabel = [[UILabel alloc] init];
        distanceLabel.tag = 1003;
        distanceLabel.font = [UIFont systemFontOfSize:13];
        distanceLabel.textColor = [UIColor grayColor];
        distanceLabel.origin = CGPointMake(imageView.right + 8, addressLabel.bottom + 4);
        distanceLabel.size = CGSizeMake(cell.contentView.width - distanceLabel.left - 8, 14);
        [cell.contentView addSubview:distanceLabel];
      if([self connected])
      {
        if (_heritagePlaces.count!=0||_sqliteHeritagePlaces.count!=0)
        {
            postCard = [[UIButton alloc] init];
            postCard.tag = 1004;
            
            UIImage *btnImage1 = [UIImage imageNamed:@"postcard.png"];
            [postCard setImage:btnImage1 forState:UIControlStateNormal];
            if (IPAD)
            {
                postCard.frame = CGRectMake(self.view.frame.size.width - 70, 35, 40, 40);
            }
            else
            {
                postCard.frame = CGRectMake(addressLabel.width+20, 35, 40, 40);
            }
            
            [postCard addTarget:self action:@selector(detailViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:postCard];
            
        }
      }
        
    }
    else
    {
        imageView = (UIImageView *)[cell.contentView viewWithTag:1000];
        nameLabel = (UILabel *)[cell.contentView viewWithTag:1001];
        addressLabel = (UILabel *)[cell.contentView viewWithTag:1002];
        distanceLabel = (UILabel *)[cell.contentView viewWithTag:1003];
        if ([self connected])
        {
            postCard = (UIButton *)[cell.contentView viewWithTag:1004];
        }
        
    }
    
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    imageView.image = [UIImage imageNamed:@"thumb_stub"];
    
    if ([_heritagePlaces count]!= 0)
    {
        
        HeritagePlace *place = [_heritagePlaces objectAtIndex:indexPath.row];
        [imageView setImageWithURL:[NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",place.heritagebuildinginfoguid, place.thumbnailphoto]]];
        
        nameLabel.text = [NSString stringWithFormat:@"%li %@",indexPath.row+1, place.name];
        addressLabel.text = [NSString stringWithFormat:@"%@\n%@", place.location,  place.pincode];
        
        CGFloat distance = place.distance;
        if (isnan(distance) || distance==0.00 || self.tabsViewController.isIndiaTab)
        {
            if(self.tabsViewController.isIndiaTab&&self.tabsViewController.showDistance)
            {
               distanceLabel.text = [NSString stringWithFormat:@"Distance: %.2f kms",distance];  
            }
            else{
            distanceLabel.text = [NSString stringWithFormat:@"Distance:Unknown"];
            }
        }
        else
        {
            distanceLabel.text = [NSString stringWithFormat:@"Distance: %.2f kms",distance];
        }
        
    }
    else if([_sqliteHeritagePlaces count]!=0)
    {
        if([_sqliteHeritagePlaces count]!=10)
        {
        nameLabel.text = [nameArray objectAtIndex:indexPath.row];
        addressLabel.text = [NSString stringWithFormat:@"%@\n%@", [adreesArray objectAtIndex:indexPath.row], [pincodeArray objectAtIndex:indexPath.row]];
        //imageView.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        if(![[imageArray objectAtIndex:indexPath.row] isEqual:@""])
        {
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:indexPath.row]]];
        NSLog(@"FILE PATH WHEN RETRIEVING %@",filePath);
        NSData *pngData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image  = [UIImage imageWithData:pngData];
        imageView.image=image;
        }
        else
        {
        UIImage *image=[UIImage imageNamed:@"thumb_stub.png"];
        imageView.image=image;
        }
        distanceLabel.text = [NSString stringWithFormat:@"Distance:Unknown"];
        }
        else{
            nameLabel.text = [nameArray objectAtIndex:indexPath.row];
            addressLabel.text = [NSString stringWithFormat:@"%@\n%@", [adreesArray objectAtIndex:indexPath.row], [pincodeArray objectAtIndex:indexPath.row]];
            //imageView.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            if(![[imageArray objectAtIndex:indexPath.row] isEqual:@""])
            {
//                NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:indexPath.row]]];
//                NSLog(@"FILE PATH WHEN RETRIEVING %@",filePath);
//                NSData *pngData = [NSData dataWithContentsOfFile:filePath];
                imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:indexPath.row]]];
            }
            else
            {
                UIImage *image=[UIImage imageNamed:@"thumb_stub.png"];
                imageView.image=image;
            }
            distanceLabel.text = [NSString stringWithFormat:@"Distance:Unknown"];
 
        }
    }
    else
    {
        NSLog(@"No tableview");
    }
    
    return cell;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
    if (self.heritagePlaces.count!=0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        [detailViewController setDetailObject:[self.heritagePlaces objectAtIndex:indexPath.row]];
        NSLog(@"the add photo %@",self.AdditionalPhotos);
        HeritagePlace *place = [self.heritagePlaces objectAtIndex:indexPath.row];
        NSMutableArray *newDevice = [[NSMutableArray alloc]init];
        newDevice = [_heritagePlaces objectAtIndex:indexPath.row];
        detailViewController.placeArray = newDevice;
        detailViewController.heritagePlaces = _heritagePlaces;
        NSLog(@"%f ",place.latitude);
        NSLog(@"%f",place.longitude);
        detailViewController.Photos=_AdditionalPhotos;
        detailViewController.isPostCard = NO;
        [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
        NSLog(@"rootviewcontroller %@",self.rootViewController);
        NSLog(@"frame width %f",self.tabsViewController.homeViewController.view.width);
        NSLog(@"frame height %f",self.tabsViewController.homeViewController.view.height);
        [self.rootViewController pushViewController:detailViewController animated:YES];
    }
    else
    {
        NSLog(@"selected array:%@",[_sqliteHeritagePlaces objectAtIndex:indexPath.row]);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        detailViewController.nameString = [nameArray objectAtIndex:indexPath.row];
        detailViewController.webString = [descriptionArr objectAtIndex:indexPath.row];
        detailViewController.PhotoString =[[_sqliteHeritagePlaces objectAtIndex:indexPath.row]valueForKey:@"Photo"];
        NSLog(@"photostring %@",[[_sqliteHeritagePlaces objectAtIndex:indexPath.row]valueForKey:@"ThumbnailPhoto"]);
        detailViewController.heritagePlaces = _heritagePlaces;
        [detailViewController setDetailObject:[_sqliteHeritagePlaces objectAtIndex:indexPath.row]];
        [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
    
    NSString * pushmsg= [[NSUserDefaults standardUserDefaults]stringForKey:@"PushMsg"];
    if ([pushmsg isEqualToString:@"Y"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_GUID];
        [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:NO];
    }
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


#pragma mark - Button action

-(IBAction)detailViewAction:(UIButton *)sender

{
    
    //if([_heritagePlaces count]!=0)
   // {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
    NSLog(@"Going to detail view");
    
    NSLog(@"Button pressed: %ld", (long)[sender tag]);
    [[NSUserDefaults standardUserDefaults]setInteger:[sender tag] forKey:@"tag"];
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"indexpath ===>>> %@",indexPath);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"indexpath.row  %ld",(long)indexPath.row);
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"index"];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
    [detailViewController setDetailType:DETAIL_TYPE_PLACE];
    if(self.heritagePlaces.count!=0)
    {
    [detailViewController setDetailObject:[self.heritagePlaces objectAtIndex:indexPath.row]];
    }
    else{
    [detailViewController setDetailObject:[_sqliteHeritagePlaces objectAtIndex:indexPath.row]];
    }
       NSLog(@"the add photo %@",self.AdditionalPhotos);
    NSMutableArray *newDevice = [[NSMutableArray alloc]init];
    //newDevice = [_heritagePlaces objectAtIndex:indexPath.row];
    detailViewController.placeArray = newDevice;
    detailViewController.Photos=self.AdditionalPhotos;
    detailViewController.heritagePlaces = _heritagePlaces;
   
    [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
    NSLog(@"Frame size width:%f",self.tabsViewController.homeViewController.view.size.width);
    NSLog(@"Frame size height:%f",self.tabsViewController.homeViewController.view.size.height);
    NSLog(@"rootviewcontroller %@",self.rootViewController);
    [self.rootViewController pushViewController:detailViewController animated:YES];
//}
//    else{
//    UITableViewCell *cell = (UITableViewCell *)sender.superview;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    DetailViewController *detailViewController = [[DetailViewController alloc] init];
//    [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
//    [detailViewController setDetailType:DETAIL_TYPE_PLACE];
//    detailViewController.nameString = [nameArray objectAtIndex:indexPath.row];
//    detailViewController.webString = [descriptionArr objectAtIndex:indexPath.row];
//    detailViewController.PhotoString =[[_sqliteHeritagePlaces objectAtIndex:indexPath.row]valueForKey:@"Photo"];
//    [detailViewController setDetailObject:[_sqliteHeritagePlaces objectAtIndex:indexPath.row]];
//    [detailViewController.view setSize:self.tabsViewController.homeViewController.view.size];
//    [self.rootViewController pushViewController:detailViewController animated:YES];
//    }

}



@end
