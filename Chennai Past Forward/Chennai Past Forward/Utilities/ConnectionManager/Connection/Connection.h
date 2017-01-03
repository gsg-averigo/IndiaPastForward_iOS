//
//  Connection.h
//  audit
//
//  Created by Harish Kishenchand on 17/09/13.
//  Copyright (c) 2013 cpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"
#import "ConnectionPriority.h"
#import "ConnectionIdentifier.h"

@interface Connection : NSURLConnection
{
    
}
@property (strong, nonatomic) id<ConnectionDelegate> connectionDelegate;
@property (nonatomic) ConnectionPriority connectionPriority;
@property (nonatomic) ConnectionIdentifier connectionIdentifier;
@property (nonatomic) BOOL connectLaterIfNeeded;
@property (nonatomic) BOOL isModalConnection;
- (id)initWithUrl:(NSURL *)url;
- (id)initWithRequest:(NSURLRequest *)request;
@end