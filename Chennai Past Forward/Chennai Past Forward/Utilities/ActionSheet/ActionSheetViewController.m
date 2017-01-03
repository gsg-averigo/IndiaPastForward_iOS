//
//  ActionSheetViewController.m
//  cpf
//
//  Created by Harish Kishenchand on 18/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "ActionSheetViewController.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface ActionSheetViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation ActionSheetViewController

- (id)init{
    
    
    if (IPAD)
    {
        self = [super initWithNibName:@"ActionSheetViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"ActionSheetViewController" bundle:nil];
    }
    
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

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.backgroundView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.60]];
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)]];
    [self.tableView setCenterShadow];
    [self.tableView.layer setCornerRadius:4];
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (IPAD)
    {
        [self.backgroundView setWidth:768];
        [self.backgroundView setHeight:1040];
        [self.tableView setTop:400];
        [self.tableView setWidth:700];
        [self.tableView setHeight:self.buttonTitles.count * 44];
    }
    else
    {
        [self.tableView setWidth:280];
        [self.tableView setHeight:self.buttonTitles.count * 44];
        [self.tableView alignCenter];
    }
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buttonTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor blackColor];
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
    }
    
    cell.textLabel.text = [self.buttonTitles objectAtIndex:indexPath.row];
    if([cell.textLabel.text isEqualToString:@"HERITAGE"]){
        cell.imageView.image = [UIImage imageNamed:@"heritage_icon"];
    }
    else if([cell.textLabel.text isEqualToString:@"ARTICLES"]){
        cell.imageView.image = [UIImage imageNamed:@"article_icon"];
    }
    else if([cell.textLabel.text isEqualToString:@"SETTINGS"]){
        cell.imageView.image = [UIImage imageNamed:@"settings"];
    }
    else if([cell.textLabel.text isEqualToString:@"GPS"]){
        cell.imageView.image = [UIImage imageNamed:@"gps_icon"];
    }
    else if([cell.textLabel.text isEqualToString:@"NOTIFICATION"]){
        cell.imageView.image = [UIImage imageNamed:@"notification_icon"];
    }
    else if([cell.textLabel.text isEqualToString:@"Facebook"]){
        cell.imageView.image = [UIImage imageNamed:@"fb_icon"];
    }
    else if([cell.textLabel.text isEqualToString:@"Twitter"]){
        cell.imageView.image = [UIImage imageNamed:@"twitter_icon"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view removeFromSuperview];
    if([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]){
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
        
    }
}

- (IBAction)backgroundTapped:(UITapGestureRecognizer *)gesture{
    if(!CGRectContainsPoint(self.tableView.frame, [gesture locationOfTouch:0 inView:self.view])){
        [self.view removeFromSuperview];
    }
}

@end