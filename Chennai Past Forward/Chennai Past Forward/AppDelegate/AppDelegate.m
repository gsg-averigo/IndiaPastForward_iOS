//
//  AppDelegate.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 22/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "RootViewController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "DetailViewController.h"
#import "TabsViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "AlertView.h"
#import "NSObject+Parser.h"
#import "HeritagePlace.h"
#import "PreviewViewController.h"
#import "Offer.h"
#import "Article.h"
#import "Photo.h"
#import "TransitionController.h"
//@import GoogleMaps;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.navigationController = [[UINavigationController alloc]init];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor colorWithRed:170.0/255.0 green:21.0/255.0 blue:29.0/255.0 alpha:1.0],
                             UITextAttributeTextColor,
                             [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                             UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes: attribs];
    [[UIBarButtonItem appearance] setTitleTextAttributes: attribs forState:UIControlStateNormal];

    NSLog(@"App Launched");
    // Let the device know we want to receive push notifications

    
    //-- Set Notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    [application setIdleTimerDisabled:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:@"PushMsg"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PushGUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    if(apsInfo)
    {
         [[NSUserDefaults standardUserDefaults]setObject:[apsInfo objectForKey:@"id"] forKey:@"PushGUID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"PushMsg"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //[self TestMode];
    [self setWindowRootViewController];
    [self.window makeKeyAndVisible];
    
    //[GMSServices provideAPIKey:@"AIzaSyCF3uIMJXtlfre5Afw00oETE97ZAr6zG0Y"];
   
    return YES;
    
}

-(void)TestMode
{
    [[NSUserDefaults standardUserDefaults]setObject:@"e6db8034-0667-11e3-9451-b063dd2b3fb9" forKey:@"PushGUID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"PushMsg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)applicationWillResignActive:(UIApplication *)application{

}

- (void)applicationDidEnterBackground:(UIApplication *)application{

}

- (void)applicationWillEnterForeground:(UIApplication *)application{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}


#pragma mark - notification delegates

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSString *host = @"http://www.india-pastforward.com";
//    NSString *urlString = @"/ws/pushnotification.php";
//    NSLog(@"devicetoken length: %lu", (unsigned long)[deviceToken length]);
//
//    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:urlString];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"Register URL: %@", url);
//    NSLog(@"Return Data: %@", returnData);
//        //code ended//
    NSString* token = [deviceToken description];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Device Token :%@",token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#if !TARGET_IPHONE_SIMULATOR   

    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSLog(@"APS INFO:%@",apsInfo);
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    NSLog(@"Recived Push APS Info: %@",apsInfo);
   // NSString *sound;
    //sound = [apsInfo objectForKey:@"sound"];

    //application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
/*if(apsInfo)
{
 
}
*/
#endif
    
}
- (void)setWindowRootViewController
{
    UIViewController *viewController = ([self isRegistered]) ? [[RootViewController alloc] init] : [[RegisterViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navigationController setNavigationBarHidden:YES];
    [self.window setRootViewController:navigationController];
}

- (BOOL)isRegistered
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isRegistered"];
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
- (void)saveContext
{
    NSError *error = nil;
   managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.




- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Chennai Past Forward" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
   
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *resultURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSLog(@"%@",resultURL);
    
     NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Chennai Past Forward.sqlite"];
 
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
