//
//  FilterActionSheetListViewController.m
//  Chennai Past Forward
//
//  Created by BTS on 18/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import "FilterActionSheetListViewController.h"
#import "FilterTableViewCell.h"

@interface FilterActionSheetListViewController ()

@end

@implementation FilterActionSheetListViewController

- (id)init{
    
    
    self = [super initWithNibName:@"FilterActionSheetListViewController" bundle:nil];
    
    //self = [super initWithNibName:@"ArticlesViewController" bundle:nil];
    if(self){
        
    }
    return self;
}

- (id)initWithButtonTitles:(NSArray *)buttonTitles{
    self = [super init];
    if(self){
        self.buttonTitles = [[NSArray alloc] initWithArray:buttonTitles];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view from its nib.
    self.list_values=@[@"ATM",@"Hospital",@"Restaurant",@"Shopping mall"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list_values count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _list_values[indexPath.row];
    return cell;
}
@end
