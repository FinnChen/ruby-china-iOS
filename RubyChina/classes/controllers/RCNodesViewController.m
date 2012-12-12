//
//  RCNodesViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-23.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "RCNodesViewController.h"
#import "RCTopicMasterViewController.h"
#import <RestKit.h>
#import "UIViewController+RubyChina.h"

#define kNodeDefaultWeight 999

@interface RCNodesViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RCNodesViewController

@synthesize tableView = _tableView;
@synthesize nodes = _nodes;
@synthesize delegate = _delegate;

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.frame.size.height - 44.0f) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)nodes
{
    if (!_nodes) {
        _nodes = [NSArray array];
    }
    return _nodes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加节点";
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成"forState:UIControlStateNormal] ;
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn.png"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn_pressed.png"] forState:UIControlStateHighlighted];
    doneButton.frame = (CGRect){CGPointZero, [[UIImage imageNamed:@"search_page_cancel_btn.png"] size]};
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadNode];
    
//    RKObjectManager *objectManager = [RKObjectManager sharedManager];
//    RKManagedObjectMapping *nodeMapping =[RKManagedObjectMapping mappingForClass:[Node class] inManagedObjectStore:objectManager.objectStore];
//    nodeMapping.primaryKeyAttribute = @"nodeID";
//    [nodeMapping mapKeyPath:@"_id" toAttribute:@"nodeID"];
//    [nodeMapping mapKeyPath:@"name" toAttribute:@"nodeName"];
//
//    [objectManager.mappingProvider setMapping:nodeMapping forKeyPath:@""];
//    
//    [objectManager loadObjectsAtResourcePath:@"/nodes.json" delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _nodes = nil;
    _tableView = nil;
}

- (void)loadNode
{
    NSFetchRequest *request = [Node fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nodeID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.nodes = [Node objectsWithFetchRequest:request];
}

- (NSMutableArray *)nodesWillHide
{
    __block NSMutableArray *ret = [NSMutableArray array];
    [self.nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[obj showable] boolValue]) {
            [ret addObject:obj];
        }
    }];
    return ret;
}

- (void)doneButtonPressed
{
    [[self nodesWillHide] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[obj weight] isEqualToNumber:[NSNumber numberWithInt:kNodeDefaultWeight]]) {
            [obj setWeight:[NSNumber numberWithInt:kNodeDefaultWeight]];
        }
    }];
    [[[RKObjectManager sharedManager] objectStore] save:nil];
    
    [self.delegate updateNodes];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - RestKit Methods

//- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
//{
////    self.nodes = objects;
//    NSFetchRequest *request = [Node fetchRequest];
//    self.nodes = [Node objectsWithFetchRequest:request];
//    [self.tableView reloadData];
//}
//
//- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
//{
//    NSLog(@"Error: %@", error);
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Node *node = [self.nodes objectAtIndex:indexPath.row];
    cell.textLabel.text = [node nodeName];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    
    UIView *av = [self customeCellAccessoryView:indexPath];
    
    if ([node.showable boolValue]) {
        [[av viewWithTag:indexPath.row+1] setHidden:YES];
    } else {
        [[av viewWithTag:-(indexPath.row+1)] setHidden:YES];
    }
    
    cell.accessoryView = av;
    return cell;
}

- (UIView *)customeCellAccessoryView:(NSIndexPath *)indexPath
{
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setImage:[UIImage imageNamed:@"add_page_list_plus_btn.png"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"add_page_list_plus_btn_pressed.png"] forState:UIControlStateHighlighted];
    plusBtn.frame = (CGRect){CGPointZero, [[UIImage imageNamed:@"add_page_list_plus_btn.png"] size]};
    [plusBtn addTarget:self action:@selector(plusBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    plusBtn.tag = indexPath.row+1;
    
    UIButton *tickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tickBtn setImage:[UIImage imageNamed:@"add_page_list_tick_btn.png"] forState:UIControlStateNormal];
    [tickBtn setImage:[UIImage imageNamed:@"add_page_list_tick_btn_pressed.png"] forState:UIControlStateHighlighted];
    tickBtn.frame = (CGRect){CGPointZero, [[UIImage imageNamed:@"add_page_list_tick_btn.png"] size]};
    [tickBtn addTarget:self action:@selector(tickBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    tickBtn.tag = -(indexPath.row+1);
    
    
    UIView *av = [[UIView alloc] init];
    av.frame = plusBtn.frame;
    [av addSubview:plusBtn];
    [av addSubview:tickBtn];
    
    return av;
}

- (void)plusBtnPressed:(id)sender
{
    [(UIButton *)sender setHidden:YES];
    [[[(UIButton *)sender superview] viewWithTag:-([(UIButton *)sender tag])] setHidden:NO];
    
    Node *node = [self.nodes objectAtIndex:[(UIButton *)sender tag]-1];
    node.showable = [NSNumber numberWithBool:YES];
}

- (void)tickBtnPressed:(id)sender
{
    [(UIButton *)sender setHidden:YES];
    [[[(UIButton *)sender superview] viewWithTag:-([(UIButton *)sender tag])] setHidden:NO];
    Node *node = [self.nodes objectAtIndex:-([(UIButton *)sender tag])-1];
    node.showable = [NSNumber numberWithBool:NO];
//    node.weight = [NSNumber numberWithInt:-1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

@end
