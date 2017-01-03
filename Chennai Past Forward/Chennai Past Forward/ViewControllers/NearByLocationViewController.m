//
//  NearByLocationViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 02/02/16.
//  Copyright © 2016 Harish. All rights reserved.
//
#import "NearByLocationViewController.h"
#import "NearByTableViewCell.h"
#import "HomeViewController.h"
#import "MapViewController.h"
#import "Request.h"
#import "UIDevice+IdentifierAddition.h"
#import "UIImageView+AFNetworking.h"
#import "FilterTableViewCell.h"
#import "Reachability.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface NearByLocationViewController ()
{
    
    BOOL *already_updated;
}

@end

@implementation NearByLocationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (IPAD)
    {
        self = [super initWithNibName:@"NearByLocationViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"NearByLocationViewController" bundle:nil];
    }
    
    if(self){
        
    }
    return self;
}
@synthesize nearbyArr,items;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _nearTableView.delegate = self;
    _nearTableView.dataSource = self;
    //[self.view insertSubview:self.filter_btn aboveSubview:_nearTableView];
    int wi = self.tabsViewController.homeViewController.view.frame.size.width;
    NSLog(@"WIdth ====>> %d",wi);
    
    int hi = self.tabsViewController.homeViewController.view.frame.size.height;
    NSLog(@"WIdth ====>> %d",hi);
    _nearTableView.frame = CGRectMake(0, 0, wi,hi);
    //_btnselectArr=[[NSMutableArray alloc]init];
    _filterselectArr=[[NSMutableArray alloc]init];
    _dummyArr =[[NSMutableArray alloc]init];
    _deleteArr=[[NSMutableArray alloc]init];
//    _dummyArr1=[[NSMutableArray alloc]init];
//    for(int i=0;i<nearbyArr.count;i++)
//    {
//       [_dummyArr1 addObject:[nearbyArr objectAtIndex:i]];
//    }
    NSLog(@"dummyarry size %lu",(unsigned long)_dummyArr1.count);
//    for (int i=0; i<5; i++) {
//        [_btnselectArr addObject:@NO];
//    }
    NSLog(@"BOOLEAN ARRAY SIZE %lu",(unsigned long)_btnselectArr.count);
    NSLog(@"nearby cout %ld",(unsigned long)nearbyArr.count);
    NSLog(@"items count %ld",(unsigned long)items.count);

//    [AlertView showProgress];
//    [self loadValues];
    


}

- (void)viewDidAppear:(BOOL)animated
{
    [AlertView hideAlert];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [AlertView hideAlert];

}
- (void)viewWillAppear:(BOOL)animated
{
    [AlertView hideAlert];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(IBAction)filterbtn_click:(id)sender
{
    //(-800,0,180,180);
    
    NSLog(@"FILTER BUTTON CLICKED");
     NSInteger i = 100;
    [[NSUserDefaults standardUserDefaults]setInteger:i forKey:@"Share"];
     //_items = [NSArray arrayWithObjects:@"ATM", @"Hospital", @"Restaurant",@"Shopping mall", nil];
    //self.listviewcontroller = [[FilterActionSheetListViewController alloc] initWithButtonTitles:_items];
   // self.listviewcontroller.delegate = (id<ActionSheetDelegate>)self;
if([self connected])
{
    UIView *contentView= [[UIView alloc] initWithFrame:CGRectMake(0,0, 250, 255)];
    contentView.backgroundColor=[UIColor blackColor];
    contentView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8f];
    contentView.center=self.rootViewController.view.center;
    
     _popup_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 255)];
    [_popup_view setBackgroundColor:[UIColor blackColor]];

    _nearbyplaces_lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,5,250,20)];
    [_nearbyplaces_lbl setText:@"Choose Nearby Place Types"];
    [_nearbyplaces_lbl setFont:[_nearbyplaces_lbl.font fontWithSize: 15]];
    [_nearbyplaces_lbl setBackgroundColor:[UIColor blackColor]];
    [_nearbyplaces_lbl setTextAlignment:NSTextAlignmentCenter];
    [_nearbyplaces_lbl setTextColor:[UIColor whiteColor]];
    
    _searchnearby_btn=[[UIButton alloc]initWithFrame:CGRectMake(0,222,100,30) ];
    [_searchnearby_btn setTitle:@"Search" forState:UIControlStateNormal];
    [_searchnearby_btn setBackgroundColor:[UIColor grayColor]];
    [_searchnearby_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _searchnearby_btn.centerX =_popup_view.centerX;
    [_searchnearby_btn addTarget:self action:@selector(SearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    if(items.count!=0)
    {
    _optionview=[[UITableView alloc]initWithFrame:CGRectMake(0,20, 250, 200)];
    _optionview.dataSource=self;
    _optionview.delegate=self;
    //[_optionview addSubview:_nearbyplaces_lbl];
    
    [_popup_view addSubview:_optionview];
    [_popup_view addSubview:_nearbyplaces_lbl];
    [_popup_view insertSubview:_searchnearby_btn belowSubview:_optionview];
    [contentView addSubview:_popup_view];
    }
    else{
        _nonearby_lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,_popup_view.frame.size.height/2,_popup_view.frame.size.width,20)];
        [_nonearby_lbl setText:@"Turn on GPS to filter nearby places..."];
        [_nonearby_lbl setFont:[_nearbyplaces_lbl.font fontWithSize: 15]];
        [_nonearby_lbl setTextAlignment:NSTextAlignmentCenter];
        [_nonearby_lbl setTextColor:[UIColor whiteColor]];
        [_popup_view addSubview:_nonearby_lbl];
        //[_popup_view addSubview:_nearbyplaces_lbl];
       // [_popup_view insertSubview:_searchnearby_btn belowSubview:_optionview];
        [contentView addSubview:_popup_view];
  
    }
    //[contentView insertSubview:_searchnearby_btn belowSubview:_optionview];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:NO];
}
else{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Past Forward"
                                                          message:@"Not available in offline mode!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
    [myAlertView show];

}
}

- (void)SearchButtonClicked:(id)sender
{
    NSLog(@"SEARCH BUTTON CLICKED");
    [_filterselectArr removeAllObjects];
    [_dummyArr removeAllObjects];
    
    for (int i=0; i<self.btnselectArr.count; i++) {
        if([[self.btnselectArr objectAtIndex:i] isEqual:@YES])
        {
            commontypes = [items objectAtIndex:i];
            [_filterselectArr addObject:commontypes.TypesCode];
           
        }
    }
    for (int j=0; j<_filterselectArr.count; j++) {
         NSLog(@"filterselectedelements: %@",[_filterselectArr objectAtIndex:j]);
    }

    if(_filterselectArr.count!=0)
    {
    for(int k=0;k<_dummyArr1.count;k++){
         nearlocation=[_dummyArr1 objectAtIndex:k];
            for (int m=0; m<_filterselectArr.count; m++) {
                if ([nearlocation.types containsObject:[_filterselectArr objectAtIndex:m]]) {
                    [_dummyArr addObject:[_dummyArr1 objectAtIndex:k]];
            }
            }
    }
        nearbyArr=_dummyArr;
           }
    else{
        nearbyArr=_dummyArr1;
    }
    self.tabsViewController.nearPlace = nearbyArr;
    self.tabsViewController.btnselectArr=_btnselectArr;
    NSLog(@"nearbyarr size %lu",(unsigned long)nearbyArr.count);
    [self.tabsViewController.homeViewController.mapViewController addLocationMarkersForPlaces:nearbyArr];
    [self.nearTableView reloadData];
    [[KGModal sharedInstance]hideAnimated:TRUE];
}

#pragma mark - Connection
/*
-(void)loadValues
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    float lat = [[NSUserDefaults standardUserDefaults]floatForKey:@"Lattitude"];
    float lon = [[NSUserDefaults standardUserDefaults]floatForKey:@"Longitude"];
    
    NSLog(@"%f ,%f",lat,lon);
    
    [parameters setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
    [parameters setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"lng"];
    [Request makeRequestWithIdentifier:NEARBY_SEARCH parameters:parameters delegate:self];
 
}

- (void)connection:(Connection *)connection didReceiveData:(id)data
{
   
    if([data isKindOfClass:[NSString class]])
    {
        data = [data jsonValue];
    }
    nearbyArr = [NSMutableArray arrayWithArray:[self parseOffers:data]];
    
    [_nearTableView reloadData];
    [self.mapViewController addLocationMarkersForPlaces:nearbyArr];
    


//    [self.homeViewController.mapViewController addLocationMarkersForPlaces:nearbyArr];

    [AlertView hideAlert];
    
}
- (void)connection:(Connection *)connection didFailWithError:(NSError *)error{
    [AlertView hideAlert];
}


- (NSArray *)parseOffers:(NSDictionary *)data
{
    ////3
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"NearByBuildings"])
    {
        data = [data objectForKey:@"NearByBuildings"];
        for (NSDictionary *offerDictionary in data) {
            [array addObject:[NearByLocation objectFromDictionary:offerDictionary]];
        }
    }
    
    return array;
}
*/
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowNo = indexPath.row;
   if(tableView==_optionview)
   {
       FilterTableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
       UIButton *playBtn = (UIButton*)[cell viewWithTag:rowNo];
       
       if(playBtn.tag ==rowNo)
       {
           NSLog(@"FILTER BTN TAG %ld",(long)playBtn.tag);
           if([[self.btnselectArr objectAtIndex:rowNo] isEqual:@NO])
           {
               _btnselectArr[rowNo]=@YES;
              // [_filterselectArr addObject:[_items objectAtIndex:rowNo]];
           }
           else{
              _btnselectArr[rowNo]=@NO;
              // [_filterselectArr removeObjectAtIndex:rowNo];
           }
       }
       [_optionview reloadData];
   }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSLog(@"nearbyArrayCount====>>>> %lu",(unsigned long)nearbyArr.count);
    
    if (tableView==_optionview)
    {
        return [items count];
    }
     return nearbyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row at index path");
    
    if (tableView==_optionview)
    {
        static NSString *identifier = @"SimpleTableViewCell";
        
       // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        FilterTableViewCell *cell=(FilterTableViewCell *)[_optionview dequeueReusableCellWithIdentifier:
                                                          identifier];
        commontypes = [items objectAtIndex:indexPath.row];
        //[_items addObject:[nearbyArr objectAtIndex:indexPath.row]];
        
        if (!cell) {
           // cell = [[UITableViewCell alloc]
                   // initWithStyle:UITableViewCellStyleDefault
                  //  reuseIdentifier:identifier];
            cell=[[[NSBundle mainBundle]loadNibNamed:@"FilterTableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        //cell.name_lbl.text = _items[indexPath.row];
        cell.name_lbl.text=commontypes.Type;
        cell.filter_btn.tag=indexPath.row;
         [cell.filter_btn addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
        if([[self.btnselectArr objectAtIndex:indexPath.row] isEqual:@NO])
        {
        [cell.filter_btn setSelected:NO];
        }
        else{
        [cell.filter_btn setSelected:YES];
        }
        
        
     return cell;
}

    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    NearByTableViewCell *cell = (NearByTableViewCell *)[_nearTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NearByTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    nearlocation = [nearbyArr objectAtIndex:indexPath.row];
    //[_filterselectArr addObject:[_items objectAtIndex:rowNo]];
    cell.nameLbl.font = [UIFont boldSystemFontOfSize:14];
    cell.nameLbl.text = [NSString stringWithFormat:@"%@",nearlocation.name];
    cell.adressLbl.font = [UIFont systemFontOfSize:13];
    cell.adressLbl.textColor = [UIColor grayColor];
    cell.adressLbl.numberOfLines = 3;
    cell.adressLbl.text = [NSString stringWithFormat:@"%@",nearlocation.vicinity];
    
    
    float lat1  = [[NSUserDefaults standardUserDefaults]floatForKey:@"Lattitude"];
    float long1 = [[NSUserDefaults standardUserDefaults]floatForKey:@"Longitude"];
    
    float lat2 = nearlocation.latitude;
    float long2 = nearlocation.longitude;
    
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
    NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
    
    float distance = [location1 distanceFromLocation:location2];
    float km = distance/1000;
    cell.distanceLbl.font = [UIFont systemFontOfSize:13];
    cell.distanceLbl.textColor = [UIColor grayColor];
    cell.distanceLbl.text = [NSString stringWithFormat:@"Distance: %.2f kms",km];

    
    NSString *urlString = [NSString stringWithFormat:@"%@", nearlocation.url];
    //                (title == (id)[NSNull null] || title.length == 0 )
    if (urlString == (id)[NSNull null] || urlString.length == 0 )
    {
         NSString *urlString1 = [NSString stringWithFormat:@"%@", nearlocation.icon];
        NSURL *imageURL = [NSURL URLWithString:[urlString1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [cell.buildingImage setImageWithURL:imageURL];
       
    }
    else
    {
        NSURL *imageURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [cell.buildingImage setImageWithURL:imageURL];
    }
    return cell;
    
}
-(IBAction)onAddClick:(UIButton *)button
{
    NSLog(@"button clicked %ld",(long)[button tag]);
    if([[self.btnselectArr objectAtIndex:[button tag]] isEqual:@NO])
    {
        _btnselectArr[[button tag]]=@YES;
        // [_filterselectArr addObject:[_items objectAtIndex:rowNo]];
    }
    else{
        _btnselectArr[[button tag]]=@NO;
        // [_filterselectArr removeObjectAtIndex:rowNo];
    }
     [_optionview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==_optionview)
    {
        return 200/4;
    }
    return 88;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
