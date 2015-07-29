
//
//  WeChatContactViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/27.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatContactViewController.h"

@interface WeChatContactViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resaultControl;
}
@property(strong,nonatomic)NSArray *friends;
@end

@implementation WeChatContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
//    从数据库中家在获取好友列表
    [self locaFriends];
}
-(void)locaFriends
{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
//    NSManagedObjectContext *context = [WeChatXMPPTool sharedWCXMPPTool]..mainThreadManagedObjectContext;
    NSManagedObjectContext *context=[WeChatXMPPTool sharedWeChatXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid = [WeChatUser sharedWeChatUser].JID;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
//    self.friends = [context executeFetchRequest:request error:nil];
//    NSLog(@"%@",self.friends);
    _resaultControl=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resaultControl.delegate=self;
       NSError *error=nil;
    
    [_resaultControl performFetch:&error];
    if (error) {
        FYLog(@"%@",error);
    }
}
#pragma mark --当数据的内容发生变化后，会调用这个方法(当好友发生变化时，实时刷新好友列表)
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"数据发生改变");
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _resaultControl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       static NSString *CellIdentifier = @"Photos";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   //   获取对应好友
    XMPPUserCoreDataStorageObject *friend=_resaultControl.fetchedObjects[indexPath.row];
    
////    sectionNum
////    "0"在线
////    “1”离开
////    “2”离线
    FYLog(@"%@",friend.sectionNum);
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.detailTextLabel.text=@"在线";
            break;
        case 1:
            cell.detailTextLabel.text=@"离开";

            break;
        case 2:
            cell.detailTextLabel.text=@"离线";

            break;
        default:
            break;
    }
    cell.textLabel.text=friend.jidStr;
    
    return cell;
}
//向左滑动时，删除好友
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FYLog(@"删除好友");
        
        XMPPUserCoreDataStorageObject *friend=_resaultControl.fetchedObjects[indexPath.row];
        [[WeChatXMPPTool sharedWeChatXMPPTool].roster removeUser:friend.jid];
    }
}
@end
