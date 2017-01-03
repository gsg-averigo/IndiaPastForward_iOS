//
//  RootViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 22/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "MapViewController.h"
#import "Request.h"
#import "AlertView.h"
#import "Categories.h"
#import "ActionSheetViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue])

#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDevice+IdentifierAddition.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HeritagePlace.h"
#import "NSObject+Parser.h"


NSInteger const kImageCount = 18;
@interface RootViewController ()
{
    UIView *rootView;
    NSString *jpgPath;
    NSMutableArray *imageArr;
    UIImage* properlyRotatedImage;
    
    
//    std::vector<int> _indexes;
//    std::vector<std::string> _filenames;
//    cv::Mat _features;
//    cv::flann::Index _kdtree;
//    
//    bool _queryingImage;
//    dispatch_queue_t _imageQueue;



}
@property (strong, nonatomic)IBOutlet UIView *headerView;
@property (strong, nonatomic)IBOutlet UIView *contentView;
@property (strong, nonatomic)IBOutlet UIButton *menuButton;
@property (strong, nonatomic)IBOutlet UIButton *backButton;
@property (strong, nonatomic)IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) ActionSheetViewController *actionSheet;

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation RootViewController

#pragma mark -

- (id)init{
    // self = [super initWithNibName:@"RootViewController" bundle:nil];
    
    
    if (IPAD)
    {
        self = [super initWithNibName:@"RootViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"RootViewController" bundle:nil];
    }
    
    if(self)
    {
        self.viewControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark -

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    rootView = self.navigationController.view;
    [self addSearchIcon];
    self.homeViewController = [[HomeViewController alloc] init];
    [self.homeViewController setRootViewController:self];
    [self.homeViewController.view setSize:self.contentView.size];
    [self pushViewController:self.homeViewController animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setInteger:(10 * 60) forKey:@"gpsInterval"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self performSelector:@selector(getNumberOfNearbyLocations) withObject:nil
    //           afterDelay:[[NSUserDefaults standardUserDefaults] integerForKey:@"gpsInterval"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *showintro = [defaults objectForKey:@"showintro"];
    NSLog(@"ShowIntro  root Value:%@",showintro);
    if (![showintro isEqualToString:@"yes"])
    {
        [self introductionview];
    }
    
    imageArr = [[NSMutableArray alloc]init];
}

-(void)introductionview
{
    if (IPAD) {
        EAIntroPage *page1 = [EAIntroPage page];
        page1.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help01"];
        page1.title=@"";
        
        EAIntroPage *page2 = [EAIntroPage page];
        page2.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help02"];
        page2.title=@"";
        page2.onPageDidAppear = ^{
            NSLog(@"");
        };
        
        EAIntroPage *page3 = [EAIntroPage page];
        page3.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help03"];
        page3.title=@"";
        
        EAIntroPage *page4 = [EAIntroPage page];
        page4.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help04"];
        page4.title=@"";
        
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds];
        [intro setDelegate:self];
        [intro setPages:@[page1,page2,page3,page4]];
        
        [intro showInView:rootView animateDuration:0.3];
    }
    else
    {
        EAIntroPage *page1 = [EAIntroPage page];
        page1.bgImage = [UIImage imageNamed:@"rsz_11600x2560_help01"];
        page1.title=@"";
        
        EAIntroPage *page2 = [EAIntroPage page];
        page2.bgImage = [UIImage imageNamed:@"1600x2560_help02"];
        page2.title=@"";
        page2.onPageDidAppear = ^{
            NSLog(@"");
        };
        
        EAIntroPage *page3 = [EAIntroPage page];
        page3.bgImage = [UIImage imageNamed:@"1600x2560_help03"];
        page3.title=@"";
        
        EAIntroPage *page4 = [EAIntroPage page];
        page4.bgImage = [UIImage imageNamed:@"1600x2560_help04"];
        page4.title=@"";
        
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds];
        [intro setDelegate:self];
        [intro setPages:@[page1,page2,page3,page4]];
        
        [intro showInView:rootView animateDuration:0.3];
        
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.homeViewController textFieldShouldReturn:textField];
}


- (IBAction)backButtonTapped:(id)sender
{
    NSLog(@"Count:%lu",(unsigned long)[self.viewControllers count]);
    NSString *Push_Msg=[[NSUserDefaults standardUserDefaults]objectForKey:@"PushMsg"];
    if([self.viewControllers count]>=3 && [Push_Msg isEqualToString:@"Y"])
    {    
        UIViewController *viewController =[[RootViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"PushMsg"];
        UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
        window.rootViewController = viewController;
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([self.viewControllers count] > 1)
    {
//        if ([self.viewControllers count] == 3)
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            [self popViewController:[self.viewControllers lastObject] animated:YES];
//            
//            
//        }
//        
    
        [self popViewController:[self.viewControllers lastObject] animated:YES];
    }
    else
    {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
        [Request makeRequestWithIdentifier:MESSAGEBOX_INFO parameters:parameters delegate:self.homeViewController];
        [AlertView showProgress];
    }
}

- (IBAction)menuButtonTapped:(id)sender
{
//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//        [_locationManager requestWhenInUseAuthorization];
//    
//    [_locationManager startUpdatingLocation];
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
    
    float lat = [[NSUserDefaults standardUserDefaults]floatForKey:@"Lattitude"];
    float lon = [[NSUserDefaults standardUserDefaults]floatForKey:@"Longitude"];
    
    NSLog(@"%f ,%f",lat,lon);
    
    [parameters setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"strLatitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"strLongitude"];
    [Request makeRequestWithIdentifier:GET_CAMERA parameters:parameters delegate:self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        [self presentModalViewController:imagePicker animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
    

    /*[self.searchTextField resignFirstResponder];
    NSArray *items = [NSArray arrayWithObjects:@"HERITAGE", @"ARTICLES", @"SETTINGS", nil];
    self.actionSheet = [[ActionSheetViewController alloc] initWithButtonTitles:items];
    self.actionSheet.delegate = (id<ActionSheetDelegate>)self;
    [self.view addSubview:self.actionSheet.view];*/
}

#pragma mark -

- (void)actionSheet:(ActionSheetViewController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([actionSheet.title isEqualToString:@"GPS INTERVAL"]){
        if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"10 Minutes"]){
            [[NSUserDefaults standardUserDefaults] setInteger:(10 * 60) forKey:@"gpsInterval"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"20 Minutes"]){
            [[NSUserDefaults standardUserDefaults] setInteger:(20 * 60) forKey:@"gpsInterval"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"30 Minutes"]){
            [[NSUserDefaults standardUserDefaults] setInteger:(30 * 60) forKey:@"gpsInterval"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        //[self performSelector:@selector(getNumberOfNearbyLocations) withObject:nil
        //           afterDelay:[[NSUserDefaults standardUserDefaults] integerForKey:@"gpsInterval"]];
    }
    else if([actionSheet.title isEqualToString:@"MANAGE NOTIFICATION"]){
        if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"TURN ON"]){
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"TURN OFF"]){
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
    }
    else{
        if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"HERITAGE"]){
            self.homeViewController.searchBy = @"Heritage";
        }
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"ARTICLES"]){
            self.homeViewController.searchBy = @"Articles";
        }
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"GPS"]){
            self.actionSheet = [[ActionSheetViewController alloc] initWithButtonTitles:[NSArray arrayWithObjects:@"10 Minutes", @"20 Minutes", @"30 Minutes", nil]];
            self.actionSheet.title = @"GPS INTERVAL";
            self.actionSheet.delegate = (id<ActionSheetDelegate>)self;
            [self.view addSubview:self.actionSheet.view];
        }
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"NOTIFICATION"]){
            self.actionSheet = [[ActionSheetViewController alloc] initWithButtonTitles:[NSArray arrayWithObjects:@"TURN ON", @"TURN OFF", nil]];
            self.actionSheet.title = @"MANAGE NOTIFICATION";
            self.actionSheet.delegate = (id<ActionSheetDelegate>)self;
            [self.view addSubview:self.actionSheet.view];
        }
        else{
            self.actionSheet = [[ActionSheetViewController alloc] initWithButtonTitles:[NSArray arrayWithObjects:@"GPS", @"NOTIFICATION", nil]];
            self.actionSheet.delegate = (id<ActionSheetDelegate>)self;
            [self.view addSubview:self.actionSheet.view];
        }
    }
}

#pragma mark - Navigation methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *previousViewController = [self.viewControllers lastObject];
    [viewController.view setLeft:previousViewController.view.right];
    [self.contentView addSubview:viewController.view];
    
    if([previousViewController respondsToSelector:@selector(viewWillDisappear:)]){
        [previousViewController viewWillDisappear:YES];
    }
    if([viewController respondsToSelector:@selector(viewWillAppear:)]){
        [viewController viewWillAppear:YES];
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0
                     animations:^ (void){
                         previousViewController.view.left -= viewController.view.width;
                         viewController.view.left = 0;
                     }
                     completion:^ (BOOL finished){
                         [previousViewController.view removeFromSuperview];
                         [self.viewControllers addObject:viewController];
                         if(self.viewControllers.count > 1)
                         {
                             [self.backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
                             
                         }
                         else{
                             [self.backButton setImage:[UIImage imageNamed:@"cpf-notify"] forState:UIControlStateNormal];
                         }
                     }
     ];
}

- (void)popViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([_viewControllers lastObject] == viewController && _viewControllers.count > 1)
    {
        [_viewControllers removeLastObject];
        
        UIViewController *nextViewController = [_viewControllers lastObject];
        [nextViewController.view setRight:[viewController.view left]];
        [_contentView addSubview:nextViewController.view];
        
        if([viewController respondsToSelector:@selector(viewWillDisappear:)]){
            [viewController viewWillDisappear:YES];
        }
        if([viewController respondsToSelector:@selector(viewWillAppear:)]){
            [nextViewController viewWillAppear:YES];
        }
        
        [UIView animateWithDuration:animated ? 0.25 : 0.0
                         animations:^ (void){
                             [nextViewController.view setLeft:0];
                             [viewController.view setLeft:viewController.view.right];
                         }
                         completion:^ (BOOL finished){
                             [viewController.view removeFromSuperview];
                             if(_viewControllers.count > 1){
                                 [self.backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
                             }
                             else{
                                 [_backButton setImage:[UIImage imageNamed:@"cpf-notify"] forState:UIControlStateNormal];
                             }
                         }
         ];
    }
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([self.viewControllers containsObject:viewController] && self.viewControllers.count > 1){
        NSInteger index = [self.viewControllers indexOfObject:viewController];
        UIViewController *lastViewController = [self.viewControllers lastObject];
        UIViewController *firstViewController = [self.viewControllers objectAtIndex:index];
        [firstViewController.view setRight:[lastViewController.view left]];
        [self.contentView addSubview:firstViewController.view];
        
        if([lastViewController respondsToSelector:@selector(viewWillDisappear:)]){
            [lastViewController viewWillDisappear:YES];
        }
        if([viewController respondsToSelector:@selector(viewWillAppear:)]){
            [viewController viewWillAppear:YES];
        }
        
        [UIView animateWithDuration:animated ? 0.25 : 0.0
                         animations:^ (void){
                             [firstViewController.view setLeft:0];
                             [lastViewController.view setLeft:firstViewController.view.right];
                             if(self.viewControllers.count > 1){
                                 [self.backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
                             }
                             else{
                                 [self.backButton setImage:[UIImage imageNamed:@"cpf-notify"] forState:UIControlStateNormal];
                             }
                         }
                         completion:^ (BOOL finished){
                             [firstViewController viewWillAppear:YES];
                             [lastViewController viewWillDisappear:YES];
                             [lastViewController.view removeFromSuperview];
                         }
         ];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated{
    if(self.viewControllers.count > 1){
        id lastViewController = [self.viewControllers lastObject];
        while (self.viewControllers.count > 1) {
            [self.viewControllers removeLastObject];
        }
        
        if(self.viewControllers.count > 0){
            [self.viewControllers addObject:lastViewController];
            [self popViewController:[self.viewControllers lastObject] animated:YES];
        }
    }
}

#pragma mark -

- (void)addSearchIcon{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"search_icon"];
    imageView.frame = CGRectMake(0, 0, 24, 24);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = imageView;
}

- (void)getNumberOfNearbyLocations
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
    [parameters setObject:[NSString stringWithFormat:@"%f",self.homeViewController.mapViewController.location.coordinate.latitude] forKey:@"strLatitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f",self.homeViewController.mapViewController.location.coordinate.longitude] forKey:@"strLongitude"];
    [Request makeRequestWithIdentifier:COUNT_BY_LOCATION parameters:parameters delegate:self.homeViewController];
    
    [self performSelector:@selector(getNumberOfNearbyLocations) withObject:nil
               afterDelay:[[NSUserDefaults standardUserDefaults] integerForKey:@"gpsInterval"]];
}

/*
- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    cv::Mat grayMat;
    
    cv::cvtColor(cvMat, grayMat, CV_BGR2GRAY);
    
    return grayMat;
}


- (void)compareWithImage:(UIImage *)image
{
//    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:_HUD];
//    _HUD.labelText = @"Comparing...";
//    [_HUD show:YES];
    
    dispatch_async(_imageQueue, ^{
        int minHessian = 400;
        
        cv::FeatureDetector detector;
        cv::DescriptorExtractor extractor;
        std::vector<cv::KeyPoint> keypoints;
        cv::Mat mat;
        cv::Mat descriptors;//, descriptors1;
        
        mat = [self cvMatGrayFromUIImage:image];
        
        detector.detect(mat, keypoints);
        extractor.compute(mat, keypoints, descriptors);
        
        NSLog(@"descriptors - %d, %d", descriptors.rows, descriptors.cols);
        
 
 
 //cv::FlannBasedMatcher matcher;
         std::vector<cv::DMatch> matches;
         int i,j,k,n;
         float ratio = 0.0;
         
         for (i=1; i<kImageCount; i++) {
         
         float minDist = 100000.0;
         for (j=0; j<matches.size(); j++) {
         float dist = matches[j].distance;
         if (dist<minDist) {
         minDist = dist;
         }
         }
         
         k = 0;
         minDist *= 2.0f;
         for (j=0; j<matches.size(); j++) {
         if (matches[j].distance<minDist) {
         k++;
         }
         }
         
         if (matches.size()>0) {
         float r = 1.0f * k / matches.size();
         NSLog(@"i = %d, minDist = %f, k = %d, ration = %f", i, minDist, k, r);
         if (r>ratio) {
         n = i;
         ratio = r;
         }
         }
         }
         
   //      NSLog(@"Best match - %d, ratio = %f", n, ratio);
 


        cv::Mat indices;
        cv::Mat dists;
        
        cv::flann::KDTreeIndexParams indexParams(5);
        cv::flann::Index kdtree(_features, indexParams);
        
        kdtree.knnSearch(descriptors, indices, dists, 2, cv::flann::SearchParams(64));
        
        std::vector<int> matchPoints(kImageCount, 0);
        std::vector<int>::iterator begin = _indexes.begin();
        std::vector<int>::iterator end = _indexes.end();
        std::vector<int>::iterator iter;
        
        int i,j,k;
        for (i=0; i<indices.rows; i++) {
            if (dists.at<float>(i, 0) < 0.6f * dists.at<float>(i, 1)) {
                k = indices.at<int>(i, 0);
                iter = std::upper_bound(begin, end, k);
                if (iter!=end) {
                    j = (int)(iter - begin) - 1;
                    matchPoints[j]++;
                }
                //else {
                 //matchPoints[kImageCount-1]++;
                 //}
            }
        }
        
        k = 0;
        for (i=0; i<matchPoints.size(); i++) {
            if (matchPoints[i]>k) {
                k = matchPoints[i];
                j = i;
            }
        }
        
        NSLog(@"match image - %d, number of match points - %d", j, k);
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [_HUD hide:YES];
            
            [self didCompareWithMatchImageIndex:j numberMatchPoints:k];
        });
    });
}

- (void)didCompareWithMatchImageIndex:(NSInteger)index numberMatchPoints:(NSInteger)number
{
    if (number>10) {

        std::string filename = _filenames[index];
        NSString *file = [NSString stringWithUTF8String:filename.c_str()];
        NSLog(@"filename - %@", file);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Find similar image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        //viewController.index = index;
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Could not find similar image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
*/
#pragma mark - Imagepicker Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *img1 = [[UIImage alloc] init];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        img1 = info[UIImagePickerControllerOriginalImage];
        
    }
    
    
    //    [self Compare:img1 secondImage:properlyRotatedImage];
    
//    [self compareWithImage:img1];
    [AlertView showProgress];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            [self CompareImage:img1 :img2];
                        [self removeindicator:properlyRotatedImage];
            
        });
        
    });
    [AlertView hideAlert];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}




//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//
//    UIImage *img1 = [[UIImage alloc] init];
//    UIImage *img2 = [[UIImage alloc] init];
//    
//    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
//    {
//        img1 = info[UIImagePickerControllerOriginalImage];
//        
//    }
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
//    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
//
//    float lat = [[NSUserDefaults standardUserDefaults]floatForKey:@"Lattitude"];
//    float lon = [[NSUserDefaults standardUserDefaults]floatForKey:@"Longitude"];
//
//    NSLog(@"%f ,%f",lat,lon);
//
//    [parameters setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"strLatitude"];
//    [parameters setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"strLongitude"];
//    [Request makeRequestWithIdentifier:SEARCH_LATLONG parameters:parameters delegate:self.homeViewController];
//
//
//}



/*
-(NSMutableArray*)getImageBinary:(UIImage*)ImageToCompare
{
    int i = 0;
    int step = 4;
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    //void * bitmapData;
    //int bitmapByteCount;
    int bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(ImageToCompare.CGImage);
    size_t pixelsHigh = CGImageGetHeight(ImageToCompare.CGImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (pixelsWide * 4);
    NSMutableArray *firstImagearray=[[NSMutableArray alloc]init];
    
    //bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return nil;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    //bitmapData = malloc( bitmapByteCount );
    //  if (bitmapData == NULL)
    //  {
    //      fprintf (stderr, "Memory not allocated!");
    //      CGColorSpaceRelease( colorSpace );
    //      return NULL;
    //  }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (NULL,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits        per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL)
    {
        //free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    CGRect rect = {{0,0},{pixelsWide, pixelsHigh}};
    //
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, rect, ImageToCompare.CGImage);
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    /////**********
    size_t _width = CGImageGetWidth(ImageToCompare.CGImage);
    size_t _height = CGImageGetHeight(ImageToCompare.CGImage);
    
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data != NULL)
    {
        int max = _width * _height * 4;
        
        for (i = 0; i < max; i+=step)
        {
            [firstImagearray addObject:[NSNumber numberWithInt:data[i + 0]]];
            [firstImagearray addObject:[NSNumber numberWithInt:data[i + 1]]];
            [firstImagearray addObject:[NSNumber numberWithInt:data[i + 2]]];
            [firstImagearray addObject:[NSNumber numberWithInt:data[i + 3]]];     }
    }
    
    if (context == NULL)
        // error creating context
        return nil;
    
    
    //if (data) { free(data); }
    if (context) {
        CGContextRelease(context);
    }
    return firstImagearray;
}

-(BOOL)Compare:(UIImage*)ImageToCompare secondImage:(UIImage*)secondImage
{
    CGFloat width =100.0f;
    CGFloat height=100.0f;
    for (int i =0; i<imageArr.count; i++)
    {
        CGSize newSize1 = CGSizeMake(width, height); //whaterver size
        UIGraphicsBeginImageContext(newSize1);
        [[imageArr objectAtIndex:i] drawInRect:CGRectMake(0, 0, newSize1.width, newSize1.height)];
        ImageToCompare = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //        UIImageView *imageview_camera=(UIImageView *)[self.view viewWithTag:-3];
        
        
        CGSize newSize2 = CGSizeMake(width, height); //whaterver size
        UIGraphicsBeginImageContext(newSize2);
        [secondImage  drawInRect:CGRectMake(0, 0, newSize2.width, newSize2.height)];
        secondImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
        
        NSArray *first=[[NSArray alloc] initWithArray:(NSArray *)[self    getImageBinary:ImageToCompare]];
        NSArray *second=[[NSArray alloc] initWithArray:(NSArray *)[self getImageBinary:secondImage]];
        
        for (int x=0; x<first.count; x++)
        {
            if ([((NSNumber*)[first objectAtIndex:x]) intValue] ==[((NSNumber*)[second objectAtIndex:x]) intValue])
            {
                NSLog(@"Images are Same");
            }
            else
            {
                return NO;
            }
        }
    }
    
    
    
//    ImageToCompare=[ImageToCompare  scaleToSize:CGSizeMake(100,100)];
//    secondImage=[secondImage scaleToSize:CGSizeMake(self.appdelegate.ScreenWidth, self.appdelegate.ScreenHeigth)];
    
   
    return YES;
}
*/


//+ (COLOR_HSV)hsvFromRgb:(COLOR_RGB)col {
//    
//    COLOR_HSV ret;
//    
//    CGFloat min, max, delta;
//    
//    NSNumber *r = [NSNumber numberWithFloat:col.r];
//    NSNumber *g = [NSNumber numberWithFloat:col.g];
//    NSNumber *b = [NSNumber numberWithFloat:col.b];
//    
//    min = [LMFunctions minValueInArray:[NSArray arrayWithObjects:r, g, b, nil] withIndex:NULL];
//    max = [LMFunctions maxValueInArray:[NSArray arrayWithObjects:r, g, b, nil] withIndex:NULL];
//    delta = max - min;
//    
//    ret.v = max;
//    
//    if (max != 0) {
//        ret.s = delta/max;
//    } else {
//        // r = g = b = 0, thus s = 0, v = undefined.
//        ret.s = 0;
//        ret.h = 0;
//        ret.v = 0;
//        return ret;
//    }
//    
//    if (delta != 0) { // To avoid division-by-zero error.
//        if (col.r == max) {
//            ret.h = (col.g - col.b) / delta;        // Between yellow and magenta.
//        } else if (col.g == max) {
//            ret.h = 2 + (col.b - col.r) / delta;    // Between cyan and yellow.
//        } else {
//            ret.h = 4 + (col.r - col.g) / delta;    // Between magenta and cyan.
//        }
//        ret.h *= 60.0f; // Degrees.
//        if (ret.h < 0) {
//            ret.h += 360.0f;
//        }
//    } else {
//        ret.h = 0;
//    }
//    
//    
//    ret.s *= 100.0f;
//    ret.v *= 100.0f;
//    
//    return ret;
//}
//


/*- (UIImage*) rotateImageAppropriately:(UIImage*)imageToRotate
{
    
    CGImageRef imageRef = [imageToRotate CGImage];
    
    if (imageToRotate.imageOrientation == 0)
    {
        properlyRotatedImage = imageToRotate;
    }
    else if (imageToRotate.imageOrientation == 3)
    {
        
        CGSize imgsize = imageToRotate.size;
        UIGraphicsBeginImageContext(imgsize);
        [imageToRotate drawInRect:CGRectMake(0.0, 0.0, imgsize.width, imgsize.height)];
        properlyRotatedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else if (imageToRotate.imageOrientation == 1)
    {
        properlyRotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:1];
    }
    
    return properlyRotatedImage;
}
*/



- (void)connection:(Connection *)connection didReceiveData:(id)data
{
    
    if([data isKindOfClass:[NSString class]])
    {
        data = [data jsonValue];
    }
    NSMutableArray *dataImages = [[NSMutableArray alloc]init];
    NSMutableArray *heritageBuild = [[NSMutableArray alloc]init];
    heritageBuild = [NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];
    UIImage *img2 = [[UIImage alloc] init];

    for (int i =0; i < heritageBuild.count; i++)
    {
        HeritagePlace *place = [heritageBuild objectAtIndex:i];
        
//        NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",ROOT_URL,place.heritagebuildinginfoguid, place.thumbnailphoto]];
        
        NSString *str = [NSString stringWithFormat:@"%@",place.image];
        NSString *str1 = [NSString stringWithFormat:@"%@",place.heritagebuildinginfoguid];
//        NSString *str1 = [(HeritagePlace *)self.detailObject heritagebuildinginfoguid];
        NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"uploadedFiles/%@/%@",str1, str]];
        
//        [dataImages addObject:url];
        NSData *test = [NSData dataWithContentsOfURL:url];
        if (test != nil)
        {
            img2 = [UIImage imageWithData:test];

        } else {
            img2 = [UIImage imageNamed:@"thumb_stub"];

        }
        [imageArr addObject:img2];
    }
    

    [AlertView hideAlert];


}
-(void)removeindicator :(UIImage *)image1
{
    CGFloat percentage_similar;
    for (int i =0; i < imageArr.count; i++)
    {
        CGFloat width =100.0f;
        CGFloat height=100.0f;
        
        CGSize newSize1 = CGSizeMake(width, height); //whaterver size
        UIGraphicsBeginImageContext(newSize1);
        [[imageArr objectAtIndex:i] drawInRect:CGRectMake(0, 0, newSize1.width, newSize1.height)];
        UIImage *newImage1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
        //        UIImageView *imageview_camera=(UIImageView *)[self.view viewWithTag:-3];
        
        
        CGSize newSize2 = CGSizeMake(width, height); //whaterver size
        UIGraphicsBeginImageContext(newSize2);
        [image1  drawInRect:CGRectMake(0, 0, newSize2.width, newSize2.height)];
        UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        float numDifferences = 0.0f;
        float totalCompares = width * height;
        
        NSArray *img1RGB=[[NSArray alloc]init];
        NSArray *img2RGB=[[NSArray alloc]init];
        
        for (int yCoord = 0; yCoord < height; yCoord += 1)
        {
            for (int xCoord = 0; xCoord < width; xCoord += 1)
            {
                img1RGB = [self getRGBAsFromImage:newImage1 atX:xCoord andY:yCoord];
                img2RGB = [self getRGBAsFromImage:newImage2 atX:xCoord andY:yCoord];
                
                if (([[img1RGB objectAtIndex:0]floatValue] - [[img2RGB objectAtIndex:0]floatValue]) == 0 || ([[img1RGB objectAtIndex:1]floatValue] - [[img2RGB objectAtIndex:1]floatValue]) == 0 || ([[img1RGB objectAtIndex:2]floatValue] - [[img2RGB objectAtIndex:2]floatValue]) == 0)
                {
                    //one or more pixel components differs by 10% or more
                    numDifferences++;
                }
            }
        }
        
        // It will show result in percentage at last
        percentage_similar=((numDifferences*100)/totalCompares);
        if (percentage_similar<=100.0f)
        {
            //        str=[[NSString alloc]initWithString:[NSString stringWithFormat:@"%i%@ Identical", (int)((numDifferences*100)/totalCompares),@"%"]];
            
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"i-App" message:[NSString stringWithFormat:@"Images are same"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertview show];
            return;
            
        }
        //        NSString *str=NULL;
        
    }
    
    
    if (percentage_similar < 100.0f) {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"i-App" message:[NSString stringWithFormat:@" Images are not same"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertview show];
    }
    
}

-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy
{
    //NSArray *result = [[NSArray alloc]init];
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    //    for (int ii = 0 ; ii < count ; ++ii)
    //    {
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    //CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    byteIndex += 4;
    
    // UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    //}
    free(rawData);
    
    NSArray *result = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:red],
                       [NSNumber numberWithFloat:green],
                       [NSNumber numberWithFloat:blue],nil];
    
    return result;
}


/*
-(void)opencvImageCompare{
    NSMutableArray *valuesArray=[[NSMutableArray alloc]init];
    IplImage *img = [self CreateIplImageFromUIImage:imageView.image];
    // always check camera image
    if(img == 0) {
        printf("Cannot load camera img");
        
    }
    
    IplImage  *res;
    CvPoint   minloc, maxloc;
    double    minval, maxval;
    double values;
    
    UIImage *imageTocompare = [UIImage imageNamed:@"MyImageName"];
    IplImage *imageTocompareIpl = [self CreateIplImageFromUIImage:imageTocompare];
    // always check server image
    if(imageTocompareIpl == 0) {
        printf("Cannot load serverIplImageArray image");
    }
    if(img->width-imageTocompareIpl->width<=0 && img->height-imageTocompareIpl->height<=0){
        int balWidth=imageTocompareIpl->width-img->width;
        int balHeight=imageTocompareIpl->height-img->height;
        img->width=img->width+balWidth+100;
        img->height=img->height+balHeight+100;
    }
    
    
    
    CvSize size = cvSize(
                         img->width  - imageTocompareIpl->width  + 1,
                         img->height - imageTocompareIpl->height + 1
                         );
    
    res = cvCreateImage(size, IPL_DEPTH_32F, 1);
    
    // CV_TM_SQDIFF CV_TM_SQDIFF_NORMED
    // CV_TM_CCORR  CV_TM_CCORR_NORMED
    // CV_TM_CCOEFF CV_TM_CCOEFF_NORMED
    
    cvMatchTemplate(img, imageTocompareIpl, res,CV_TM_CCOEFF);
    cvMinMaxLoc(res, &minval, &maxval, &minloc, &maxloc, 0);
    printf("\n value %f", maxval-minval);
    values=maxval-minval;
    NSString *valString=[NSString stringWithFormat:@"%f",values];
    [valuesArray addObject:valString];
    weedObject.values=[valString doubleValue];
    printf("\n------------------------------");
    
    cvReleaseImage(&imageTocompareIpl);
    
    cvReleaseImage(&res);
    cvReleaseImage(&img);
    
}
*/


/*
- (UIImage *)CompareImages :(UIImage *)img1 :(UIImage *)img2
{
    CGFloat percentage_similar;
    for (int i =0; i < imageArr.count; i++)
    {
        CGFloat width =100.0f;
        CGFloat height=100.0f;
        
        CGSize newSize1 = CGSizeMake(width, height); //whaterver size
        UIGraphicsBeginImageContext(newSize1);
        [[imageArr objectAtIndex:i] drawInRect:CGRectMake(0, 0, newSize1.width, newSize1.height)];
        UIImage *newImage1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //        UIImageView *imageview_camera=(UIImageView *)[self.view viewWithTag:-3];
        
        
        CGSize newSize2 = CGSizeMake(width, height); //whaterver size
        UIGraphicsBeginImageContext(newSize2);
        [img1  drawInRect:CGRectMake(0, 0, newSize2.width, newSize2.height)];
        UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        float numDifferences = 0.0f;
        float totalCompares = width * height;
        
        NSArray *img1RGB=[[NSArray alloc]init];
        NSArray *img2RGB=[[NSArray alloc]init];
        
        for (int yCoord = 0; yCoord < height; yCoord += 1)
        {
            for (int xCoord = 0; xCoord < width; xCoord += 1)
            {
                img1RGB = [self getRGBAsFromImage:newImage1 atX:xCoord andY:yCoord];
                img2RGB = [self getRGBAsFromImage:newImage2 atX:xCoord andY:yCoord];
                
                if (([[img1RGB objectAtIndex:0]floatValue] - [[img2RGB objectAtIndex:0]floatValue]) == 0 || ([[img1RGB objectAtIndex:1]floatValue] - [[img2RGB objectAtIndex:1]floatValue]) == 0 || ([[img1RGB objectAtIndex:2]floatValue] - [[img2RGB objectAtIndex:2]floatValue]) == 0)
                {
                    //one or more pixel components differs by 10% or more
                    numDifferences++;
                }
            }
        }
        
        // It will show result in percentage at last
        percentage_similar=((numDifferences*100)/totalCompares);
        //        NSString *str=NULL;
        
        if (percentage_similar>=10.0f)
        {
            //        str=[[NSString alloc]initWithString:[NSString stringWithFormat:@"%i%@ Identical", (int)((numDifferences*100)/totalCompares),@"%"]];
            
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"i-App" message:[NSString stringWithFormat:@"Images are same"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertview show];
            
        }
        
    }
    if (percentage_similar<= 10.0f) {
        
            //        str=[[NSString alloc]initWithString:[NSString stringWithFormat:@"Result: %i%@ Identical",(int)((numDifferences*100)/totalCompares),@"%"]];
            
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"i-App" message:[NSString stringWithFormat:@" Images are not same"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertview show];
        
    }
    
    
    return img1;
}







-(UIImage *)CompareImage:(UIImage*)image :(UIImage*)ImageforFrameCompare
{
    CGImageRef cgimage = image.CGImage;
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    size_t bpr = CGImageGetBytesPerRow(cgimage);
    size_t bpp = CGImageGetBitsPerPixel(cgimage);
    size_t bpc = CGImageGetBitsPerComponent(cgimage);
    size_t bytes_per_pixel = bpp / bpc;
    /*CGBitmapInfo info = CGImageGetBitmapInfo(cgimage);
     NSLog(
     @"\n"
     "===== %@ =====\n"
     "CGImageGetHeight: %d\n"
     "CGImageGetWidth:  %d\n"
     "CGImageGetColorSpace: %@\n"
     "CGImageGetBitsPerPixel:     %d\n"
     "CGImageGetBitsPerComponent: %d\n"
     "CGImageGetBytesPerRow:      %d\n"
     "CGImageGetBitmapInfo: 0x%.8X\n"
     "  kCGBitmapAlphaInfoMask     = %s\n"
     "  kCGBitmapFloatComponents   = %s\n"
     "  kCGBitmapByteOrderMask     = %s\n"
     "  kCGBitmapByteOrderDefault  = %s\n"
     "  kCGBitmapByteOrder16Little = %s\n"
     "  kCGBitmapByteOrder32Little = %s\n"
     "  kCGBitmapByteOrder16Big    = %s\n"
     "  kCGBitmapByteOrder32Big    = %s\n",
     @"Image",
     (int)width,
     (int)height,
     CGImageGetColorSpace(cgimage),
     (int)bpp,
     (int)bpc,
     (int)bpr,
     (unsigned)info,
     (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
     (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
     (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
     (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
     (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
     (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
     (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
     (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"
     );*/

/*
    CGDataProviderRef provider = CGImageGetDataProvider(cgimage);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    char* bytes = (char *) [data bytes];
    char* pixel;
    CGDataProviderRef frameImage = CGImageGetDataProvider(ImageforFrameCompare.CGImage);
    NSData* frameImagedata = (id)CFBridgingRelease(CGDataProviderCopyData(frameImage));
    char* bytes1 = (char *)[frameImagedata bytes];
    char* pixelNew;
    for(size_t row = 0; row < height; row++)
    {
        for(size_t col = 0; col < width; col++)
        {
            pixel = &bytes[row * bpr + col * bytes_per_pixel];
            pixelNew = &bytes1[row * bpr + col * bytes_per_pixel];
            if (pixelNew[3] != 0x00)
            {
                pixel[0] = 0x00;
                pixel[1] = 0x00;
                pixel[2] = 0x00;
                pixel[3] = 0x00;
            }
        }
    }
    CGImageRef newImageRef ;
    CGColorSpaceRef colorspace  = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo     = CGImageGetBitmapInfo(cgimage);
    CGDataProviderRef providerNew  = CGDataProviderCreateWithData(NULL, bytes, [data length], NULL);
    newImageRef      = CGImageCreate (
                                      width,
                                      height,
                                      bpc,
                                      bpp,
                                      bpr,
                                      colorspace,
                                      bitmapInfo,
                                      providerNew,
                                      NULL,
                                      false,
                                      kCGRenderingIntentDefault
                                      );
    image = [UIImage imageWithCGImage:newImageRef];
    return image;
}

#pragma mark - Sample

//- (bool)isTheImage:(UIImage *)image1 apparentlyEqualToImage:(UIImage *)image2 accordingToRandomPixelsPer1:(float)pixelsPer1
//{
//    if (!CGSizeEqualToSize(image1.size, image2.size))
//    {
//        return false;
//    }
//
//    int pixelsWidth = CGImageGetWidth(image1.CGImage);
//    int pixelsHeight = CGImageGetHeight(image1.CGImage);
//
//    int pixelsToCompare = pixelsWidth * pixelsHeight * pixelsPer1;
//
//    uint32_t pixel1;
//    CGContextRef context1 = CGBitmapContextCreate(&pixel1, 1, 1, 8, 4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);
//    uint32_t pixel2;
//    CGContextRef context2 = CGBitmapContextCreate(&pixel2, 1, 1, 8, 4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipFirst);
//
//    bool isEqual = true;
//
//    for (int i = 0; i < pixelsToCompare; i++)
//    {
//        int pixelX = arc4random() % pixelsWidth;
//        int pixelY = arc4random() % pixelsHeight;
//
//        CGContextDrawImage(context1, CGRectMake(-pixelX, -pixelY, pixelsWidth, pixelsHeight), image1.CGImage);
//        CGContextDrawImage(context2, CGRectMake(-pixelX, -pixelY, pixelsWidth, pixelsHeight), image2.CGImage);
//
//        if (pixel1 != pixel2)
//        {
//            isEqual = false;
//            break;
//        }
//    }
//    CGContextRelease(context1);
//    CGContextRelease(context2);
//
//    return isEqual;
//}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    return UIInterfaceOrientationIsPortrait(orientation);
//}


//    NSData *imgData = UIImageJPEGRepresentation(img1, 1);
//    jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Test.png"]];
//    [imgData writeToFile:jpgPath atomically:YES];


//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//        [_locationManager requestWhenInUseAuthorization];
//
//    [_locationManager startUpdatingLocation];

//    if(IS_OS_8_OR_LATER)
//    {
//        [self.locationManager requestAlwaysAuthorization];
//    }
//
//    [self.locationManager startUpdatingLocation];


//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
//    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
//
////    [[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.latitude forKey:@"Lattitude"];
////    [[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.longitude forKey:@"Longitude"];
//
//    float lat = [[NSUserDefaults standardUserDefaults]floatForKey:@"Lattitude"];
//    float lon = [[NSUserDefaults standardUserDefaults]floatForKey:@"Longitude"];
//
//    NSLog(@"%f ,%f",lat,lon);
//
//    [parameters setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"strLatitude"];
//    [parameters setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"strLongitude"];
//    [Request makeRequestWithIdentifier:SEARCH_LATLONG parameters:parameters delegate:self.homeViewController];
//
//    id data;
//    if([data isKindOfClass:[NSString class]])
//    {
////        data = [data jsonValue];
//        NSLog(@"the data %@", data);
//    }
//

//   NSMutableArray *dataImages = [NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];


//    NSDictionary *data1= [[NSDictionary alloc]init];



//
//     imageArr= [array valueForKey:@"Photo"];

*/
@end
