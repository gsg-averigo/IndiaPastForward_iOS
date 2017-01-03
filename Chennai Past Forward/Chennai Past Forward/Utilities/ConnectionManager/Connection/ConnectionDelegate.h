//
//  ConnectionDelegate.h
//  audit
//
//  Created by Harish Kishenchand on 17/09/13.
//  Copyright (c) 2013 cpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Connection;
@protocol ConnectionDelegate <NSObject>
@required
- (void)connection:(Connection *)connection didReceiveData:(id)data;
- (void)connection:(Connection *)connection didFailWithError:(NSError *)error;
@optional
- (void)connection:(Connection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes;
@end