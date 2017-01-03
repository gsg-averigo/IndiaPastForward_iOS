//
//  AlertView.h
//  Instant
//
//  Created by Harish Kishenchand on 9/26/12.
//  Copyright (c) 2012 cpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertView : NSObject
+(void) showAlertMessage:(NSString *)message;
+(void) showProgress;
+(void) hideAlert;
+(void) showAlertMessageOption:(NSString *)message;
@end