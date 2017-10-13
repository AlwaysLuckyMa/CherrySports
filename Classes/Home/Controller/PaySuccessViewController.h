//
//  PaySuccessViewController.h
//  CherrySports
//
//  Created by 吴庭宇 on 2016/12/22.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySuccessViewController : BaseViewController
/**对号图片**/
@property (nonatomic,strong)UIImageView *checkImage;
/**支付成功label**/
@property (nonatomic,strong)UILabel *payLabel;
/**樱桃体育提供label**/
@property (nonatomic,strong)UILabel *yintaoLabel;
/**金钱label**/
//@property (nonatomic,strong)UILabel *moneyLabel;
/**完成按钮**/
@property (nonatomic,strong)UIButton *completeButton;
@end
