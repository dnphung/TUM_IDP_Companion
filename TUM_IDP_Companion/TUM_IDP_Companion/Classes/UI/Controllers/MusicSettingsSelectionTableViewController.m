//
//  MusicSettingsSelectionTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 14/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "MusicSettingsSelectionTableViewController.h"

@interface MusicSettingsSelectionTableViewController ()

@end

typedef NS_ENUM(NSInteger, SelectedTab) {
    SelectedTabLocalMusic       = 0,
    SelectedTabDiscover         = 1,
    SelectedTabIndividual       = 2
};

static NSString * kSettingDefualtOptionKey = @"SettingDefaultOption";
static NSString * kSettingOptionsKey = @"SettingOptions";
static NSUInteger kSelectedSegmentIndex = SelectedTabLocalMusic;
static CGFloat    kSectionHeaderHeight = 40.0f;

@implementation MusicSettingsSelectionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureViewSettings];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)configureViewSettings {
    
    NSString *newsTitle = NSLS_NEWS;
    NSString *artistsTitle = NSLS_ARTISTS;
    NSString *songsTitle = NSLS_SONGS;
    
   
    NSArray *feeds = @[@"Feed 1", @"Feed 2", @"Feed 3", @"Feed 4", @"Feed 5", @"Feed 6", @"Feed 7"];
    NSDictionary *newsInfo = @{newsTitle : feeds};
    
    NSArray *artists = @[artistsTitle];
    NSDictionary *artistsInfo = @{artistsTitle: artists};
    
    NSArray *songs = @[songsTitle];
    NSDictionary *songsInfo = @{songsTitle: songs};
    
    NSMutableArray *musicOptions = [@[newsInfo , artistsInfo, songsInfo] mutableCopy];
    
    if (kSelectedSegmentIndex == SelectedTabLocalMusic) {
        [musicOptions removeObject:artistsInfo];
        [musicOptions removeObject:songsInfo];
    }//if
    
    [self setOptions:musicOptions];
    self.defaultOption = feeds[0];
}

- (void)segmentControlSegmentDidChange:(UISegmentedControl *)segmentControl {
    
    kSelectedSegmentIndex = segmentControl.selectedSegmentIndex;
    
    [self configureViewSettings];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"IdentifierCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // Configure the cell...
    NSDictionary *itemInfo = self.options[indexPath.row];
    NSString *key = [[itemInfo allKeys] lastObject];
    NSArray *objects = [itemInfo valueForKey:key];
    NSString *empty = @"";
    NSString *selectedOption = ([objects containsObject:self.defaultOption]) ? self.defaultOption : empty;
    
    cell.textLabel.text = key;
    cell.detailTextLabel.text = selectedOption;
    cell.accessoryType = ([selectedOption isEqual:empty]) ? UITableViewCellAccessoryNone :UITableViewCellAccessoryCheckmark;
    
    return cell;
}

#pragma mark -UItableView Delegate methods.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //get the cell of last selected object.
    cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.options indexOfObject:self.defaultOption] inSection:0]];
    // remove the accessory view to last selected object.
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // get the currnet selected cell
    cell = [tableView cellForRowAtIndexPath:indexPath];
    // set the currnet selected object to global _defaultText feild.
    [self setDefaultOption:self.options[indexPath.row]];
    // set the check mark to the current object.
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    // deselecting the last row
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSArray *items = @[NSLS_LOCAL_MUSIC, NSLS_DISCOVERY, NSLS_INDIVIDUAL];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    
    [segmentControl setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), kSectionHeaderHeight)];
    [segmentControl addTarget:self action:@selector(segmentControlSegmentDidChange:) forControlEvents:UIControlEventValueChanged];
    
    segmentControl.selectedSegmentIndex = kSelectedSegmentIndex;
    
    return segmentControl;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
