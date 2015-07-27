
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
    //    如何使用Coredata获取数据
    //    1.上下文【关联到数据库】
  NSManagedObjectContext *context=[WeChatXMPPTool sharedWeChatXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    //    2.FetchRequest
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    //    3.设置过滤和排序
//    当前登录用户的JID
    NSString *jid=[WeChatUser sharedWeChatUser].JID;
//    过滤当前登录用户的好友
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate=pre;
    
//    排序
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors=@[sort];
    //    4.执行请求获取数据
//    self.friends=[context executeFetchRequest:request error:nil];
        _resaultControl=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resaultControl.delegate=self;
    NSError *error=nil;
    [_resaultControl performFetch:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}
#pragma mark --当数据的内容发生变化后，会调用这个方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"数据发生改变");
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//   获取对应好友
    XMPPUserCoreDataStorageObject *friend=_resaultControl.fetchedObjects[indexPath.row];
//    sectionNum
//    "0"在线
//    “1”离开
//    “2”离线
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
