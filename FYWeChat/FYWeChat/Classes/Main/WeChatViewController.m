//
//  WeChatViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
@interface WeChatViewController ()
- (IBAction)BtnLogout:(id)sender;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *Icon;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *NickName;
//微信号
@property (weak, nonatomic) IBOutlet UILabel *WeiXinNum;

@end

@implementation WeChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    、显示当前登录用户的个人信息
//    如何使用Coredata获取数据
//    1.上下文【关联到数据库】
//    2.FetchRequest
//    3.设置过滤和排序
//    4.执行请求获取数据
    
//    Xmpp框架提供了一个方法，可以直接获取个人信息  使用电子名片模块
   XMPPvCardTemp *myCard=[WeChatXMPPTool sharedWeChatXMPPTool].vCard.myvCardTemp;
//    设置头像
    if (myCard.photo) {
        self.Icon.image=[UIImage imageWithData:myCard.photo];
    }
//   设置昵称
    self.NickName.text=myCard.nickname;
//    设置微信号
    NSString *user=[WeChatUser sharedWeChatUser].username;
    self.WeiXinNum.text=[NSString stringWithFormat:@"微信号:%@",user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (IBAction)BtnLogout:(id)sender
{
//    直接调用AppDelegate中的退出登录的方法
//    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [[WeChatXMPPTool sharedWeChatXMPPTool] logout];
}
@end
