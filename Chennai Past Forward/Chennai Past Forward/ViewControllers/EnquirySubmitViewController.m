//
//  EnquirySubmitViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 22/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import "EnquirySubmitViewController.h"
#import "Request.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AlertView.h"
#import "RNBlurModalView.h"
#import "HeritagePlacesViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


@interface EnquirySubmitViewController ()

@end

@implementation EnquirySubmitViewController

int x=0;

NSString * noticationName =@"IMAGE_ARRAY";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
   // self = [super initWithNibName:@"EnquirySubmitViewController" bundle:nil];
    if (IPAD)
    {
    self = [super initWithNibName:@"EnquirySubmitViewController~iPad" bundle:nil];
    }
    else
    {
    self = [super initWithNibName:@"EnquirySubmitViewController" bundle:nil];
    }
    
    if(self)
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //_image_array=[[NSMutableArray alloc]init];
    NSLog(@"submitview imagearraycount %lu",(unsigned long)_image_array.count);
    //_image_view.image=[_image_array objectAtIndex:0];
    NSLog(@"submitview imagearraycount %lu",(unsigned long)_image_array.count);
    [_desc_txt setDelegate:self];
    for(UIImageView *i in self.image_scroll.subviews){
        [i removeFromSuperview];
    }
    x=0;
        for(int i=0;i<_image_array.count;i++)
        {
        UIImageView *swipe_img;
        if(i==0)
        {
            swipe_img =[[UIImageView alloc] initWithFrame:CGRectMake(x, 0,self.view.width,self.image_scroll.height)];
            x+=self.view.width;
            
        }
        else
        {
            swipe_img =[[UIImageView alloc] initWithFrame:CGRectMake(x, 0,self.view.width,self.image_scroll.height)];
            x+=self.view.width;
        }
        swipe_img.image=[_image_array objectAtIndex:i];
        swipe_img.userInteractionEnabled=YES;
        swipe_img.contentMode = UIViewContentModeScaleAspectFit;
        [swipe_img setTag:i+1];
        [self.image_scroll addSubview:swipe_img];
    }
    self.image_scroll.contentSize = CGSizeMake(x,self.image_scroll.frame.size.height);
    if(_image_array.count==3)
    {
    for(int i=0;i<_image_array.count;i++)
    {
        CGFloat xOrigin = i * 90;
        UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,80,80)];
        dot.image=[_image_array objectAtIndex:i];
        dot.userInteractionEnabled=YES;
        [dot setTag:i+1];
        UIButton * ButtonOnImageView = [[UIButton alloc]init];
        [ButtonOnImageView setFrame:CGRectMake(60,0,20,20)];
        [ButtonOnImageView setTag:i+1];
        [ButtonOnImageView setImage:[UIImage imageNamed:@"Delete-32.png"] forState:UIControlStateNormal];
        [ButtonOnImageView addTarget:self action:@selector(OnClickOfTheButton:) forControlEvents:UIControlEventTouchUpInside];
        [dot addSubview:ButtonOnImageView];
        [ButtonOnImageView setUserInteractionEnabled:YES];
        [self.slide_view addSubview:dot];
    }
    }
    else{
        
        for (int i=0; i<_image_array.count+1; i++) {
            
            if (i!=_image_array.count) {
            CGFloat xOrigin = i * 90;
            UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,80,80)];
            dot.image=[_image_array objectAtIndex:i];
            dot.userInteractionEnabled=YES;
            [dot setTag:i+1];
            UIButton * ButtonOnImageView = [[UIButton alloc]init];
            [ButtonOnImageView setFrame:CGRectMake(60,0,20,20)];
            [ButtonOnImageView setTag:i+1];
            [ButtonOnImageView setImage:[UIImage imageNamed:@"Delete-32.png"] forState:UIControlStateNormal];
            [ButtonOnImageView addTarget:self action:@selector(OnClickOfTheButton:) forControlEvents:UIControlEventTouchUpInside];
            [dot addSubview:ButtonOnImageView];
            [ButtonOnImageView setUserInteractionEnabled:YES];
            [self.slide_view addSubview:dot];
            }
            else{
                CGFloat xOrigin = i * 90;
                UIButton *add =[[UIButton alloc] initWithFrame:CGRectMake(xOrigin,20,40,40)];
                [add setImage:[UIImage imageNamed:@"PlusFilledNew-64.png"] forState:UIControlStateNormal];
                [add addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
                [add setUserInteractionEnabled:YES];
                [add setTag:i+1];
                [self.slide_view addSubview:add];

            }

        }
        
    }
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];

    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self action:@selector(doneClicked:)];
    keyboardDoneButtonView.items = @[flexBarButton, doneButton];
    self.desc_txt.inputAccessoryView = keyboardDoneButtonView;

}
-(void)viewWillAppear:(BOOL)animated
{
    self.rootViewController.topvew.hidden = NO;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}
-(IBAction)onSubmitClick:(id)sender
{
   
        
    if(IPAD)
    {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3+30,self.view.frame.size.height/3, 170, 170)];
        self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.loadingView.clipsToBounds = YES;
        self.loadingView.layer.cornerRadius = 10.0;
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.frame = CGRectMake(self.loadingView.frame.size.width/3+10,self.loadingView.frame.size.height/3-25,30,30);
        [self.loadingView addSubview:self.activityView];
        self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, 130, 22)];
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.adjustsFontSizeToFitWidth = YES;
        self.loadingLabel.textAlignment = UITextAlignmentCenter;
        self.loadingLabel.text = @"Sending Enquiry...";
        [self.loadingView addSubview:self.loadingLabel];

    }
    else{
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
        self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.loadingView.clipsToBounds = YES;
        self.loadingView.layer.cornerRadius = 10.0;
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.frame = CGRectMake(self.loadingView.frame.size.width/2-15,self.loadingView.frame.size.height/3,30,30);
        [self.loadingView addSubview:self.activityView];
        self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.adjustsFontSizeToFitWidth = YES;
        self.loadingLabel.textAlignment = UITextAlignmentCenter;
        self.loadingLabel.text = @"Sending Enquiry...";
        [self.loadingView addSubview:self.loadingLabel];
    }
    //self.activityView.frame=CGRectMake(self.view.frame.size.width/2,self.view.frame.size.height/3 , 30, 30);
    //[self.view addSubview:self.activityView];
    [self.view addSubview:self.loadingView];
    
    [self onSubmitForm:_image_array];
   
}
-(IBAction)onCancelClick:(id)sender
{
    NSLog(@"CANCELCLICKED");
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self title:@"Hello world!" message:@"Pur your message here."];
    [modal show];
}
-(IBAction)OnClickOfTheButton:(UIButton *)button
{
    NSLog(@"on deleted clicked");
    UIImageView *subview =[self.slide_view viewWithTag:button.tag];
    [_image_array removeObject:[subview image]];
    for (UIImageView *v in self.slide_view.subviews) {
        [v removeFromSuperview];
    }
    for(UIImageView *i in self.image_scroll.subviews){
        [i removeFromSuperview];
    }
    x=0;
    UIImageView *swipe_img;
    //[subview removeFromSuperview];
    for (int i=0; i<_image_array.count+1;i++) {
        if (i!=_image_array.count) {
        if(i==0)
        {
        swipe_img =[[UIImageView alloc] initWithFrame:CGRectMake(x, 0,self.view.width,self.image_scroll.height)];
        x += self.image_scroll.frame.size.width;
        self.image_scroll.contentSize = CGSizeMake(x,self.image_scroll.frame.size.height);
        }
        else{
        swipe_img =[[UIImageView alloc] initWithFrame:CGRectMake(x, 0,self.view.width,self.image_scroll.height)];
        x += self.image_scroll.frame.size.width;
        self.image_scroll.contentSize = CGSizeMake(x,self.image_scroll.frame.size.height);
        }
        swipe_img.image=[_image_array objectAtIndex:i];
        swipe_img.userInteractionEnabled=YES;
        [swipe_img setTag:i+1];
        [self.image_scroll addSubview:swipe_img];
        CGFloat xOrigin = i * 90;
        UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0,80,80)];
        dot.image=[_image_array objectAtIndex:i];
        dot.userInteractionEnabled=YES;
        [dot setTag:i+1];
        UIButton * ButtonOnImageView = [[UIButton alloc]init];
        [ButtonOnImageView setFrame:CGRectMake(60,0,20,20)];
        [ButtonOnImageView setTag:i+1];
        [ButtonOnImageView setImage:[UIImage imageNamed:@"Delete-32.png"] forState:UIControlStateNormal];
        [ButtonOnImageView addTarget:self action:@selector(OnClickOfTheButton:) forControlEvents:UIControlEventTouchUpInside];
        [dot addSubview:ButtonOnImageView];
        [ButtonOnImageView setUserInteractionEnabled:YES];
        [self.slide_view addSubview:dot];
        }
        else{
            CGFloat xOrigin = i * 90;
            UIButton *add =[[UIButton alloc] initWithFrame:CGRectMake(xOrigin,20,40,40)];
            [add setImage:[UIImage imageNamed:@"PlusFilledNew-64.png"] forState:UIControlStateNormal];
            [add addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
            [add setUserInteractionEnabled:YES];
            [add setTag:i+1];
            [self.slide_view addSubview:add];
            
        }
    }

    
}
-(IBAction)onAddClick:(id)sender
{
    NSLog(@"add button clicked");
    NSDictionary   * theInfo =
    [NSDictionary dictionaryWithObjectsAndKeys:_image_array,@"myImageArray", nil];
    NSNotification * notification =[[ NSNotification alloc]initWithName:noticationName object:nil userInfo:theInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.rootViewController popViewController:self animated:YES];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length]==0) {
        [_desc_lbl setHidden:NO];
    }
    else{
        [_desc_lbl setHidden:YES];
    }
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-220,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)onSubmitForm:(NSMutableArray *)image_array
{
    
         NSString* encodedUrl = [self.desc_txt.text stringByAddingPercentEscapesUsingEncoding:
                                 NSUTF8StringEncoding];
    NSString *urlString=[NSString stringWithFormat:@"http://www.pastforward.in/services/upload_enquiry_images.php?CPFUserEmail=%@&EnquiryMessage=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"email"],encodedUrl];
    NSLog(@"url%@",urlString);
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"postValues" forHTTPHeaderField:@"METHOD"];
     NSString *boundary = @"---------------------------14737809831466499882746641449";
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /*
     now lets create the body of the post
     */
    NSMutableData *body = [NSMutableData data];
    
    
    //[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self.activityView startAnimating];
    for (int i=0; i<image_array.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation([image_array objectAtIndex:i], 90);
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
      NSString *s= [self generateRandomNumber];
    NSString *uploadfile=[NSString stringWithFormat:@"uploadedfile%d", i+1];
    NSLog(@"UPLOAD FILE %@",uploadfile);
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",uploadfile,s] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSString *content = @"title=%d&imagelink=Hello&latitude=sdsa&longitude=dsdsad";
    
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    }
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    [request setHTTPBody:body];
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"%@",returnString);
         [self.activityView stopAnimating];
    [self.loadingView removeFromSuperview];
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Success" message:@"Enquiry Sent" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
          [alert show];
     });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [alertView cancelButtonIndex]) {
        NSLog(@"The cancel button was clicked from alertView");
        UIViewController *viewController =[[RootViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"PushMsg"];
        UIWindow *window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
        window.rootViewController = viewController;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSString *)generateRandomNumber
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:10];
    for (NSUInteger i = 0U; i < 10; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    
    NSLog(@"%@",s);
    return s;
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
