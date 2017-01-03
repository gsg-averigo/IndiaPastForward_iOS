//
//  DetailViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "ArticlesViewController.h"
#import "ActionSheetViewController.h"
#import "UIImageView+WebCache.h"
#import "HeritagePlace.h"
#import "Article.h"
#import "Offer.h"
#import "Message.h"
#import "UIDevice+IdentifierAddition.h"
#import "Request.h"
#import "AlertView.h"
#import "Categories.h"
#import "NSObject+Parser.h"
#import "MenuButton.h"
#import "Photo.h"
#import "Reachability.h"
#import <CraftARCloudImageRecognitionSDK/CraftARSDK.h>
#import <CraftARCloudImageRecognitionSDK/CraftARCloudRecognition.h>
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface DetailViewController ()
{
    MenuButton *upMenuView;
    UILabel *homeLabel;
    UILabel *label;
    NSMutableArray *MulimagesArray;
    NSMutableArray *countArray;
    UIImageView *imageView;
    NSInteger a;
    IBOutlet UIView *screenView;
    NSData *imgData;
    NSURL *urlValue;
    CGFloat scrollWidth;
    IBOutlet UIView *middleView;
    IBOutlet UIButton *postBtn;
    IBOutlet UIView *topView;
    UIButton *postBtn1;
    NSArray * arr ;
    CraftARSDK *_sdk;
    NSString *message_guid;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *audioButton;
@property (strong, nonatomic) IBOutlet UIButton *videoButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *regsiterforwalk;
@property (strong, nonatomic) IBOutlet UIButton *sendcode;
@property (strong, nonatomic) IBOutlet UITextField *bankcode;
@property (strong, nonatomic) IBOutlet UILabel *labelcheck;
@property (nonatomic, strong) NSMutableData *responseData;
@property (strong, nonatomic) ActionSheetViewController *actionSheet;
@property (strong, nonatomic) MPMoviePlayerViewController *moviewPlayerViewController;
@end
@protocol messageDelegate <NSObject>
@optional
-(void)test:(NSArray *)str;
@end
@interface SecondViewController : NSString
@property (nonatomic, assign) id <messageDelegate> delegate;
@end

@implementation DetailViewController
@synthesize scrollview,pagecontrol, firstPhotos, browView, thumbnailScrollview, seqValues, thumbnailPrevButton, thumbnailNextButton, lastContentOffset, lastContentOffset1, thumbView, labelView, flagString,imgData,homeLabel,imgView;

- (id)init{
    
    if (IPAD)
    {
        self = [super initWithNibName:@"DetailViewController~iPad" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"DetailViewController" bundle:nil];
    }
    
    if(self){
        
    }
    return self;
}

-(void)readyToSend
{
     arr = [[NSArray alloc]init];
    [arr setValue:imageView forKey:@"Image"];
    [arr setValue:self.titleLabel forKey:@"Title"];
    [arr setValue:_webView forKey:@"description"];
    //[delegate test:@"Hello world!"];
}
#pragma mark - #pragma mark


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [AlertView showProgress];
    
        NSLog(@" %@",_placeArray);
    _placeArray = [[NSMutableArray alloc]init];
    _placeArray = [_tabsViewController.heritagePlaces objectAtIndex:0];
    postBtn1 = [[UIButton alloc]init];
    alertView.hidden = YES;
    if([self connected])
    {
        NSInteger j =[[NSUserDefaults standardUserDefaults] integerForKey:@"tag"];
        if (a != j && self.detailType !=DETAIL_TYPE_GUID && self.detailType != DETAIL_TYPE_MESSAGE && !self.fromMap)
        {
            [self readyToSend];
            

            if (IPAD)
            {
//                homeLabel = [self createHomeButtonView];
//                
//                scrollview.frame = CGRectMake(0, 10, scrollview.size.width, scrollview.size.height);
//                imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10,10, imageView.frame.size.width-20, imageView.frame.size.height)] ;
//                
//                _titleLabel.frame = CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10, 752, 50);
//                
//                postBtn1.frame = CGRectMake(_titleLabel.frame.size.width - 200,_titleLabel.frame.origin.y, 60, 60);
//                UIImage *btnImage = [UIImage imageNamed:@"postcard_800X1250.png"];
//                [postBtn1 setImage:btnImage forState:UIControlStateNormal];
//                _webView.frame = CGRectMake(10, _titleLabel.frame.origin.y + 60, 752, 290);
                homeLabel = [self createHomeButtonView];
                [self.view bringSubviewToFront:homeLabel];
                self.footerview.hidden = YES;
                self.titleLabel.frame = CGRectMake(8, 520, 752, 50);
                [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
                self.webView.frame = CGRectMake(8, _titleLabel.frame.origin.y + 70, 752, 290);
                scrollview.frame = CGRectMake(0, topView.frame.origin.y, scrollview.size.width, scrollview.size.height);
                imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10,scrollview.frame.origin.y, scrollview.frame.size.width-20, scrollview.frame.size.height)] ;
                //        scrollWidth += self.scrollview.frame.size.width-10;
                thumbView.hidden = YES;
                int fontSize = 120;
                NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
                [self.webView stringByEvaluatingJavaScriptFromString:jsString];
                
//                self.footerview.hidden = YES;
//                self.footerview.hidden = YES;
//                self.titleLabel.frame = CGRectMake(8, 520, 752, 50);
//                [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
//                self.webView.frame = CGRectMake(8, _titleLabel.frame.origin.y + 70, 752, 290);
//                scrollview.frame = CGRectMake(0, topView.frame.origin.y + 100, scrollview.size.width, scrollview.size.height);
//                imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10,scrollview.frame.origin.y, scrollview.frame.size.width-20, scrollview.frame.size.height+70)] ;
                //thumbView.hidden = YES;
//                int fontSize = 120;
//                NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
//                [_webView stringByEvaluatingJavaScriptFromString:jsString];
                [postBtn1 addTarget:self action:@selector(postCardAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:postBtn1];
            }
            else
            {
                homeLabel = [self createHomeButtonView];
                [self.view bringSubviewToFront:homeLabel];
                
                scrollview.frame = CGRectMake(0, 65, scrollview.frame.size.width, scrollview.frame.size.height - 25);
                imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0, self.scrollview.frame.size.width-10, scrollview.frame.size.height)];
                _titleLabel.frame = CGRectMake(8, 250, 300, 50);
                _webView.frame = CGRectMake(8, 290, 300, 300);
                
                [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                int fontSize = 40;
                NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
                [self.webView stringByEvaluatingJavaScriptFromString:jsString];

                
                
                
                
                
                
                
                //_titleLabel.frame = CGRectMake(8, scrollview.frame.size.height+scrollview.frame.origin.y, 300, 50);
                
                //[_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
               //  _webView.frame   = CGRectMake(8, _titleLabel.frame.origin.y + 70, 752, 290);
               //  scrollview.frame = CGRectMake(0,  topView.frame.origin.y +70, scrollview.frame.size.width, scrollview.frame.size.height-50);
               // imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y +70, scrollview.size.width, scrollview.size.height)];
                thumbView.hidden = YES;
               // int fontSize = 70;
               // NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
                //[self.webView stringByEvaluatingJavaScriptFromString:jsString];
                [postBtn1 addTarget:self action:@selector(postCardAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:postBtn1];
                //[postBtn1 setEnabled:YES];
                self.thumbView.hidden = NO;
                
                
            }
            topView.hidden = YES;
            labelView.hidden = NO;
            label.hidden = NO;
            postBtn1.hidden = NO;
            langBtn.hidden = NO;
            UIGraphicsBeginImageContext(topView.frame.size);
            [[UIImage imageNamed:@"search_whole_bg.png"] drawInRect:topView.bounds];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            topView.backgroundColor = [UIColor colorWithPatternImage:image];
             [self performSelector:@selector(postCardAction:) withObject:self afterDelay:1.0 ];
            if (_detailType == DETAIL_TYPE_GUID)
            {
                HeritagePlace *place = [self.herplaces objectAtIndex:0];
                NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                urlString = [urlString stringByAppendingPathComponent:place.heritagebuildinginfoguid];
                urlString = [urlString stringByAppendingPathComponent:place.image];
            }
        }
        else
        {
             topView.hidden = YES;
             postBtn1.hidden = NO;
            imageView = [[UIImageView alloc] initWithFrame: CGRectMake(5,5, self.scrollview.frame.size.width-10, self.scrollview.frame.size.height)] ;
        
            if (IPAD)
            {
                langBtn.hidden = NO;

                homeLabel = [self createHomeButtonView];
                 [self.view bringSubviewToFront:homeLabel];
                scrollview.frame = CGRectMake(0, 10, scrollview.size.width, scrollview.size.height);
                imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10,10, imageView.frame.size.width-20, imageView.frame.size.height)] ;
                
                _titleLabel.frame = CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10, 752, 50);
                
                postBtn1.frame = CGRectMake(_titleLabel.frame.size.width - 200,_titleLabel.frame.origin.y, 60, 60);
                UIImage *btnImage = [UIImage imageNamed:@"postcard_800X1250.png"];
                [postBtn1 setImage:btnImage forState:UIControlStateNormal];
                
                _webView.frame = CGRectMake(10, _titleLabel.frame.origin.y + 60, 752, 290);
                self.coachMarks = @[
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{postBtn1.frame.origin.x-5,postBtn1.frame.origin.y-5},{postBtn1.width+8,postBtn1.height+8}}],
                                        @"caption": @"Use this to create your own post card and share",
                                        @"shape": @"circle"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{postBtn1.frame.origin.x+110,postBtn1.frame.origin.y-5},{postBtn1.width+8,postBtn1.height+8}}],
                                        @"caption": @"Use this to see heritage info in other available languages",
                                        @"shape": @"circle"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{0,self.footerview.origin.y},{self.footerview.width/4,self.footerview.height}}],
                                        @"caption": @"use this to see blogs written by Sriram V on this heritage place",
                                        @"shape": @"square"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{self.footerview.width/4,self.footerview.origin.y},{self.footerview.width/4,self.footerview.height}}],
                                        @"caption":@"Listen to audio (if available)",
                                        @"shape": @"square"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{self.footerview.width/2,self.footerview.origin.y},{self.footerview.width/4,self.footerview.height}}],
                                        @"caption": @"share this heritage info",
                                        @"shape": @"square"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{self.footerview.width-(self.footerview.width/4),self.footerview.origin.y},{self.footerview.width/4,self.footerview.height}}],
                                        @"caption": @"watch video (if available)",
                                        @"shape": @"square"
                                        },
                                    ];
                coachMarksView = [[WSCoachMarksView alloc] initWithFrame:CGRectMake(0,0,self.view.width,self.view.height-100) coachMarks:self.coachMarks];
                [self.view addSubview:coachMarksView];

               
            }
            else
            {
                
                langBtn.hidden = NO;
                NSLog(@"%f",_titleLabel.frame.size.width);
                postBtn1.frame = CGRectMake(_titleLabel.frame.size.width+15, _titleLabel.frame.origin.y-10 , 35, 35);
                UIImage *btnImage = [UIImage imageNamed:@"postcard.png"];
                [postBtn1 setImage:btnImage forState:UIControlStateNormal];
                homeLabel = [self createHomeButtonView];
                [self.view bringSubviewToFront:homeLabel];
                NSLog(@"FOOTERVIEW %f",self.labelView.origin.y);
                self.coachMarks = @[
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{postBtn1.frame.origin.x-5,postBtn1.frame.origin.y-5},{50,45}}],
                                        @"caption": @"Use this to create your own post card and share",
                                        @"shape": @"circle"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{langBtn.frame.origin.x+5,langBtn.frame.origin.y-5},{50,45}}],
                                        @"caption": @"Use this to see heritage info in other available languages",
                                        @"shape": @"circle"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{0,self.labelView.origin.y},{self.labelView.width/4,self.labelView.height}}],
                                        @"caption": @"use this to see blogs written by Sriram V on this heritage place",
                                        @"shape": @"square"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{self.labelView.width/4,self.labelView.origin.y},{self.labelView.width/4,self.labelView.height}}],
                                        @"caption": @"Listen to audio (if available)",
                                        @"shape": @"square"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{self.labelView.width/2,self.labelView.origin.y},{self.labelView.width/4,self.labelView.height}}],
                                        @"caption": @"watch video (if available)",
                                        @"shape": @"square"
                                        },
                                    @{
                                        @"rect": [NSValue valueWithCGRect:(CGRect){{self.labelView.width-(self.labelView.width/4),self.labelView.origin.y},{self.labelView.width/4,self.labelView.height}}],
                                        @"caption": @"share this heritage info",
                                        @"shape": @"square"
                                        },
                                    ];
                coachMarksView = [[WSCoachMarksView alloc] initWithFrame:CGRectMake(0,0,self.view.width,self.view.height) coachMarks:self.coachMarks];
                [self.view addSubview:coachMarksView];
                
//                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//                NSString *lang=[prefs objectForKey:@"globallang"];
//                if(lang == nil)
//                {
//                lang=@"ENG";
//                }
//                langBtn.frame = CGRectMake(postBtn1.frame.size.width+postBtn1.frame.origin.x+15, postBtn1.frame.origin.y, 36, 36);
//                
//                [langBtn setTitle:lang forState:UIControlStateNormal];
//                langBtn.layer.cornerRadius = langBtn.frame.size.width / 2;
//                langBtn.layer.masksToBounds = YES;
//                [langBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [langBtn setBackgroundColor:[UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1]];
                
        }
            BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShownDetail"];
            if (coachMarksShown == NO) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSCoachMarksShownDetail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [coachMarksView start];
            }

            
            [postBtn1 addTarget:self action:@selector(postCardAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:postBtn1];
            self.thumbView.hidden = YES;
            
            }
    }
    seqValues = 0;
    [AlertView hideAlert];
    MulimagesArray=[[NSMutableArray alloc] init];
    [MulimagesArray removeAllObjects];
    countArray = [[NSMutableArray alloc]init];
    [countArray removeAllObjects];
    if(self.detailType == DETAIL_TYPE_PLACE)
    {
        //NSLog(@"self.detailObject count:%@",self.detailObject);
        NSLog(@"name string %@",_nameString);
        if (_nameString.length!=0)
        {
            if([self connected])
            {
                if(self.rootViewController.tabsViewController.heritagePlaces.count!=0)
                {
                topView.hidden = NO;
                postBtn1.hidden = YES;
            }
                else{
                topView.hidden = YES;
                postBtn1.hidden=NO;
                }
            }
            else{
                topView.hidden=YES;
            }
           scrollview.frame = CGRectMake(0, 10, scrollview.size.width, scrollview.size.height);
            imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10,scrollview.frame.origin.y, scrollview.frame.size.width-20, scrollview.frame.size.height)] ;
            _titleLabel.text = [NSString stringWithFormat:@"%@",_nameString];
            NSLog(@"the descri of string %@", _webString);
            NSString *stringWithoutSpaces = [_webString stringByReplacingOccurrencesOfString:@"â€" withString:@""];
            [_webView loadHTMLString:stringWithoutSpaces baseURL:nil];
            NSLog(@"Photo string:%@",_PhotoString);
            if(![_PhotoString isEqual:@""]&&![_PhotoString isEqual:@"(null)"])
            {
              imageView.image=[UIImage imageNamed:_PhotoString];
            }
            else
            {
              imageView.image=[UIImage imageNamed:@"xl_big_stub.png"];
            }
            [self.scrollview addSubview: imageView];
        }
        else
        {
            
            if([self connected])
            {
                NSLog(@"heritage places count %lu",(unsigned long)self.heritagePlaces.count);
            //topView.hidden=YES;
            NSString *descriptionString;
            NSString *audioString;
            NSString *videoString;
            if(self.heritagePlaces.count!=0)
            {
            postBtn1.hidden = NO;
            [_titleLabel setText:[(HeritagePlace *)self.detailObject name]];
            descriptionString = [(HeritagePlace *)self.detailObject hp_description];
                audioString = [(HeritagePlace *)self.detailObject audioFile];
                videoString = [(HeritagePlace *)self.detailObject videoFile];
                if(![audioString isEqualToString:@""]||audioString!=nil)
                {
                    [self.audioButton setEnabled:NO];
                }
                if(![videoString isEqualToString:@""]||videoString!=nil)
                {
                    [self.videoButton setEnabled:NO];
                }
            }
            else
            {
            postBtn1.hidden = YES;
            [_titleLabel setText:[self.detailObject objectForKey:@"name"]];
            descriptionString = [self.detailObject objectForKey:@"Description"];
            }
//                if(_isPostCard)
//                {
//                    [self performSelector:@selector(postCardAction:) withObject:self afterDelay:0.0];
//                }
            //NSLog(@"the descri of string %@", descriptionString);
            NSString *stringWithoutSpaces = [descriptionString
                                             stringByReplacingOccurrencesOfString:@"â€" withString:@""];
            [_webView loadHTMLString:stringWithoutSpaces baseURL:nil];
            

            [self GetLanguages];
            [self.browserview setHidden:YES];
            [self getPhotos];
            }
            else
            {
                
                postBtn1.hidden = NO;
                
                //[_titleLabel setText:[(HeritagePlace *)self.detailObject objectForKey:@"name"]];
                [_titleLabel setText:[self.detailObject objectForKey:@"name"]];
                //NSString *descriptionString = [(HeritagePlace *)self.detailObject hp_description];
                NSString *descriptionString = [self.detailObject objectForKey:@"Description"];
                NSLog(@"the descrip of string %@", descriptionString);
                NSString *stringWithoutSpaces = [descriptionString
                                                 stringByReplacingOccurrencesOfString:@"â€" withString:@""];
                [_webView loadHTMLString:stringWithoutSpaces baseURL:nil];
                [self GetLanguages];
                [self.browserview setHidden:YES];
                [self getPhotos];
            }

        }
       

        
    }
    else if(self.detailType ==DETAIL_TYPE_GUID)
    {
        HeritagePlace *place = [_tabsViewController.heritagePlaces objectAtIndex:1];
        postBtn1.hidden = NO;
        NSString * PushGUID= [[NSUserDefaults standardUserDefaults]stringForKey:@"PushGUID"];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
        [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
        [parameters setObject:PushGUID forKey:@"StrHeritagGUID"];
        [Request makeRequestWithIdentifier:SEARCH_PUSH parameters:parameters delegate:self];
        
        NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
        urlString = [urlString stringByAppendingPathComponent:place.heritagebuildinginfoguid];
        urlString = [urlString stringByAppendingPathComponent:place.image];
        
        [self.browserview setHidden:YES];
        [self GetLanguages];

        [[NSUserDefaults standardUserDefaults]setObject:@"Hello" forKey:@"WillApper"];

    }
    else if(self.detailType == DETAIL_TYPE_OFFER)
    {
        postBtn1.hidden = YES;
        self.footerview.hidden = YES;
        self.pagecontrol.hidden = YES;
        self.thumbnailNextButton.hidden = YES;
        self.thumbnailPrevButton.hidden = YES;
        self.thumbnailScrollview.hidden = YES;
        self.thumbView.hidden = YES;
        //self.titleLabel.hidden = YES;
        [self.titleLabel setText:[(Offer *)self.detailObject title]];
        NSString * Offerttitle =[(Offer *)self.detailObject title];
        
        [[NSUserDefaults standardUserDefaults] setObject:Offerttitle forKey:@"Offertitle"];
        NSString * Offerguid =[(Offer *)self.detailObject offerGUID];
        [[NSUserDefaults standardUserDefaults] setObject:Offerguid forKey:@"OfferGuid"];
        [self.webView loadHTMLString:[(Offer *)self.detailObject offerDescription] baseURL:nil];
        
        
        [imageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"] options:SDWebImageRefreshCached];
        

         [self.scrollview addSubview: imageView];
       // self.webView.height =300;
        
        [self.infoButton.superview setHidden:YES];
        
        NSString * Enablewalk =[(Offer *)self.detailObject enablewalk];
        if ([Enablewalk isEqualToString:@"E"] )
        {
            //[self.regsiterforwalk setHidden:NO];
           // self.webView.height =300;
            [self.regsiterforwalk setHidden:NO];
            [self.bankcode setHidden:NO];
            [self.sendcode setHidden:NO];
        }
        else
        {
           // self.webView.height =300;
            
        }
        [self.browserview setHidden:YES];
    }
    else if (self.detailType == DETAIL_TYPE_BROWSE)
    {
        self.browserview.delegate = self;
        self.scrollview.userInteractionEnabled = NO;
        self.pagecontrol.hidden = YES;
        postBtn1.hidden = YES;
        //self.browserview.contentSize = CGRectZero;
        [self.scrollview setHidden:YES];
        self.browserview.hidden = NO;
        self.titleLabel.hidden = YES;
        self.webView.hidden = YES;
        self.thumbnailNextButton.hidden = YES;
        self.thumbnailPrevButton.hidden = YES;
        self.thumbnailScrollview.hidden = YES;
        self.thumbView.hidden = YES;
        [self.webView.scrollView setBounces:NO];
        [self.infoButton.superview setHidden:YES];
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
          activityView.center = CGPointMake(self.view.frame.size.width / 2.0, 370.0);
          [activityView startAnimating];
          activityView.tag = 100;
          [self.browserview addSubview:activityView];
          NSURLRequest *requestObj;
//        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"Scanner"] == 100)
//        {
//            NSLog(@"Scan Image Url is====>>>>%@",_scanUrl);
//            NSURL *scan_Url=[NSURL URLWithString:_scanUrl];
//            requestObj =[NSURLRequest requestWithURL:scan_Url];
//        }
//        else
//        {
//            NSURL *article_Url=[NSURL URLWithString:[(Article *)self.detailObject url]];
//           requestObj =[NSURLRequest requestWithURL:article_Url];
//        }
        NSURL *article_Url=[NSURL URLWithString:[(Article *)self.detailObject url]];
        requestObj =[NSURLRequest requestWithURL:article_Url];
          [self.browserview loadRequest:requestObj];
          [self.view addSubview:self.browserview];
           self.webView.height =250;

    }
    else if (self.detailType == DETAIL_TYPE_TWEET)
    {
        self.titleLabel.hidden = YES;
        postBtn1.hidden = YES;
        [self.browserview setHidden:NO];
        self.pagecontrol.hidden = YES;
        self.thumbnailNextButton.hidden = YES;
        self.thumbnailPrevButton.hidden = YES;
        self.thumbnailScrollview.hidden = YES;
        self.thumbView.hidden = YES;
        postBtn1.hidden = YES;
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = CGPointMake(self.view.frame.size.width / 2.0, 370.0);
        [activityView startAnimating];
        activityView.tag = 100;
        [self.view addSubview:activityView];
        NSURL *article_Url=[NSURL URLWithString:self.detailObject];
        NSURLRequest *requestObj =[NSURLRequest requestWithURL:article_Url];
        [self.browserview loadRequest:requestObj];
    }
    else if(self.detailType == DETAIL_TYPE_MESSAGE)
    {
        NSString *urlString1;
        postBtn1.hidden = NO;
//        homeLabel = [self createHomeButtonView];
//        [self.view bringSubviewToFront:homeLabel];
        [self.browserview setHidden:YES];
        [self.titleLabel setText:[(Message *)self.detailObject messageTitle]];
        NSString * Offerttitle =[(Message *)self.detailObject messageTitle];
        [[NSUserDefaults standardUserDefaults] setObject:Offerttitle forKey:@"Offertitle"];
        NSString * Offerguid =[(Message *)self.detailObject messageGUID];
        message_guid = Offerguid;
        [[NSUserDefaults standardUserDefaults] setObject:Offerguid forKey:@"OfferGuid"];
        [self.webView loadHTMLString:[(Message *)self.detailObject messageDescription] baseURL:nil];
        //self.webView.height =100;
        [self.infoButton.superview setHidden:NO];
        
        NSString *str = [(Message *)self.detailObject photoString];
        [MulimagesArray addObject:str];
        NSLog(@"the str vahdhhd %@", MulimagesArray);
        
        Photo *photo=[[Photo alloc]init];
        
       if ((MulimagesArray.count != 0) || (self.Photos.count !=0))
        {
            
            
            for (int k = 0; k < self.Photos.count; k++)
            {
                photo=[self.Photos objectAtIndex:k];
                
                
                if ([photo.guid isEqualToString:[(Message *)self.detailObject messageGUID]])
                {
                    
                    
                    [MulimagesArray addObject:photo.name];
                }
            }
            NSLog(@"Array Value is%@",MulimagesArray);
            self.pagecontrol.numberOfPages=MulimagesArray.count;
            
            if(MulimagesArray.count>0)
            {
                self.pagecontrol.numberOfPages=MulimagesArray.count;
                
                
                
                if(self.pagecontrol.numberOfPages<=1)
                {
                    self.pagecontrol.hidden=YES;
                }
                else
                {
                    self.pagecontrol.hidden=NO;
                }
                for (int i = 0; i <MulimagesArray.count; i++)
                {
//                    NSString *urlString;
                    
                    urlString1 = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                    urlString1 = [urlString1 stringByAppendingPathComponent:[(Message *)self.detailObject messageGUID]];
                    urlString1 = [urlString1 stringByAppendingPathComponent:[MulimagesArray objectAtIndex:i]];
                    NSLog(@"url string:%@",urlString1);
                     [imageView setImageWithURL:[NSURL URLWithString:urlString1] placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"] options:SDWebImageRefreshCached];
                    
                    
                    
                    //[imageView setImage:image];
                    [self.scrollview addSubview: imageView];
                   
                    NSLog(@"scroll width:%f",scrollWidth);
                    
                    NSLog(@"the muta %@", MulimagesArray);
                    
                    urlValue = [NSURL URLWithString:urlString1];
        
//        if (MulimagesArray.count <= 6)
//        {
//            if (IPAD)
//            {
//                self.webView.frame = CGRectMake(8, 480, 752, 290);
//                self.titleLabel.frame = CGRectMake(8, 420, 752, 65);
//                
//            }
//            else
//            {
//                
//            }
//        }
            }
        }
            
    }

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
        [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"OfferGuid"] forKey:@"strNotificationID"];
        
        [Request makeRequestWithIdentifier:HERITAGE_WALK parameters:parameters delegate:self];
        
        NSString *walkregisetered = [prefs stringForKey:@"valresponse"];
        
        NSString * Enablewalk =[(Message *)self.detailObject enablewalk];
        
        if ([Enablewalk isEqualToString:@"E"] )
        {
            
            self.webView.height =240;
            
            if ([walkregisetered isEqualToString:@"N"])
            {
                [_regsiterforwalk setHidden:NO];
            }
            else if ([walkregisetered isEqualToString:@"Y"])
            {
                 _labelcheck.text=@"Please Enter Your Bank Reference Number";
                [_labelcheck setFont:[UIFont systemFontOfSize:10]];
                [self.bankcode setHidden:NO];
                [self.sendcode setHidden:NO];
            }
            
        }
        else if ([Enablewalk isEqualToString:@"D"])
        {
            [self.regsiterforwalk setHidden:YES];
            [self.bankcode setHidden:YES];
            [self.sendcode setHidden:YES];
            self.webView.height =250;
        }
        [self.infoButton.imageView  setContentMode:UIViewContentModeScaleAspectFit];
        [self.audioButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.videoButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.shareButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
            NSLog(@"the flajdjj %@", flagString);
            if (![self.flagString isEqualToString:@"Y"])
            {
                [self GetLanguages];
            }
                else{
                    if (IPAD) {
                        self.webView.frame = CGRectMake(8, 420, 752, 290);
                        self.titleLabel.frame = CGRectMake(8, 370, 752, 50);
                        self.thumbView.hidden = YES;
                        self.footerview.hidden = YES;
                        
                    }
                    else
                    {
                        self.thumbView.hidden = YES;
                        self.footerview.hidden = YES;
                        
                    }
                
                }
        
    }
            
    
    NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
    [removeUD removeObjectForKey:@"resposney"];
    [[NSUserDefaults standardUserDefaults]synchronize ];
    self.LanguageFlag=@"Y";
    
    
    if(IPAD)
    {
        upMenuView = [[MenuButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width)-100.f, 350,homeLabel.frame.size.width,homeLabel.frame.size.height)
                                            expansionDirection:DirectionUp];
    }
    else
    {
        upMenuView = [[MenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 10.f,self.view.frame.size.height - homeLabel.frame.size.height -253.f,homeLabel.frame.size.width,homeLabel.frame.size.height)
                                            expansionDirection:DirectionUp];
    }

    
    NSLog(@"view fam:%f",self.view.frame.size.width);
    
    self.Langauges=[[NSMutableArray alloc]initWithObjects:@"lang 1",@"lang 2",@"lang 3",@"lang 4", nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"Y" forKey:@"globalflag"];
    [prefs removeObjectForKey:@"globallang"];
    [prefs synchronize];
    upMenuView.homeButtonView = homeLabel;
    //upMenuView.homeButtonView = langBtn;
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    tap1.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap1];
    
    [AlertView hideAlert];
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [_sdk stopCapture];
}
- (void)dismissKeyboard
{
    [editTextView resignFirstResponder];
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

-(void)getPhotos
{
    if ([self connected])
    {
        NSString *str;

        if(self.heritagePlaces.count!=0)
        {
        str = [(HeritagePlace *)self.detailObject image];
        }
        else{
         str= [self.detailObject objectForKey:@"Photo"];
        }
        
        [MulimagesArray addObject:str];
        NSLog(@"the str vahdhhd %@", str);
        
        Photo *photo=[[Photo alloc]init];
        
        NSLog(@"the Photo Count %lu",(unsigned long)self.Photos.count);
        NSLog(@"the mac Value %@",  photo.name);
        
        if ((MulimagesArray.count != 0) || (self.Photos.count !=0))
        {
            for (int k = 0; k < self.Photos.count; k++)
            {
                photo=[self.Photos objectAtIndex:k];
                
                
            if ([photo.guid isEqualToString:[(HeritagePlace *)self.detailObject heritagebuildinginfoguid]])
            {
            [MulimagesArray addObject:photo.name];
            }
            }
            NSLog(@"Array Value is%@",MulimagesArray);

            self.pagecontrol.numberOfPages=MulimagesArray.count;
            
            if(MulimagesArray.count>0)
            {
                self.pagecontrol.numberOfPages=MulimagesArray.count;
                
                if(self.pagecontrol.numberOfPages<=1)
                {
                    self.pagecontrol.hidden=YES;
                }
                else
                {
                    self.pagecontrol.hidden=NO;
                }
                
                for (int i = 0; i <MulimagesArray.count; i++)
                {
                    ////Change
                    NSString *urlString;
                    urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                    if(self.heritagePlaces.count!=0)
                    {
                    urlString = [urlString stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject heritagebuildinginfoguid]];
                    }
                   else{
                        urlString= [self.detailObject objectForKey:@"heritagebuildinginfoguid"];
                    }

                    urlString = [urlString stringByAppendingPathComponent:[MulimagesArray objectAtIndex:i]];

                    
                    NSLog(@"url string:%@",urlString);
if(self.heritagePlaces.count!=0)
{
                    [imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"] options:SDWebImageRefreshCached];
}
                    else
                    {
                    imageView.image= [UIImage imageNamed:[MulimagesArray objectAtIndex:i]];
                    }
                    
                    [self.scrollview addSubview: imageView];
                    
                }
            }
        }

    }
    else
    {
        UIImage *image = [[UIImage alloc]init];
        if (imgData!= nil) {
            image = [UIImage imageWithData:imgData];

        }else{
            image = [UIImage imageNamed:@"xl_big_stub.png"];
        }
        [imageView  setImage:image];
        [self.scrollview addSubview: imageView];
        self.thumbnailNextButton.hidden = YES;
        self.thumbnailPrevButton.hidden = YES;

    }
 }


- (void)handleTap:(UITapGestureRecognizer *)recognizer  {
    UIImageView *imageViewTap = (UIImageView *)recognizer.view;
    if (IPAD) {
        [self.scrollview setContentOffset:CGPointMake(768*[imageViewTap tag], 0)];
//        self.pagecontrol.currentPage = floorf(scrollview.contentOffset.x/768);
    }
   else
   {
       [self.scrollview setContentOffset:CGPointMake(380*[imageViewTap tag], 0)];
//       self.pagecontrol.currentPage = floorf(scrollview.contentOffset.x/320);
   }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (countArray.count <= 6)
    {
        self.thumbnailPrevButton.enabled = NO;
        self.thumbnailNextButton.enabled = NO;
    }
    else
    {
        ScrollDirection scrollDirection;
        if (self.lastContentOffset > self.thumbnailScrollview.contentOffset.x)
        {
            
            scrollDirection = ScrollDirectionRight;
            NSLog(@"right");
            
        }
        
        else if (self.lastContentOffset < self.thumbnailScrollview.contentOffset.x)
        {
            NSLog(@"Left");
            scrollDirection = ScrollDirectionLeft;
        }
        
        self.lastContentOffset = scrollView.contentOffset.x;
    
    }
    
    if (IPAD)
    {
        self.pagecontrol.currentPage = floorf(scrollview.contentOffset.x/768);
    }
    else
    {
//        self.pagecontrol.currentPage = floorf(scrollview.contentOffset.x/320);
    }
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view viewWithTag:100].hidden = YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view viewWithTag:100].hidden = YES;
    NSLog(@"Error for WEBVIEW: %@", [error description]);
    [AlertView showAlertMessage:@"Link Not Found!!"];
}

- (UILabel *)createHomeButtonView
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *lang=[prefs objectForKey:@"globallang"];
    if(lang == nil)
    {
    lang=@"ENG";
    }
    
    if(IPAD)
    {
    label= [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 60.f)];
    label.font = [UIFont fontWithName:@"Arial" size:16];
    }
    else
    {
        langLbl.hidden=YES;
    label= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
    label.font = [UIFont fontWithName:@"Arial" size:10];
    }
    label.text =lang;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1];
    label.clipsToBounds = YES;
    return label;
}

- (NSArray *)createDemoButtonArray {
    
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
//    int i = 0;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *lngflag=[prefs objectForKey:@"globalflag"];
    NSLog(@"the lang %@", self.Langauges);
    
    if (self.Langauges.count >=2) {
        
        if([lngflag isEqualToString:@"Y"])
        {
            for (NSString *title in self.Langauges)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:title forState:UIControlStateNormal];
                
                if(IPAD)
                {
                    button.frame = CGRectMake(0.f, 0.f, 60.f, 60.f);
//                  button.font = [UIFont fontWithName:@"Arial" size:14];
                }
                else
                {
                    button.frame = CGRectMake(0.f, 0.f, 40.f, 40.f);
//                  button.font = [UIFont fontWithName:@"Arial" size:10];
                }
                button.layer.cornerRadius = button.frame.size.height / 2.f;
                button.backgroundColor = [UIColor colorWithRed:0.498 green:0.149 blue:0.165 alpha:1];
                button.clipsToBounds = YES;
                button.tag = title;
                [button addTarget:self action:@selector(langbuttonclicked:) forControlEvents:UIControlEventTouchUpInside];
                [buttonsMutable addObject:button];
            }
            
        }
    }
    return [buttonsMutable copy];
}

- (void)langbuttonclicked:(UIButton *)sender
{

        homeLabel.text=sender.titleLabel.text;
        self.global_lang=sender.titleLabel.text;
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[(HeritagePlace *)self.detailObject heritagebuildinginfoguid] forKey:@"HeritageBuildingInfoGUID"];
        [parameters setObject:self.global_lang forKey:@"strLanguageCode"];
        [Request makeRequestWithIdentifier:GET_LANG parameters:parameters delegate:self];
    
}


-(void)GetLanguages
{
    if(self.detailType == DETAIL_TYPE_MESSAGE)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.global_lang=[prefs objectForKey:@"globallang"];
        if(self.global_lang == nil)
        {
            self.global_lang=@"ENG";
             NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:message_guid forKey:@"HeritageBuildingInfoGUID"];
            [parameters setObject:self.global_lang forKey:@"strLanguageCode"];
             [Request makeRequestWithIdentifier:GET_LANG parameters:parameters delegate:self];
        }
    }else if (_detailType == DETAIL_TYPE_GUID)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.global_lang=[prefs objectForKey:@"globallang"];
        if(self.global_lang == nil)
        {
            self.global_lang=@"ENG";
            [prefs setObject:@"ENG" forKey:@"globallang"];
        }
        NSString * PushGUID= [[NSUserDefaults standardUserDefaults]stringForKey:@"PushGUID"];

        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:PushGUID forKey:@"HeritageBuildingInfoGUID"];
        [parameters setObject:self.global_lang forKey:@"strLanguageCode"];
        
        [Request makeRequestWithIdentifier:GET_LANG parameters:parameters delegate:self];

    }
       else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.global_lang=[prefs objectForKey:@"globallang"];
        if(self.global_lang == nil)
        {
            self.global_lang=@"ENG";
            [prefs setObject:@"ENG" forKey:@"globallang"];
        }
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (_guid != nil)
        {
            [parameters setObject:_guid forKey:@"HeritageBuildingInfoGUID"];
        }
        else
        {
            if([self connected])
            {
                if(self.heritagePlaces.count!=0)
                {
            [parameters setObject:[(HeritagePlace *)self.detailObject heritagebuildinginfoguid] forKey:@"HeritageBuildingInfoGUID"];
                }
                else{
                    [parameters setObject:[self.detailObject objectForKey:@"heritagebuildinginfoguid"] forKey:@"HeritageBuildingInfoGUID"];
 
                }
           
            }
            else{
            [parameters setObject:[self.detailObject objectForKey:@"heritagebuildinginfoguid"] forKey:@"HeritageBuildingInfoGUID"];
            }
        }
        
        [parameters setObject:self.global_lang forKey:@"strLanguageCode"];
        [Request makeRequestWithIdentifier:GET_LANG parameters:parameters delegate:self];
    }
    
   
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



#pragma mark - LeveyPopListView delegates
#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark -

- (IBAction)relatedInfoButtonTapped:(id)sender
{
    
    if ([self connected]) {
        if(self.detailType == DETAIL_TYPE_PLACE)
        {
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
            [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
            [parameters setObject:[(HeritagePlace *)self.detailObject heritagebuildinginfoguid] forKey:@"strHeritageBuildingInfoGUID"];
            [Request makeRequestWithIdentifier:RELATED_ARTICLE parameters:parameters delegate:self];
            [AlertView showProgress];
        }
        else if (self.detailType == DETAIL_TYPE_GUID)
        {
            HeritagePlace *place = [self.herplaces objectAtIndex:0];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
            [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
            [parameters setObject:place.heritagebuildinginfoguid forKey:@"strHeritageBuildingInfoGUID"];
            [Request makeRequestWithIdentifier:RELATED_ARTICLE parameters:parameters delegate:self];
            [AlertView showProgress];
            
        }
        
        else if (self.detailType == DETAIL_TYPE_MESSAGE)
        {
            //HeritagePlace *place = [self.herplaces objectAtIndex:0];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
            [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
            // [parameters setObject:place.heritageBuildingInfoGUID forKey:@"strHeritageBuildingInfoGUID"];
            [Request makeRequestWithIdentifier:MESSAGEBOX_INFO parameters:parameters delegate:self];
            [AlertView showProgress];
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No info in offline mode " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)listenAudioButtonTapped:(id)sender
{
    if ([self connected])
    {
        if(self.detailType == DETAIL_TYPE_PLACE){
            if([[(HeritagePlace *)self.detailObject audioFile] length] > 0){
                NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                urlString = [urlString stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject heritagebuildinginfoguid]];
                urlString = [urlString stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject audioFile]];
                
                Connection *connection = [[Connection alloc] initWithUrl:[NSURL URLWithString:urlString]];
                [connection setConnectionDelegate:self];
                [connection setConnectionIdentifier:AUDIO_DATA];
                [[ConnectionManager defaultManager] addConnection:connection];
                [AlertView showProgress];
            }
            else{
                [AlertView showAlertMessage:@"No Audio files present"];
            }
        }
        else if(self.detailType == DETAIL_TYPE_GUID)
        {
            HeritagePlace *place = [self.herplaces objectAtIndex:0];
            
            if([[(HeritagePlace *)self.detailObject audioFile] length] > 0){
                NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                urlString = [urlString stringByAppendingPathComponent:place.heritagebuildinginfoguid];
                urlString = [urlString stringByAppendingPathComponent:place.audioFile];
                
                Connection *connection = [[Connection alloc] initWithUrl:[NSURL URLWithString:urlString]];
                [connection setConnectionDelegate:self];
                [connection setConnectionIdentifier:AUDIO_DATA];
                [[ConnectionManager defaultManager] addConnection:connection];
                [AlertView showProgress];
            }
            
            
            else
            {
                [AlertView showAlertMessage:@"No Audio files present"];
            }
            
        }
        
        
        else if (self.detailType == DETAIL_TYPE_MESSAGE)
        {
            NSLog(@"the audio file %@", [(Message *)self.detailObject audioFile]);

            
            if (![[(Message *)self.detailObject audioFile] isKindOfClass:[NSNull class]])
            {
                
                NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                urlString = [urlString stringByAppendingPathComponent:[(Message *)self.detailObject messageGUID]];
                urlString = [urlString stringByAppendingPathComponent:[(Message *)self.detailObject audioFile]];
                
                Connection *connection = [[Connection alloc] initWithUrl:[NSURL URLWithString:urlString]];
                [connection setConnectionDelegate:self];
                [connection setConnectionIdentifier:AUDIO_DATA];
                [[ConnectionManager defaultManager] addConnection:connection];
                [AlertView showProgress];
            }
            else{
                [AlertView showAlertMessage:@"No Audio files present"];
            }
            
            
        }
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Audio found in  offline mode " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)viewVideoButtonTapped:(id)sender
{
    if ([self connected]) {
        if(self.detailType == DETAIL_TYPE_PLACE || self.detailType == DETAIL_TYPE_GUID){
            if([[(HeritagePlace *)self.detailObject videoFile] length] > 0)
            {
                if([[self.detailObject videoFile] hasPrefix:@"http://www.youtube.com"]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(HeritagePlace *)self.detailObject videoFile]]];
                }
                else{
                    NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                    urlString = [urlString stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject heritagebuildinginfoguid]];
                    urlString = [urlString stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject videoFile]];
                    Connection *connection = [[Connection alloc] initWithUrl:[NSURL URLWithString:urlString]];
                    [connection setConnectionDelegate:self];
                    [connection setConnectionIdentifier:VIDEO_DATA];
                    [[ConnectionManager defaultManager] addConnection:connection];
                    [AlertView showProgress];
                }
            }
            else{
                [AlertView showAlertMessage:@"No Video files present"];
            }
            
            
        }
        
        
        else if (self.detailType == DETAIL_TYPE_MESSAGE)
        {
            NSLog(@"the audio file %@", [(Message *)self.detailObject videoFile]);
            
            
            
            if (![[(Message *)self.detailObject videoFile] isKindOfClass:[NSNull class]])
            {
                if([[self.detailObject videoFile] hasPrefix:@"http://www.youtube.com"]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(Message *)self.detailObject videoFile]]];
                }
                else{
                    NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
                    urlString = [urlString stringByAppendingPathComponent:[(Message *)self.detailObject messageGUID]];
                    urlString = [urlString stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject videoFile]];
                    Connection *connection = [[Connection alloc] initWithUrl:[NSURL URLWithString:urlString]];
                    [connection setConnectionDelegate:self];
                    [connection setConnectionIdentifier:VIDEO_DATA];
                    [[ConnectionManager defaultManager] addConnection:connection];
                    [AlertView showProgress];
                }
            }
            else{
                [AlertView showAlertMessage:@"No Video files present"];
            }
            
        }

    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Video found in offline mode " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
    

}

- (IBAction)shareButtonTapped:(id)sender
{
    if ([self connected])
    {
        self.actionSheet = [[ActionSheetViewController alloc] initWithButtonTitles:[NSArray arrayWithObjects:@"Facebook", @"Twitter", nil]];
        self.actionSheet.delegate = (id<ActionSheetDelegate>)self;
        [self.rootViewController.view addSubview:self.actionSheet.view];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Not possible to share" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
    
    
}

#pragma mark -

- (void)connection:(Connection *)connection didReceiveData:(id)data{
    [AlertView hideAlert];
    if([data isKindOfClass:[NSString class]])
    {
        data = [data jsonValue];
        NSLog(@"the data %@", data);
    }
    
    if(connection.connectionIdentifier == RELATED_ARTICLE)
    {
        if([[data objectForKey:@"success"] boolValue]){
            ArticlesViewController *articleViewController = [[ArticlesViewController alloc] init];
            [articleViewController setRootViewController:self.rootViewController];
            [articleViewController setArticles:[NSMutableArray arrayWithArray:[self parseArticles:data]]];
            [self.rootViewController pushViewController:articleViewController animated:YES];
        }
    }
    else if(connection.connectionIdentifier == AUDIO_DATA){
        if(self.detailType == DETAIL_TYPE_PLACE || self.detailType == DETAIL_TYPE_GUID)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject audioFile]];
            [data writeToFile:appFile atomically:YES];
            
            self.moviewPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:appFile]];
            [self.moviewPlayerViewController.moviePlayer prepareToPlay];
            [self.moviewPlayerViewController.moviePlayer play];
            [self.rootViewController presentMoviePlayerViewControllerAnimated:self.moviewPlayerViewController];
        }
        else if(self.detailType == MESSAGEBOX_INFO)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[(Message *)self.detailObject audioFile]];
            [data writeToFile:appFile atomically:YES];
            
            self.moviewPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:appFile]];
            [self.moviewPlayerViewController.moviePlayer prepareToPlay];
            [self.moviewPlayerViewController.moviePlayer play];
            [self.rootViewController presentMoviePlayerViewControllerAnimated:self.moviewPlayerViewController];
            
        }
    }
    else if(connection.connectionIdentifier == VIDEO_DATA ){
        
        if(self.detailType == DETAIL_TYPE_PLACE || self.detailType == DETAIL_TYPE_GUID)
        {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[(HeritagePlace *)self.detailObject videoFile]];
        [data writeToFile:appFile atomically:YES];
        
        self.moviewPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:appFile]];
        [self.moviewPlayerViewController.moviePlayer prepareToPlay];
        [self.moviewPlayerViewController.moviePlayer play];
        [self.rootViewController presentMoviePlayerViewControllerAnimated:self.moviewPlayerViewController];
        }
        else if(self.detailType == MESSAGEBOX_INFO)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[(Message *)self.detailObject videoFile]];
            [data writeToFile:appFile atomically:YES];
            
            self.moviewPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:appFile]];
            [self.moviewPlayerViewController.moviePlayer prepareToPlay];
            [self.moviewPlayerViewController.moviePlayer play];
            [self.rootViewController presentMoviePlayerViewControllerAnimated:self.moviewPlayerViewController];
        }
        
    }
    
    else if (connection.connectionIdentifier == HERITAGE_WALK)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // getting an NSString
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
        [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"OfferGuid"] forKey:@"strNotificationID"];
        
        [Request makeRequestWithIdentifier:HERITAGE_WALK parameters:parameters delegate:self];
        
        NSString * valresp =[data objectForKey:@"ValueResponse"];
        
        [prefs setObject:valresp forKey:@"valresponse"];
        [prefs synchronize];
        
    }
    else if (connection.connectionIdentifier == SEARCH_PUSH)
    {
        self.herplaces=[NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];
        HeritagePlace *place = [self.herplaces objectAtIndex:0];
        [self.titleLabel setText:place.name];
        NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
        urlString = [urlString stringByAppendingPathComponent:place.heritagebuildinginfoguid];
        urlString = [urlString stringByAppendingPathComponent:place.image];
        if (self.imgView.image != nil)
        {
            [self.imgView loadImageFromUrl:[NSURL URLWithString:urlString]];
        }
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame: CGRectMake(0,0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)] ;
        
        NSLog(@"url string:%@",urlString);
        //        NSData *data0 = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        //        UIImage *image = [UIImage imageWithData:data0];
        
        [imageView1 setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"xl_big_stub.png"] options:SDWebImageRefreshCached];
        
        //[imageView setImage:image];
        [self.scrollview addSubview: imageView1];
        
        NSString *descriptionString =place.hp_description;
        [self.webView loadHTMLString:descriptionString baseURL:nil];
        
        [AlertView hideAlert];
        //[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PushGUID"];

        
    }
    else if (connection.connectionIdentifier == GET_LANG)
    {
        if([self.LanguageFlag isEqualToString:@"Y"])
        {
            self.Langauges=[data objectForKey:@"Languages"];
            [upMenuView addButtons:[self createDemoButtonArray]];
            [self.view addSubview:upMenuView];
        }
        self.LanguageFlag=@"N";
        
        //if(![self.global_lang isEqual:@"ENG"])
        //{
            [self.webView loadHTMLString:[[[data objectForKey:@"heritagebuildinginfo"]objectAtIndex:0] valueForKey:@"Description"] baseURL:nil];
            self.titleLabel.text=[[[data objectForKey:@"heritagebuildinginfo"]objectAtIndex:0]valueForKey:@"Name"] ;        //}
    }
    if(connection.connectionIdentifier == MESSAGEBOX_INFO)
    {
        if([[data objectForKey:@"success"] boolValue]){
            ArticlesViewController *articleViewController = [[ArticlesViewController alloc] init];
            [articleViewController setRootViewController:self.rootViewController];
            [articleViewController setArticles:[NSMutableArray arrayWithArray:[self parseArticles:data]]];
            [self.rootViewController pushViewController:articleViewController animated:YES];
        }
    }

    
}


- (void)connection:(Connection *)connection didFailWithError:(NSError *)error{
    [AlertView hideAlert];
}


#pragma mark -

- (void)actionSheet:(ActionSheetViewController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(self.detailType == DETAIL_TYPE_PLACE){
        if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"Facebook"])
        {
            SLComposeViewController *composeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
            [composeSheet setInitialText:[NSString stringWithFormat:@"%@\n%@\n%@",[self.detailObject name], descriptionPainText,@"Shared Via Past Forward App"]];
           
            NSLog(@"self.detailObject name%@",  [self.detailObject name]);
            NSLog(@"the imageb %@", imageView.image);
            [composeSheet addImage:imageView.image];
            [composeSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        [AlertView showAlertMessage:@"Post Canceled"];
                        break;
                    case SLComposeViewControllerResultDone:
                        [AlertView showAlertMessage:@"Post Sucessful"];
                        break;
                    default:
                        break;
                }
            }];
            [self presentViewController:composeSheet animated:YES completion:nil];
        }
        
        
        
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"Twitter"]){
            SLComposeViewController *composeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
            NSString * description=[NSString stringWithFormat:@"%@\n%@",[self.detailObject name], descriptionPainText];
            int max = 78;
            if (description > max)
            {
                //get a modified string
                description = [description substringToIndex:description.length-(description.length-max)];
                NSLog(@"%@", description);
            }
            [composeSheet setInitialText:[NSString stringWithFormat:@"%@..\n%@",description, @"Shared Via Past Forward App"]];
            [composeSheet addImage:imageView.image];
            [composeSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                switch (result)
                {
                    case SLComposeViewControllerResultCancelled:
                        [AlertView showAlertMessage:@"Tweet Canceled"];
                        break;
                    case SLComposeViewControllerResultDone:
                        [AlertView showAlertMessage:@"Tweet Sucessful"];
                        break;
                    default:
                        break;
                }
            }];
            [self presentViewController:composeSheet animated:YES completion:nil];
        }
    }
    
    else if (self.detailType == DETAIL_TYPE_GUID)
    {
        HeritagePlace *place = [self.herplaces objectAtIndex:0];
        NSString *Description = [self stripHtmlTags:place.hp_description];
        
        
        NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
        urlString = [urlString stringByAppendingPathComponent:place.heritagebuildinginfoguid];
        urlString = [urlString stringByAppendingPathComponent:place.image];
        imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        UIImage *Image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"Facebook"]){
            SLComposeViewController *composeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//            NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
//            [composeSheet setInitialText:[NSString stringWithFormat:@"%@\n%@\n%@",place.name, Description,@"Shared Via Chennai Past Forward App"]];
            
            [composeSheet addImage:Image];
            [composeSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        [AlertView showAlertMessage:@"Post Canceled"];
                        break;
                    case SLComposeViewControllerResultDone:
                        [AlertView showAlertMessage:@"Post Sucessful"];
                        break;
                    default:
                        break;
                }
            }];
            [self presentViewController:composeSheet animated:YES completion:nil];
        }
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"Twitter"]){
            SLComposeViewController *composeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//            NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
            NSString * description=[NSString stringWithFormat:@"%@\n%@",place.name, Description];
            int max = 78;
            if (description > max)
            {
                //get a modified string
                description = [description substringToIndex:description.length-(description.length-max)];
                
                NSLog(@"%@", description);
            }
            [composeSheet setInitialText:[NSString stringWithFormat:@"%@..\n%@",description, @"Shared Via Past Forward App"]];
            [composeSheet addImage:Image];
            [composeSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                switch (result)
                {
                    case SLComposeViewControllerResultCancelled:
                        [AlertView showAlertMessage:@"Tweet Canceled"];
                        break;
                    case SLComposeViewControllerResultDone:
                        [AlertView showAlertMessage:@"Tweet Sucessful"];
                        break;
                    default:
                        break;
                }
            }];
            [self presentViewController:composeSheet animated:YES completion:nil];
        }


    }
    else
    {
        
        if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"Facebook"]){
            SLComposeViewController *composeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
            
            NSLog(@"the descriptionPainText %@", descriptionPainText);
            [composeSheet setInitialText:[NSString stringWithFormat:@"%@\n%@\n%@",[(Message *)self.detailObject messageTitle], descriptionPainText,@"Shared Via Past Forward App"]];
            [composeSheet addImage:imageView.image];
            [composeSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        [AlertView showAlertMessage:@"Post Canceled"];
                        break;
                    case SLComposeViewControllerResultDone:
                        [AlertView showAlertMessage:@"Post Sucessful"];
                        break;
                    default:
                        break;
                }
            }];
            [self presentViewController:composeSheet animated:YES completion:nil];
        }
        
        
        
        else if([[actionSheet.buttonTitles objectAtIndex:buttonIndex] isEqualToString:@"Twitter"]){
            SLComposeViewController *composeSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
            NSString * description=[NSString stringWithFormat:@"%@\n%@",[(Message *)self.detailObject messageTitle], descriptionPainText];
            int max = 78;
            if (description > max)
            {
                //get a modified string
                description = [description substringToIndex:description.length-(description.length-max)];
                NSLog(@"%@", description);
            }
            [composeSheet setInitialText:[NSString stringWithFormat:@"%@..\n%@",description, @"Shared Via Past Forward App"]];
            [composeSheet addImage:imageView.image];
            [composeSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                switch (result)
                {
                    case SLComposeViewControllerResultCancelled:
                        [AlertView showAlertMessage:@"Tweet Canceled"];
                        break;
                    case SLComposeViewControllerResultDone:
                        [AlertView showAlertMessage:@"Tweet Sucessful"];
                        break;
                    default:
                        break;
                }
            }];
            [self presentViewController:composeSheet animated:YES completion:nil];
        }
    }
}


#pragma mark -

- (NSArray *)parseArticles:(NSDictionary *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"MediaInfo"]){
        data = [[data objectForKey:@"MediaInfo"] objectForKey:@"wordpress"];
        for (NSDictionary *articleDictionary in data) {
            [array addObject:[Article objectFromDictionary:articleDictionary]];
        }
    }
    return array;
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

-(NSString *)stripHtmlTags:(NSString *)string
{
    NSRange range;
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    return string;
}

-(IBAction)registerforwalk:(id)sender{
    
    NSLog(@"register for walk");
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSUserDefaults *prefs;
    prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"OfferGuid"] forKey:@"strAdminID"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Offertitle"] forKey:@"strTitle"];
    
    [Request makeRequestWithIdentifier:REGISTER_WALK parameters:parameters delegate:self];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heritage Walk" message:@"Registration Success.\n You will recieve mail shortly with further details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
    [alert show];
    
}
-(IBAction)sendbankcode:(id)sender
{
    NSLog(@"send bank code");
    if([self.bankcode.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heritage Walk" message:@"Please Enter Your Bank Reference Number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        NSUserDefaults *prefs;
        prefs = [NSUserDefaults standardUserDefaults];
        // getting an NSString
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
        [parameters setObject:self.bankcode.text forKey:@"strBankCode"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Offertitle"] forKey:@"strTitle"];
        NSLog(@"%@",parameters);
        
        [Request makeRequestWithIdentifier:SEND_CODE parameters:parameters delegate:self];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Heritage Walk" message:@"Bank Reference Code Sent " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];
    }
}

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
-(IBAction)textfieldreturn:(id)sender
{
    [sender resignFirstResponder];
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


#pragma mark - button Actions

- (IBAction)nextAction:(id)sender
{
    NSInteger i = 100;
    [[NSUserDefaults standardUserDefaults]setInteger:i forKey:@"Share"];
    UIView *contentView;
    if (IPAD)
    {
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 240)];
        contentView.backgroundColor=[UIColor blackColor];
        CGRect welcomeLabelRect = contentView.bounds;
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        UIFont *titleLabelFont = [UIFont boldSystemFontOfSize:18];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
        titleLabel.frame = CGRectMake(50, 0, 160, 45);
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font = titleLabelFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text=@"Add Post Card";
        [contentView addSubview:titleLabel];
        
        UIButton *writeBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(80, 60, 160, 45)];
        [writeBtn1 setTitle:@"Editable Window" forState:UIControlStateNormal];
        [writeBtn1 addTarget:self action:@selector(writtingAction:) forControlEvents:UIControlEventTouchUpInside];
        [writeBtn1 setTintColor:[UIColor whiteColor]];
        //    [writeBtn1 setBackgroundColor:[UIColor grayColor]];
        writeBtn1.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [contentView addSubview:writeBtn1];
        
        UIButton *scribBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(80, 160, 160, 45)];
        [scribBtn1 setTitle:@"Scribbling Pad" forState:UIControlStateNormal];
        [scribBtn1 addTarget:self action:@selector(scriblingAction:) forControlEvents:UIControlEventTouchUpInside];
        [scribBtn1 setTintColor:[UIColor whiteColor]];
        //    [scribBtn1 setBackgroundColor:[UIColor grayColor]];
        scribBtn1.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [contentView addSubview:scribBtn1];
        
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 50, 50)];
        [img1 setImage:[UIImage imageNamed:@"icon_edit_window.png"]];
        [contentView addSubview:img1];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 160, 50, 50)];
        [img setImage:[UIImage imageNamed:@"icon_scribble.png"]];
        [contentView addSubview:img];
        
        UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        shadowView.layer.shadowRadius = 5.0;
        shadowView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        shadowView.layer.shadowOpacity = 1.0;
        [shadowView addSubview: contentView];

    }
    else
    {
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        contentView.backgroundColor=[UIColor blackColor];
        CGRect welcomeLabelRect = contentView.bounds;
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        UIFont *titleLabelFont = [UIFont boldSystemFontOfSize:16];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
        titleLabel.frame = CGRectMake(30, 0, 120, 40);
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font = titleLabelFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text=@"Add Post Card";
        [contentView addSubview:titleLabel];
        
        
        
        UIButton *writeBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 60, 120, 32)];
        [writeBtn1 setTitle:@"Editable Window" forState:UIControlStateNormal];
        [writeBtn1 addTarget:self action:@selector(writtingAction:) forControlEvents:UIControlEventTouchUpInside];
        [writeBtn1 setTintColor:[UIColor whiteColor]];
        //    [writeBtn1 setBackgroundColor:[UIColor grayColor]];
        writeBtn1.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [contentView addSubview:writeBtn1];
        
        UIButton *scribBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 140, 120, 32)];
        [scribBtn1 setTitle:@"Scribbling Pad" forState:UIControlStateNormal];
        [scribBtn1 addTarget:self action:@selector(scriblingAction:) forControlEvents:UIControlEventTouchUpInside];
        [scribBtn1 setTintColor:[UIColor whiteColor]];
        //    [scribBtn1 setBackgroundColor:[UIColor grayColor]];
        scribBtn1.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [contentView addSubview:scribBtn1];
        
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 32, 32)];
        [img1 setImage:[UIImage imageNamed:@"icon_edit_window.png"]];
        [contentView addSubview:img1];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 140, 32, 32)];
        [img setImage:[UIImage imageNamed:@"icon_scribble.png"]];
        [contentView addSubview:img];
        
        
        
        UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        shadowView.layer.shadowRadius = 5.0;
        shadowView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        shadowView.layer.shadowOpacity = 1.0;
        [shadowView addSubview: contentView];

    }
    
    
    
    
    //Use "http://..." in your details text to include a link
    
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:NO];

    

    
}
-(void)dismissalert
{
    alertView.hidden = YES;
    
 
}

- (IBAction)postCardAction:(id)sender
//int fontSize = 70;
//NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
//[self.webView stringByEvaluatingJavaScriptFromString:jsString];
//
//scrollview.frame = CGRectMake(0, topView.frame.origin.y +70, scrollview.size.width, scrollview.size.height);
//NSLog(@"ScrollView height =====>>>%f",scrollview.frame.size.height+80);
//imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, topView.frame.origin.y +70, scrollview.size.width, scrollview.size.height)];
//
//_titleLabel.frame = CGRectMake(8, scrollview.frame.size.height+scrollview.frame.origin.y, 300, 50);
//
//_webView.frame = CGRectMake(8, _titleLabel.frame.origin.y + 70, 752, 290);
//
//}
//topView.hidden = NO;
//labelView.hidden = YES;
//label.hidden = YES;
//postBtn1.hidden = YES;
//langBtn.hidden = YES;
//UIGraphicsBeginImageContext(topView.frame.size);
//[[UIImage imageNamed:@"search_whole_bg.png"] drawInRect:topView.bounds];
//UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//UIGraphicsEndImageContext();
//
//topView.backgroundColor = [UIColor colorWithPatternImage:image];

{
    topView.hidden = NO;
    labelView.hidden = YES;
    label.hidden = YES;
    postBtn1.hidden = YES;
    if (IPAD)
    {
        self.footerview.hidden = YES;
        self.titleLabel.frame = CGRectMake(8, 520, 752, 50);
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        self.webView.frame = CGRectMake(8, _titleLabel.frame.origin.y + 70, 752, 290);
        scrollview.frame = CGRectMake(0, topView.frame.origin.y + 100, scrollview.size.width, scrollview.size.height);
        imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10,scrollview.frame.origin.y, scrollview.frame.size.width-20, scrollview.frame.size.height)] ;
//        scrollWidth += self.scrollview.frame.size.width-10;
        thumbView.hidden = YES;

        int fontSize = 120;
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    }
    else
    {
        langBtn.hidden = YES;
        scrollview.frame = CGRectMake(0, 65, scrollview.frame.size.width, scrollview.frame.size.height - 25);
        imageView = [[UIImageView alloc] initWithFrame: CGRectMake(10,0, self.scrollview.frame.size.width-10, scrollview.frame.size.height)];
        _titleLabel.frame = CGRectMake(8, 250, 300, 50);
        _webView.frame = CGRectMake(8, 290, 300, 300);

        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        int fontSize = 70;
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    }
    
    UIGraphicsBeginImageContext(topView.frame.size);
    [[UIImage imageNamed:@"search_whole_bg.png"] drawInRect:topView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    topView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    if (_detailType==DETAIL_TYPE_MESSAGE)
    {
        NSLog(@"hi");
        
    }else if (_detailType==DETAIL_TYPE_GUID)
    {
        HeritagePlace *place = [self.herplaces objectAtIndex:0];
        NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"admin/uploadedFiles"];
        urlString = [urlString stringByAppendingPathComponent:place.heritagebuildinginfoguid];
        urlString = [urlString stringByAppendingPathComponent:place.image];
    }
    
}



- (IBAction)scriblingAction:(id)sender
{
    
    [[KGModal sharedInstance]hideAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"PushMsg"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    ScribblingViewController *detailViewController = [[ScribblingViewController alloc] initWithNibName:@"ScribblingViewController" bundle:nil];
    
    if (_detailType == DETAIL_TYPE_MESSAGE)
    {
        [detailViewController setRootViewController:self.rootViewController];

        detailViewController.name = self.titleLabel.text;
        NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
        detailViewController.desc = description;
        detailViewController.urlString = urlValue;
         detailViewController.heritagePlaces=self.heritagePlaces;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
        [detailViewController.view setSize:self.rootViewController.view.size];

    }
    else if    (_detailType== DETAIL_TYPE_GUID)
    {
         [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
        detailViewController.rootViewController = self.rootViewController;

        HeritagePlace *place = [self.herplaces objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",place.heritagebuildinginfoguid, place.image]];
        detailViewController.name =place.name;
        NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
        detailViewController.desc = description;
        detailViewController.urlString = url;
         detailViewController.heritagePlaces=self.heritagePlaces;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
      [detailViewController.view setSize:self.rootViewController.view.size];
    }
    else
    {
        [detailViewController setRootViewController:self.rootViewController];
if(self.heritagePlaces.count!=0)
{
        NSString *str = [(HeritagePlace *)self.detailObject image];
        NSString *str1 = [(HeritagePlace *)self.detailObject heritagebuildinginfoguid];
        NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",str1, str]];
        
        NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
        detailViewController.name = self.titleLabel.text;
        detailViewController.desc =description;
        detailViewController.urlString = url;
     detailViewController.heritagePlaces=self.heritagePlaces;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
        [[NSUserDefaults standardUserDefaults]setInteger:200 forKey:@"Back"];
        [detailViewController.view setSize:self.rootViewController.view.size];
}
        else{
            
            NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
            NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
            detailViewController.name = self.titleLabel.text;
            detailViewController.desc = description;
             detailViewController.heritagePlaces=self.heritagePlaces;
            detailViewController.urlString = [self.detailObject objectForKey:@"Photo"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
            [[NSUserDefaults standardUserDefaults]setInteger:200 forKey:@"Back"];
            
            [detailViewController.view setSize:self.rootViewController.view.size];
        }


    }

    [self.rootViewController pushViewController:detailViewController animated:NO];
}

- (IBAction)writtingAction:(id)sender
{
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"PushMsg"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    [[KGModal sharedInstance]hideAnimated:YES];
        EditableViewController *detailViewController = [[EditableViewController alloc] initWithNibName:@"EditableViewController" bundle:nil];
    
    
    if (_detailType== DETAIL_TYPE_MESSAGE)
    {
        [detailViewController setRootViewController:self.rootViewController];

        detailViewController.name = self.titleLabel.text;
        NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
        detailViewController.desc = description;
        detailViewController.urlString = urlValue;
 detailViewController.heritagePlaces=self.heritagePlaces;

        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
        [detailViewController.view setSize:self.rootViewController.view.size];

    }
    else if (_detailType== DETAIL_TYPE_GUID)
    {
        
        [detailViewController setRootViewController:self.tabsViewController.homeViewController.rootViewController];
        detailViewController.rootViewController = self.rootViewController;
        
        HeritagePlace *place = [self.herplaces objectAtIndex:0];
        
        NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",place.heritagebuildinginfoguid, place.image]];
        NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
        detailViewController.name =place.name;
        detailViewController.desc = description;
         detailViewController.heritagePlaces=self.heritagePlaces;
        detailViewController.urlString = url;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
        
       // [detailViewController.view setSize:self.view.frame.size];
         [detailViewController.view setSize:self.rootViewController.view.size];

    }
    else {
        
        [detailViewController setRootViewController:self.rootViewController];
if(self.heritagePlaces.count!=0)
{
        NSString *str = [(HeritagePlace *)self.detailObject image];
        NSString *str1 = [(HeritagePlace *)self.detailObject heritagebuildinginfoguid];
        NSURL *url = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",str1, str]];
        NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
        NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
        detailViewController.name = self.titleLabel.text;
        detailViewController.desc = description;
        detailViewController.urlString = url;
        detailViewController.arr = arr;
    detailViewController.heritagePlaces=self.heritagePlaces;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
        [[NSUserDefaults standardUserDefaults]setInteger:200 forKey:@"Back"];
        
        [detailViewController.view setSize:self.rootViewController.view.size];
}
else{

    NSString *descriptionPainText = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
    NSString * description=[NSString stringWithFormat:@"%@", descriptionPainText];
    detailViewController.name = self.titleLabel.text;
    detailViewController.desc = description;
    detailViewController.urlString = [self.detailObject objectForKey:@"Photo"];
    detailViewController.arr = arr;
     detailViewController.heritagePlaces=self.heritagePlaces;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Back"];
    [[NSUserDefaults standardUserDefaults]setInteger:200 forKey:@"Back"];
    
    [detailViewController.view setSize:self.rootViewController.view.size];
}

    }
    [self.rootViewController pushViewController:detailViewController animated:NO];

     NSLog(@"x is ====>>%f",self.view.frame.origin.x);
     NSLog(@"Y is ====>>%f",self.view.frame.origin.y);
        NSLog(@"Width is ====>>%f",self.view.frame.size.width);
        NSLog(@"Height is ====>>%f",self.view.frame.size.height);
    
         NSLog(@"Writing action");

}


@end
