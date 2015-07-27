//
//  WeChatEditProfileViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/27.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatEditProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface WeChatEditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation WeChatEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    设置标题和textfield的默认值
    self.title=self.profileCell.textLabel.text;
    self.textfield.text=self.profileCell.detailTextLabel.text;
    
//    邮编添加按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
}

-(void)saveBtnClick
{
//    1.更改当前cell的detailtextlabel的值
    self.profileCell.detailTextLabel.text=self.textfield.text;
//    更新cell 的布局
    [self.profileCell layoutSubviews];
    
//    2.返回到上一个控制器
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate  respondsToSelector:@selector(editProfileViewControllerDidSava)]) {
        [self.delegate editProfileViewControllerDidSava];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


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

@end
