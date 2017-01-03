//
//  RegisterViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 22/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"

#import "Request.h"
#import "AlertView.h"
#import "Categories.h"
#import "NSObject+Parser.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDevice+IdentifierAddition.h"

@interface RegisterViewController ()
{
    UIView *rootView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *accessCodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendAccessCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *proceedButton;
@property (strong, nonatomic) IBOutlet UIButton *alreadyRegisteredButton;
@end

@implementation RegisterViewController
UITextField *currentTextField;
//NSInteger responseAccessCode;

#pragma mark -

- (id)init
{
    if (IPAD)
    {
        self = [super initWithNibName:@"RegisterViewController~iPad" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"RegisterViewController" bundle:nil];
    }
    //  self = [super initWithNibName:@"RegisterViewController" bundle:nil];
    if(self)
    {
        
    }
    return self;
}

#pragma mark -

- (void)viewDidLoad{
    [super viewDidLoad];
    
    rootView = self.navigationController.view;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *showintro = [defaults objectForKey:@"showintro"];
    NSLog(@"ShowIntro register:%@",showintro);
    if (![showintro isEqualToString:@"yes"])
    {
        [self introductionview];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint buttonOrigin = self.alreadyRegisteredButton.frame.origin;
    
    CGFloat buttonHeight = self.alreadyRegisteredButton.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
}



#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



#pragma mark -

-(IBAction)textfieldreturn:(id)sender
{
    [sender resignFirstResponder];
}
#pragma mark -

- (IBAction)sendAccessCodeButtonTapped:(id)sender{
    [currentTextField resignFirstResponder];
    if(![self isEmail:self.emailTextField.text]){
        [AlertView showAlertMessage:@"Please enter a valid email address"];
        [self.emailTextField becomeFirstResponder];
        return;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:self.emailTextField.text forKey:@"strEmailID"];
    [Request makeRequestWithIdentifier:SEND_ACCESS_CODE parameters:parameters delegate:self];
    [AlertView showProgress];
}
-(void)introductionview
{
    
    if (IPAD)
    {
        EAIntroPage *page1 = [EAIntroPage page];
        page1.bgImage = [UIImage imageNamed:@"768X1024.png"];
        page1.title=@"";
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds];
        [intro setDelegate:self];
        [intro setPages:@[page1]];
        intro.pageControl.hidden=YES;
        [intro showInView:rootView animateDuration:0.3];
    }
 else
 {
     EAIntroPage *page1 = [EAIntroPage page];
     page1.bgImage = [UIImage imageNamed:@"1600X2560.png"];
     page1.title=@"";
     
     
     EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds];
     [intro setDelegate:self];
     [intro setPages:@[page1]];
     intro.pageControl.hidden=YES;
     [intro showInView:rootView animateDuration:0.3];
  
     
 }
    
}

- (IBAction)proceedButtonTapped:(id)sender
{
    [currentTextField resignFirstResponder];
    if(![self isEmail:self.emailTextField.text])
    {
        [AlertView showAlertMessage:@"Please enter a valid email address"];
        [self.emailTextField becomeFirstResponder];
        return;
    }
    
    /*if([self.accessCodeTextField.text integerValue] != responseAccessCode){
        [AlertView showAlertMessage:@"Invalid access code"];
        [self.accessCodeTextField becomeFirstResponder];
        return;
    }*/
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:self.emailTextField.text forKey:@"strEmailID"];
    [parameters setObject:self.nameTextField.text forKey:@"strUserName"];
    [parameters setObject:self.accessCodeTextField.text forKey:@"strAccessCode"];
    [parameters setObject:self.accessCodeTextField.text forKey:@"strDeviceType"];
    [parameters setObject:@"Phone" forKey:@"strDeviceResolution"];
    [parameters setObject:@"Apple" forKey:@"strVendorname"];
    [parameters setObject:[[UIDevice currentDevice] model] forKey:@"strModelName"];
    [parameters setObject:[[UIDevice currentDevice] systemVersion] forKey:@"strOSversion"];
    [parameters setObject:self.accessCodeTextField.text forKey:@"strInternetSpeed"];
    [parameters setObject:@"Y" forKey:@"strUserType"];
    [Request makeRequestWithIdentifier:REGISTER_USER parameters:parameters delegate:self];
    [AlertView showProgress];
}

- (IBAction)alreadyRegisteredButtonTapped:(id)sender
{
    [currentTextField resignFirstResponder];
    NSLog(@"UDID:%@",[[UIDevice currentDevice] uniqueDeviceIdentifier]);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:@"Y" forKey:@"strUserType"];
    [Request makeRequestWithIdentifier:CHECK_ALREADY_REGISTERED parameters:parameters delegate:self];
    [AlertView showProgress];
}


#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
}


#pragma mark -

- (void)keyboardWillShow:(NSNotification *)notification{
    //[self HideKeyBoard];
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.42];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.alreadyRegisteredButton.bottom + 4)];
    //[self.view setHeight:self.view.height - keyboardBounds.size.height];
    [self.scrollView scrollRectToVisible:currentTextField.frame animated:YES];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.42];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.alreadyRegisteredButton.bottom + 8)];
   // [self.view setHeight:self.view.height + keyboardBounds.size.height];
    [self.scrollView scrollRectToVisible:currentTextField.frame animated:YES];
    
    [UIView commitAnimations];
}

-(void)HideKeyBoard
{
    CGRect keyboardBounds;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.42];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.alreadyRegisteredButton.bottom + 4)];
    [self.view setHeight:self.view.height - keyboardBounds.size.height];
    [self.scrollView scrollRectToVisible:currentTextField.frame animated:YES];
    
    [UIView commitAnimations];
}

#pragma mark -

- (void)connection:(Connection *)connection didReceiveData:(id)data{
    [AlertView hideAlert];
    if([data isKindOfClass:[NSString class]]){
        data = [data jsonValue];
    }
    
    if(connection.connectionIdentifier == SEND_ACCESS_CODE){
        if([[data objectForKey:@"success"] boolValue])
        {
           // responseAccessCode = [[data objectForKey:@"AccessCode"] integerValue];
        }
        [AlertView showAlertMessage:[data objectForKey:@"ValueResponse"]];
    }
    else if(connection.connectionIdentifier == CHECK_ALREADY_REGISTERED){
        NSLog(@"Data:%@",data);
        if([[data objectForKey:@"success"] boolValue]){
            self.emailTextField.text = [data objectForKey:@"ValueResponse"];
            [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRegistered"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"yes" forKey:@"showintro"];
            [defaults synchronize];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] performSelector:@selector(setWindowRootViewController)];
        }
        else{
            [AlertView showAlertMessage:[data objectForKey:@"ValueResponse"]];
        }
    }
    else if(connection.connectionIdentifier == REGISTER_USER){
        if([[data objectForKey:@"success"] boolValue]){
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
            [parameters setObject:self.emailTextField.text forKey:@"strEmailID"];
            [parameters setObject:@"IOS-" forKey:@"strGCMUserCode"];
            [parameters setObject:[@"IOS-" stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]] forKey:@"strGCMUserCode"];
            [Request makeRequestWithIdentifier:UPDATE_GCMID parameters:parameters delegate:self];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"yes" forKey:@"showintro"];
            [defaults synchronize];
            [AlertView showAlertMessage:[data objectForKey:@"ValueResponse"]];
            [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRegistered"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] performSelector:@selector(setWindowRootViewController)];
        }
        else
        {
            [AlertView showAlertMessage:[data objectForKey:@"ValueResponse"]];
        }
    }
    
    else if(connection.connectionIdentifier == UPDATE_GCMID){
        NSLog(@"%@",data);
    }
}

- (void)connection:(Connection *)connection didFailWithError:(NSError *)error{
    [AlertView hideAlert];
//    if(error.code == 404){
//        [AlertView showAlertMessage:@"Sorry. We are not able to connect to the server right now. Please try again later."];
//    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
}


#pragma mark -

- (BOOL)isEmail:(NSString *)email{
    NSString* pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:email];
}


@end
