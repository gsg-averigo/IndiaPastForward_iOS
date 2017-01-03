//
//  ConnectionManager.m
//  audit
//
//  Created by Harish Kishenchand on 17/09/13.
//  Copyright (c) 2013 cpf. All rights reserved.
//

#import "ConnectionManager.h"
#import "Reachability.h"

#define ACTIVE_REQUEST_QUEUE_LENGTH 3

@interface ConnectionManager ()
@property (strong, nonatomic) NSMutableArray *activeConnectionRequestQueue;
@property (strong, nonatomic) NSMutableArray *pendingConnectionRequestQueue;
@property (strong, nonatomic) NSMutableArray *offlineConnectionRequestQueue;
@property (strong, nonatomic) Reachability *reachability;
@end

@implementation ConnectionManager
@synthesize activeConnectionRequestQueue = _activeConnectionRequestQueue;
@synthesize pendingConnectionRequestQueue = _pendingConnectionRequestQueue;
@synthesize offlineConnectionRequestQueue = _offlineConnectionRequestQueue;
@synthesize reachability = _reachability;

+ (id)defaultManager{
    static ConnectionManager *connectionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionManager = [[ConnectionManager alloc] init];
    });
    return connectionManager;
}

- (id)init{
    self = [super init];
    if(self){
        [self startReachabilityNotifier];
        self.activeConnectionRequestQueue = [[NSMutableArray alloc] init];
        self.pendingConnectionRequestQueue = [[NSMutableArray alloc] init];
        self.offlineConnectionRequestQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Rechability Notifications

- (void)reachabilityChanged:(NSNotification* )notification{
	self.reachability = [notification object];
    if(self.reachability.currentReachabilityStatus != NotReachable){
        for (Connection *connection in self.offlineConnectionRequestQueue) {
            [self addConnection:connection];
        }
        [self.offlineConnectionRequestQueue removeAllObjects];
    }
}


#pragma mark -

- (void)addConnection:(Connection *)connection{
    [self enqueueConnection:connection];
    if(connection.connectionPriority == ConnectionPriorityHigh || [self canStartNextConnection]){
        [self startNextConnection];
    }
}


#pragma mark -

- (void)startReachabilityNotifier{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self setReachability:[Reachability reachabilityForInternetConnection]];
    [self.reachability startNotifier];
}

- (BOOL)canStartNextConnection{
    return ([self.activeConnectionRequestQueue count] < ACTIVE_REQUEST_QUEUE_LENGTH);
}

- (void)startNextConnection{
    if([self.pendingConnectionRequestQueue count] > 0){
        Connection *connection = [self.pendingConnectionRequestQueue objectAtIndex:0];
        if(!self.reachability.connectionRequired){
            [connection start];
        }
        else{
            if(connection.connectLaterIfNeeded){
                [self.offlineConnectionRequestQueue insertObject:connection atIndex:0];
                [self.pendingConnectionRequestQueue removeObject:connection];
            }
            else{
                [connection start];
            }
        }
    }
}

- (void)willStartConnection:(Connection *)connection{
    [self.activeConnectionRequestQueue addObject:connection];
    [self.pendingConnectionRequestQueue removeObject:connection];
    //self.totalUploadBytesLength += connection.originalRequest.HTTPBody.length;
}

- (void)didFinishConnection:(Connection *)connection{
    [self.activeConnectionRequestQueue removeObject:connection];
    //self.totalDownloadBytesLength += connection.data.length;
    if([self canStartNextConnection]){
        [self startNextConnection];
    }
}

#pragma mark - Enqueue Operations

- (void)enqueueConnection:(Connection *)connection{
    if(connection.connectionPriority == ConnectionPriorityHigh){
        [self enqueueHighPriorityConnection:connection];
    }
    else if(connection.connectionPriority == ConnectionPriorityMedium){
        [self enqueueMediumPriorityConnection:connection];
    }
    else if(connection.connectionPriority == ConnectionPriorityLow){
        [self enqueueLowPriorityConnection:connection];
    }
}

- (void)enqueueHighPriorityConnection:(Connection *)connection
{
    for (Connection *_connection in self.pendingConnectionRequestQueue) {
        if(_connection.connectionPriority == ConnectionPriorityMedium){
            [self.pendingConnectionRequestQueue insertObject:connection atIndex:[self.pendingConnectionRequestQueue indexOfObject:_connection]];
            return;
        }
        else if(_connection == [self.pendingConnectionRequestQueue lastObject]){
            [self.pendingConnectionRequestQueue addObject:connection];
            return;
        }
    }
    [self.pendingConnectionRequestQueue addObject:connection];
}

- (void)enqueueMediumPriorityConnection:(Connection *)connection
{
    for (Connection *_connection in self.pendingConnectionRequestQueue) {
        if(_connection.connectionPriority == ConnectionPriorityLow){
            [self.pendingConnectionRequestQueue insertObject:connection atIndex:[self.pendingConnectionRequestQueue indexOfObject:_connection]];
            return;
        }
        else if(_connection == [self.pendingConnectionRequestQueue lastObject]){
            [self.pendingConnectionRequestQueue addObject:connection];
            return;
        }
    }
    [self.pendingConnectionRequestQueue addObject:connection];
}

- (void)enqueueLowPriorityConnection:(Connection *)connection
{
    [self.pendingConnectionRequestQueue addObject:connection];
}

@end