//
//  AppDelegate.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 22/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController, TabsViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property  (strong,nonatomic) NSMutableArray *heritagePlaces;
@property (strong, nonatomic) UINavigationController *navigationController;

- (void)setWindowRootViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
