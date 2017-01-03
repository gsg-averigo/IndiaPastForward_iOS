//
//  PreviewViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 11/01/16.
//  Copyright (c) 2016 Harish. All rights reserved.
//

#import "PreviewViewController.h"
#import "DetailViewController.h"
#import "KGModal.h"
#import "HeritagePlace.h"
#import "Request.h"
#import "UIDevice+IdentifierAddition.h"
#import "EditableViewController.h"
#import "ScribblingViewController.h"
#import "UIView+Frame.h"
#import <objc/message.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface PreviewViewController ()
{
    UIButton *backBtn ;
    NSInteger j;
    NSString *jpgPath;
    BOOL isLandScape;
}
@end

@implementation PreviewViewController
@synthesize isPresented;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (IPAD)
    {
        self = [super initWithNibName:@"PreviewViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"PreviewViewController" bundle:nil];
    }
    
    if(self){
         isPresented = YES;
//         [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        
    }
    return self;
}

- (void)viewDidLoad {
    
    alertAction.hidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
     self.rootViewController.self.topvew.hidden = YES;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI/2);
    self.view.transform = transform;
    
    // Repositions and resizes the view.
    // If you need NavigationBar on top then set height appropriately
    NSString *PushGuid=[[NSUserDefaults standardUserDefaults]objectForKey:@"PushGUID"];
    if(PushGuid)
    {
        CGRect contentRect = CGRectMake(-30,0, self.view.frame.size.height-70, self.view.frame.size.width);
        self.view.bounds = contentRect;
    }
    else
    {
        CGRect contentRect;
        if(IPAD)
        {
         contentRect   = CGRectMake(0,0, self.view.frame.size.height, self.view.frame.size.width);
        }
        else
        {
         contentRect = CGRectMake(-240,0, self.view.frame.size.height, self.view.frame.size.width);
        }
        self.view.bounds = contentRect;
    }
   
    NSLog(@"%f", self.view.frame.size.width);
    
    
//        [tempImg setImageWithURL:_imgUrl placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"] options:SDWebImageRefreshCached];
    

        tempTxtView.text =[self stringByStrippingHTML];
    tempTxtView.editable = YES;
    if(IPAD)
    {
        tempTxtView.font = [UIFont fontWithName:@"Arial" size:20];
    }
    else
    {
        tempTxtView.font = [UIFont fontWithName:@"Arial" size:14];
    }
    tempTxtView.editable = NO;
    
    tempName.text = _name;
    
    self.rootViewController.hidesBottomBarWhenPushed = YES;
         
    j =[[NSUserDefaults standardUserDefaults] integerForKey:@"Preview"];
    
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"Preview"]==1 )
    {
        writingView.hidden = NO;
        drawingView.hidden = YES;
        tempText.text =_moretext;
        //tempText.lineBreakMode = NSLineBreakByWordWrapping;
        tempText.editable = YES;
        if(IPAD)
        {
        tempText.font = [UIFont fontWithName:@"Arial" size:20];
        }
        else
        {
        tempText.font = [UIFont fontWithName:@"Arial" size:14];
        }
        tempText.editable = NO;
        NSLog(@"writing ");
        
       
    }
    else
    {
        writingView.hidden = YES;
        drawingView.hidden = NO;
        if(self.heritagePlaces.count!=0)
        {
        tempImgView1.image = [UIImage imageWithData:_data1];
        }
        else{
      tempImgView1.image = [UIImage imageNamed:_imgUrl];
        }
        
    }
    isLandScape = NO;
   

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(handleSingleTapGesture:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];

//    [webView addGestureRecognizer:tap];
    
}

- (void) alignLabelWithTop:(UILabel *)label {
    CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
    label.adjustsFontSizeToFitWidth = NO;
    
    // get actual height
    CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
    CGRect rect = label.frame;
    rect.size.height = actualSize.height;
    label.frame = rect;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Menu View

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
    [self ActionMenu];
    
}
- (IBAction)presentMenuButtonTapped:(UIButton *)sender {
    
    int i =200;
    [[NSUserDefaults standardUserDefaults]setInteger:i forKey:@"Share"];
    [self ActionMenu];
}

-(void)ActionMenu
{
    CGContextRef ctx = NULL;
    imageScreenshot=[UIImage imageNamed:@""];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    // grab reference to our window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // transfer content into our context
    [window.layer renderInContext:ctx];
    imageScreenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSData *imgData = UIImageJPEGRepresentation(imageScreenshot, 1);
    jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.png",_name]];
    [imgData writeToFile:jpgPath atomically:YES];
    
    NSLog(@" %@",imageScreenshot);
    alertAction.hidden = NO;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
    contentView.backgroundColor=[UIColor blackColor];
    CGRect welcomeLabelRect = contentView.bounds;
    contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    UIFont *titleLabelFont = [UIFont boldSystemFontOfSize:12];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    titleLabel.frame = CGRectMake(10, 0, 70, 40);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font = titleLabelFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text=@"Share";
    [contentView addSubview:titleLabel];
    
    
    UIButton *fbBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 40, 32, 32)];
    UIImage *btnImage = [UIImage imageNamed:@"facebook.png"];
    [fbBtn setImage:btnImage forState:UIControlStateNormal];
    [fbBtn addTarget:self action:@selector(fbShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:fbBtn];
    
    
    UIButton *gmailBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 90, 32, 32)];
    UIImage *btnImage1 = [UIImage imageNamed:@"btn_mailshare.png"];
    [gmailBtn setImage:btnImage1 forState:UIControlStateNormal];
    [gmailBtn addTarget:self action:@selector(gmailShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:gmailBtn];
    
    backBtn= [[UIButton alloc]initWithFrame:CGRectMake(25, 145, 32, 32)];
    UIImage *btnImage2 = [UIImage imageNamed:@"btn_back.png"];
    [backBtn setImage:btnImage2 forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:backBtn];
    
    
    
    UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowRadius = 5.0;
    shadowView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    shadowView.layer.shadowOpacity = 1.0;
    [shadowView addSubview: contentView];
    
    contentView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:NO];
}



#pragma mark -Share Actions Composer

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

- (UIImage*)rotateImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage]
                         scale:1.0
                   orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft]
     drawInRect:CGRectMake(0,0,size.height ,size.width)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)fbShareAction:(id)sender
{
    [[KGModal sharedInstance]hideAnimated:YES];

    UIImage * PortraitImage = [self rotateImage:imageScreenshot clockwise:YES];
    
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Shared via Past Forward App"];
        [controller addImage:PortraitImage];


        [self presentViewController:controller animated:NO completion:Nil];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"delete");
                
            } else
                
            {
                NSLog(@"post");
            }
            
            //    [composeController dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
//    }
 
}

- (IBAction)gmailShareAction:(id)sender
{
    [[KGModal sharedInstance]hideAnimated:YES];
    

    NSString *emailTitle = _name;
    NSString *messageBody = @"Shared via Past Forward App";
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    UIImage *myImage = [UIImage imageNamed:jpgPath];
    UIImage * PortraitImage = [self rotateImage:myImage clockwise:YES];
    NSData *myImageData = UIImagePNGRepresentation(PortraitImage);
    
    [mc addAttachmentData:myImageData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png",_name]];
    [mc setMessageBody:messageBody isHTML:NO];
   
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
 
}

- (IBAction)backAction:(id)sender
{
    
    [[KGModal sharedInstance]hideAnimated:YES];

    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"Preview"]==1)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Preview"];
        NSLog(@" i value %ld ",(long)j);
        
        EditableViewController *detailViewController = [[EditableViewController alloc] initWithNibName:@"EditableViewController" bundle:nil];
        [detailViewController setRootViewController:self.rootViewController];
        
        detailViewController.name =_name;
        detailViewController.desc =_desc;
        detailViewController.urlString = _imgUrl;
        detailViewController.heritagePlaces=self.heritagePlaces;
        [detailViewController.view setSize:self.rootViewController.view.size];
        

        [self.rootViewController pushViewController:detailViewController animated:YES];
        
    }else
    {
        
        ScribblingViewController *detailViewController = [[ScribblingViewController alloc] initWithNibName:@"ScribblingViewController" bundle:nil];
        [detailViewController setRootViewController:self.rootViewController];
        
        detailViewController.name =_name;
        detailViewController.desc =_desc;
        detailViewController.urlString = _imgUrl;

         detailViewController.heritagePlaces=self.heritagePlaces;
        [detailViewController.view setSize:self.rootViewController.view.size];
        //[detailViewController.view setSize:CGSizeMake(320, 148)];

        [self.rootViewController pushViewController:detailViewController animated:YES];
    }
    isPresented = NO;
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
    
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.rootViewController.viewControllers];
    

    NSLog(@"%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"Back"]);
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Back"] == 200)
    {
        [navigationArray removeObjectAtIndex:3];
        [navigationArray removeObjectAtIndex:2];

    }
    else if([[NSUserDefaults standardUserDefaults]integerForKey:@"Back"] == 100)
    {
        [navigationArray removeObjectAtIndex:4];
        [navigationArray removeObjectAtIndex:3];
        [navigationArray removeObjectAtIndex:2];
    }
    else{
        
        if ([navigationArray count] == 5)
        {
            [navigationArray removeObjectAtIndex:4];
            [navigationArray removeObjectAtIndex:3];
        }else if ([navigationArray count] == 6)
        {
            [navigationArray removeObjectAtIndex:5];
            [navigationArray removeObjectAtIndex:4];
            [navigationArray removeObjectAtIndex:3];
        }
        else if ([navigationArray count]==7)
        {
            [navigationArray removeObjectAtIndex:6];
            [navigationArray removeObjectAtIndex:5];
            [navigationArray removeObjectAtIndex:4];
            [navigationArray removeObjectAtIndex:3];
        }
        
        
    }
    
    self.rootViewController.viewControllers = navigationArray;
    
}

-(NSString *) stringByStrippingHTML {
    NSRange r;
    while ((r = [_desc rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        _desc = [_desc stringByReplacingCharactersInRange:r withString:@""];
    NSLog(@"%@",_desc);
    return _desc;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"rootviewcontroller %@",self.rootViewController);
     NSLog(@"rootviewcontroller %lu",(unsigned long)self.heritagePlaces.count);
    if (_imgUrl == nil)
    {
        [tempImg setImage:[UIImage imageNamed:@"xl_big_stub.png"]];
    } else {
        if(self.heritagePlaces.count!=0)
        {
        [tempImg sd_setImageWithURL:_imgUrl
                   placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             [self ActionMenu];
             
         }];
        }
        else{
            [tempImg setImage:[UIImage imageNamed:_imgUrl]];
        }
        
    }
}

@end
