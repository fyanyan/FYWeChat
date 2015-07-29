//
//  AddFriendViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/29.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
@end

@implementation AddFriendViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    添加好友
//    1.获取好友账号
    NSString *user=textField.text;
    FYLog(@"%@",user);
    
    NSString *friendJidStr=[NSString stringWithFormat:@"%@%@",user,@"fengyanyan.local"];
    XMPPJID *friendJid=[XMPPJID jidWithString:friendJidStr];
    
    
//    判断是否为手机号
    if (![textField isTelphoneNum]) {
//        1.给出提示
        [self showAlert:@"请输入正确的手机号"];
    }
//      判断时候添加自己为好友
    if([user isEqualToString:[WeChatUser sharedWeChatUser].username])
    {
        [self showAlert:@"不能添加自己为好友"];
        return YES;
    }
//    判断好友是否已经存在
    if ([[WeChatXMPPTool sharedWeChatXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[WeChatXMPPTool sharedWeChatXMPPTool].xmppStream]) {
//        返回值为YES表示好友已经存在
        [self showAlert:@"当前好友已存在"];
        return YES;
    }
    
//    2.发送添加好友的请求
//    添加好友，XMPP订阅
   
    [[WeChatXMPPTool sharedWeChatXMPPTool].roster subscribePresenceToUser:friendJid];
    return YES;
}
-(void)showAlert:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
