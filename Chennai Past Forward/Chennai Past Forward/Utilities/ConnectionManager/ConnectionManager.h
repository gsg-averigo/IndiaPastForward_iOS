//
//  ConnectionManager.h
//  audit
//
//  Created by Harish Kishenchand on 17/09/13.
//  Copyright (c) 2013 cpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Connection.h"

@interface ConnectionManager : NSObject
+ (id)defaultManager;
- (void)addConnection:(Connection *)connection;
- (void)willStartConnection:(Connection *)connection;
- (void)didFinishConnection:(Connection *)connection;
@end