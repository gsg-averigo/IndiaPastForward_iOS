//
//  Connection.m
//  audit
//
//  Created by Harish Kishenchand on 17/09/13.
//  Copyright (c) 2013 cpf. All rights reserved.
//

#import "Connection.h"
#import "NSObject+Parser.h"
#import "AlertView.h"

@interface Connection ()
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSHTTPURLResponse *httpResponse;
@end


@implementation Connection
@synthesize connectionDelegate = _connectionDelegate;
@synthesize connectionPriority = _connectionPriority;
@synthesize connectionIdentifier = _connectionIdentifier;
@synthesize responseData = _responseData;

#pragma mark - Initialization

- (id)initWithRequest:(NSURLRequest *)request{
    self = [super initWithRequest:request delegate:self startImmediately:NO];
    if(self){
        self.responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (id)initWithUrl:(NSURL *)url{
    self = [self initWithRequest:[NSURLRequest requestWithURL:url]];
    if(self){
        
    }
    return self;
}

- (void)start{
    if([[ConnectionManager defaultManager] respondsToSelector:@selector(willStartConnection:)]){
        [[ConnectionManager defaultManager] performSelector:@selector(willStartConnection:)
                                                   onThread:[NSThread mainThread]
                                                 withObject:self
                                              waitUntilDone:YES];
    }
    [super start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.httpResponse = (NSHTTPURLResponse *)response;
    if([response isKindOfClass:[NSHTTPURLResponse class]]){
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
        if([httpResponse statusCode] == 404){
            //[AlertView showAlertMessage:@"Sorry, We are not able to connect the service right now. Please try agaiin later."];
            //[AlertView showAlertMessage:@"Sorry, PM eCollection is unavailable at the moment. Please try again later."];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
    if([self.connectionDelegate respondsToSelector:@selector(connection:didWriteData:totalBytesWritten:expectedTotalBytes:)]){
        [self.connectionDelegate connection:self
                               didWriteData:data.length
                          totalBytesWritten:self.responseData.length
                         expectedTotalBytes:self.httpResponse.expectedContentLength];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if([(NSHTTPURLResponse *)self.httpResponse statusCode] == 200){
        if([self.connectionDelegate respondsToSelector:@selector(connection:didReceiveData:)]){
            if([self.httpResponse.MIMEType isEqualToString:@"application/xml"] ||
               [self.httpResponse.MIMEType isEqualToString:@"text/xml"]) {
                [self.connectionDelegate connection:self didReceiveData:[self.responseData xmlValue]];
            }
            else if([self.httpResponse.MIMEType isEqualToString:@"application/json"] ||
                    [self.httpResponse.MIMEType isEqualToString:@"text/json"]){
                [self.connectionDelegate connection:self didReceiveData:[self.responseData jsonValue]];
            }
            else if([self.httpResponse.MIMEType isEqualToString:@"image/bmp"] ||
                    [self.httpResponse.MIMEType isEqualToString:@"image/jpeg"] ||
                    [self.httpResponse.MIMEType isEqualToString:@"image/png"]){
                [self.connectionDelegate connection:self didReceiveData:[UIImage imageWithData:self.responseData]];
            }
            else if([self.httpResponse.MIMEType isEqualToString:@"text/html"]){
                [self.connectionDelegate connection:self didReceiveData:[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]];
            }
            else{
                [self.connectionDelegate connection:self didReceiveData:self.responseData];
            }
        }
    }
    else if([self.httpResponse isKindOfClass:[NSHTTPURLResponse class]]){
        if([(NSHTTPURLResponse *)self.httpResponse statusCode] == 404)
        {
            [self.connectionDelegate connection:self didFailWithError:nil];
            if(self.isModalConnection){
                [AlertView showAlertMessage:@"Sorry. We are not able to connect to the server right now. Please try again later."];
            }
        }
    }
    
    [[ConnectionManager defaultManager] didFinishConnection:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if([self.connectionDelegate respondsToSelector:@selector(connection:didFailWithError:)]){
        [self.connectionDelegate connection:self didFailWithError:error];
    }
}

@end
