//
//  AlertView.m
//  Instant
//
//  Created by Harish Kishenchand on 9/26/12.
//  Copyright (c) 2012 cpf. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define ACTIVITY_TAG 100
UIAlertView *alertview;

+(void)showAlertMessage:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+(void)showAlertMessageOption:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done",nil];
    [alert show];
}

+(void)showProgress
{
	alertview = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[indicator setFrame:CGRectMake(120.0, 50.0, 30.0, 30.0)];
	indicator.tag=ACTIVITY_TAG;
	[alertview addSubview:indicator];
	[indicator startAnimating];
	[alertview show];
    [alertview show];
    [alertview show];
    //[indicator release];
}

+ (void) hideAlert
{
	if(alertview != nil && [alertview isKindOfClass:[UIAlertView class]] ){
		if([alertview viewWithTag:ACTIVITY_TAG])
        {
			UIActivityIndicatorView *indicator=(UIActivityIndicatorView *)[alertview viewWithTag:500];
			[indicator stopAnimating];
		}
		[alertview dismissWithClickedButtonIndex:0 animated:YES];
		//alertview=nil;
	}
}

@end
