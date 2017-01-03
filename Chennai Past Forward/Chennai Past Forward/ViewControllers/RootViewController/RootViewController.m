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
#import "Reachability.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue])

#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDevice+IdentifierAddition.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HeritagePlace.h"
#import "NSObject+Parser.h"
#import "Photo.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImage+Resize.h"

NSInteger const kImageCount = 18;
@interface RootViewController ()
{
    UIView *rootView;
    NSString *jpgPath;
    NSMutableArray *imageArr;
    UIImage* properlyRotatedImage;
    
    CGFloat redLeft,GreenLeft,BlueLeft;
    CGFloat redRight,GreenRight,BlueRight;

    NSMutableArray *array;
    NSMutableArray *AdditionalPhotos;
    UIImage *img2 ;
    
    bool _queryingImage;
    dispatch_queue_t _imageQueue;

    NSMutableArray *heritageBuild;

    CLLocationManager *locationmanager;
    CraftARSDK *_sdk;
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
    //afterDelay:[[NSUserDefaults standardUserDefaults] integerForKey:@"gpsInterval"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *showintro = [defaults objectForKey:@"showintro"];
    NSLog(@"ShowIntro  root Value:%@",showintro);
    if (![showintro isEqualToString:@"yes"])
    {
        [self introductionview];
    }
    
    
    heritageBuild  = [[NSMutableArray alloc]init];
    locationmanager = [[CLLocationManager alloc] init];
    locationmanager.delegate = self;
    locationmanager.distanceFilter = kCLDistanceFilterNone;
    locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationmanager requestWhenInUseAuthorization];
    
    //[locationmanager startUpdatingLocation];
    

    
    //////
    
    
    
}

-(void)introductionview
{
    if (IPAD) {
        EAIntroPage *page1 = [EAIntroPage page];
        page1.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help01"];
        page1.title=@"";
        
//        EAIntroPage *page2 = [EAIntroPage page];
//        page2.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help02"];
//        page2.title=@"";
//        page2.onPageDidAppear = ^{
//            NSLog(@"");
//        };
//        
//        EAIntroPage *page3 = [EAIntroPage page];
//        page3.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help03"];
//        page3.title=@"";
//        
//        EAIntroPage *page4 = [EAIntroPage page];
//        page4.bgImage = [UIImage imageNamed:@"iPad_768X1004_Help04"];
//        page4.title=@"";
        
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds];
        [intro setDelegate:self];
       // [intro setPages:@[page1,page2,page3,page4]];
        [intro setPages:@[page1]];
        [intro showInView:rootView animateDuration:0.3];
    }
    else
    {
        EAIntroPage *page1 = [EAIntroPage page];
        page1.bgImage = [UIImage imageNamed:@"rsz_11600x2560_help01"];
        page1.title=@"";
        
//        EAIntroPage *page2 = [EAIntroPage page];
//        page2.bgImage = [UIImage imageNamed:@"1600x2560_help02"];
//        page2.title=@"";
//        page2.onPageDidAppear = ^{
//            NSLog(@"");
//        };
//        
//        EAIntroPage *page3 = [EAIntroPage page];
//        page3.bgImage = [UIImage imageNamed:@"1600x2560_help03"];
//        page3.title=@"";
//        
//        EAIntroPage *page4 = [EAIntroPage page];
//        page4.bgImage = [UIImage imageNamed:@"1600x2560_help04"];
//        page4.title=@"";
        
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds];
        [intro setDelegate:self];
        //[intro setPages:@[page1,page2,page3,page4]];
        [intro setPages:@[page1]];
        
        [intro showInView:rootView animateDuration:0.3];
        
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [_sdk stopCapture];
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
    
    //[AlertView showAlertMessage:[NSString stringWithFormat:@"Count:%lu Push Message:%@",(unsigned long)[self.viewControllers count],Push_Msg]];
    
    //[self.viewControllers count]>=3 &&
    
    if([Push_Msg isEqualToString:@"Y"])
    {
        //[AlertView showAlertMessage:[NSString stringWithFormat:@"Push :%lu",(unsigned long)[self.viewControllers count]]];
        UIViewController *viewController =[[RootViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"PushMsg"];
        UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
        window.rootViewController = viewController;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([self.viewControllers count] > 1)
    {
        //[AlertView showAlertMessage:[NSString stringWithFormat:@"Default :%lu",(unsigned long)[self.viewControllers count]]];
        [self popViewController:[self.viewControllers lastObject] animated:YES];
    }
    else
    {
        if([self connected])
        {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
        [Request makeRequestWithIdentifier:MESSAGEBOX_INFO parameters:parameters delegate:self.homeViewController];
        [AlertView showProgress];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Past Forward" message:@"Not available in offline mode" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


- (IBAction)menuButtonTapped:(id)sender
{
    
    [self.searchTextField resignFirstResponder];
     NSArray *items = [NSArray arrayWithObjects:@"HERITAGE", @"ARTICLES", @"SETTINGS", nil];
    self.actionSheet = [[ActionSheetViewController alloc] initWithButtonTitles:items];
    self.actionSheet.delegate = (id<ActionSheetDelegate>)self;
    [self.view addSubview:_actionSheet.view];

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

//- (void)connection:(Connection *)connection didReceiveData:(id)data
//{
//    imageArr = [[NSMutableArray alloc]init];
//
//    if([data isKindOfClass:[NSString class]])
//    {
//        data = [data jsonValue];
//    }
//    AdditionalPhotos = [[NSMutableArray alloc]init];
//    heritageBuild = [NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];
//    AdditionalPhotos = [NSMutableArray arrayWithArray:[self parseAdditionalPhotos:data]];
//
//    
//    
//    
//    img2 = [[UIImage alloc] init];
////    
//    for (int i =0; i < AdditionalPhotos.count; i++)
//    {
//        Photo *place = [AdditionalPhotos objectAtIndex:i];
//        NSString *str = [NSString stringWithFormat:@"%@",place.name];
//        NSString *str1 = [NSString stringWithFormat:@"%@",place.guid];
//        NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"uploadedFiles/%@/%@",str1, str]];
//        NSData *test = [NSData dataWithContentsOfURL:url];
//        img2 = [UIImage imageWithData:test];
//        
//        [imageArr addObject:img2];
//    }

//    array = [[NSMutableArray alloc]init];
//    for (int i =0; i < AdditionalPhotos.count; i++)
//    {
//        //        UIImage *img2 = [[UIImage alloc] init];
//        NSURL *u = [AdditionalPhotos objectAtIndex:i];
//        NSData *test = [NSData dataWithContentsOfURL:u];
//        if (test != nil)
//        {
//            img2 = [UIImage imageWithData:test];
//            
//        } else {
//            img2 = [UIImage imageNamed:@"thumb_stub"];
//            
//        }
//        [array addObject:img2];
//    }

    
    
//    for (int i =0; i < heritageBuild.count; i++)
//    {
//        HeritagePlace *place = [heritageBuild objectAtIndex:i];
//        NSString *str = [NSString stringWithFormat:@"%@",place.image];
//        NSString *str1 = [NSString stringWithFormat:@"%@",place.heritagebuildinginfoguid];
//        NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"uploadedFiles/%@/%@",str1, str]];
//        [imageArr addObject:url];
//    }
//    
//    array = [[NSMutableArray alloc]init];
//    for (int i =0; i < imageArr.count; i++)
//    {
////        UIImage *img2 = [[UIImage alloc] init];
//        
//        NSData *test = [NSData dataWithContentsOfURL:[imageArr objectAtIndex:i]];
//        if (test != nil)
//        {
//            img2 = [UIImage imageWithData:test];
//            
//        } else {
//            img2 = [UIImage imageNamed:@"thumb_stub"];
//            
//        }
//        [array addObject:img2];
//    }
    
    
//    NSLog(@"Image Array Count %lu",(unsigned long)imageArr.count);
//    
//    [AlertView hideAlert];
//}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(UIImageOrientationUp){
        case UIImageOrientationDown:           /* EXIF = 3 */
        case UIImageOrientationDownMirrored:   /* EXIF = 4 */
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           /* EXIF = 6 */
        case UIImageOrientationLeftMirrored:   /* EXIF = 5 */
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          /* EXIF = 8 */
        case UIImageOrientationRightMirrored:  /* EXIF = 7 */
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default: break;
    }
    switch(UIImageOrientationDown){
        case UIImageOrientationUpMirrored:     /* EXIF = 2 */
        case UIImageOrientationDownMirrored:   /* EXIF = 4 */
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   /* EXIF = 5 */
        case UIImageOrientationRightMirrored:  /* EXIF = 7 */
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default: break;
    }
    return transform;
}
- (UIImage *)resizedImage:(CGSize)newSize  transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
//    CGImageRef imgRef = newRect;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil];
    CGImageRef imageRef = [[[UIImage alloc]initWithContentsOfFile:imagePath]CGImage];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef), 0,CGImageGetColorSpace(imageRef),CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}




@end
