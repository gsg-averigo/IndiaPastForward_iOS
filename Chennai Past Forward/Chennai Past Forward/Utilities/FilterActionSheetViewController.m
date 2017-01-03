//
//  FilterActionSheetViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 18/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import "FilterActionSheetViewController.h"

@interface FilterActionSheetViewController ()

@end

@implementation FilterActionSheetViewController

-(id)init{
    
    self=[super initWithNibName:@"FilterActionSheetViewController" bundle:nil];
    CGRect newframe=self.view.frame;

    newframe.size.width=400;
    newframe.size.height=400;
    
    self.view.center=self.view.center;
    [self.view setFrame:newframe];
    
    if(self)
    {
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
