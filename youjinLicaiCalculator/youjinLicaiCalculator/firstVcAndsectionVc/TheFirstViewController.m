//
//  TheFirstViewController.m
//  youjinLicaiCalculator
//
//  Created by 柚今科技01 on 2017/6/21.
//  Copyright © 2017年 柚今科技01. All rights reserved.
//

#import "TheFirstViewController.h"
#import "InstallmentModel.h"

@interface TheFirstViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *inputTextF;//请输入金额
@property (nonatomic ,strong)UITextField *nperTextField;//请输入期数
@property (nonatomic ,strong)UITextField *AnInterestTextField;//请输入月利率
@property (nonatomic ,strong)UILabel *moneyLabel;//月供金
@end

@implementation TheFirstViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStairViewDidLoadUINavigationBarTintColor];
    self.navigationItem.title = @"分期计算器";
//    self.tabBarItem.title = @"分期计算";

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用
    manager.shouldResignOnTouchOutside = YES;//点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//工具条颜色是否自定义
    manager.shouldShowTextFieldPlaceholder = NO;//中间位置显示占位符
    manager.enableAutoToolbar = YES;//是否显示键盘上的工具条
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //每月月供背景view
    [self monthlyPaymentsView];
    //分期金额  分期期数  月利率(%)的view
    [self underView];
    
    //买车后手头紧？点我看看
    UIButton *pointButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pointButton.frame = CGRectMake(135*BOScreenW/750, 728*BOScreenH/1334, 480*BOScreenW/750, 80*BOScreenH/1334);
    [pointButton setTitle:@"我要分期" forState:UIControlStateNormal];
    [pointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pointButton.titleLabel.font  = [UIFont systemFontOfSize:15];
    pointButton.backgroundColor = [UIColor colorWithHexString:@"#ffa238" alpha:1];
    pointButton.layer.cornerRadius = 20;
    if (iPhone6P)
    {
        pointButton.layer.cornerRadius = 23;
    }
    if (iPhone5)
    {
        pointButton.layer.cornerRadius = 17;
    }
    pointButton.layer.masksToBounds = YES;
    [pointButton addTarget:self action:@selector(pointButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pointButton];
}
#pragma mark--我要分期的点击事件---
- (void)pointButtonClick
{
    NSString  *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d",1232500861];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark---每月月供背景view---
- (void)monthlyPaymentsView
{
    //月供的背景view
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BOScreenW, 320*BOScreenH/1334)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    //每月月供
    UILabel *paymentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(225*BOScreenW/750, 50*BOScreenH/1334, 300*BOScreenW/750, 30*BOScreenH/1334)];
    paymentsLabel.text = @"每月月供(元)";
    paymentsLabel.font = [UIFont systemFontOfSize:14];
    paymentsLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    paymentsLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:paymentsLabel];
    //月供金额
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(225*BOScreenW/750, 106*BOScreenH/1334, 300*BOScreenW/750, 55*BOScreenH/1334)];
    _moneyLabel.text = @"0";
    [_moneyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:26]];
    _moneyLabel.textColor = [UIColor colorWithHexString:@"#ff5a00" alpha:1];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_moneyLabel];
    
    //首付总车款(元)  支付利息(元)  还款总额(元)
    NSArray *interestArr = @[@"支付利息(元)",@"还款总额(元)",@"0",@"0"];
    for (int i = 0; i < 4; i ++)
    {
        int k = i%2;
        int j = i/2;
        UILabel *interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(37*BOScreenW/750 + k*(300*BOScreenW/750+76*BOScreenW/750), 190*BOScreenH/1334 + j*(30*BOScreenH/1334+23*BOScreenH/1334), 300*BOScreenW/750, 40*BOScreenH/1334)];
        interestLabel.tag = 100 + i;
        interestLabel.text = interestArr[i];
        interestLabel.font = [UIFont systemFontOfSize:12];
        interestLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
        interestLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:interestLabel];
        if (i==2 || i==3)
        {
            [interestLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        }
    }
    //请输入分期信息
    UILabel *resultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*BOScreenW/750, 339*BOScreenH/1334, 720*BOScreenW/750, 30*BOScreenH/1334)];
    resultsLabel.text = @"请输入分期信息";
    [resultsLabel setFont:[UIFont systemFontOfSize:13]];
    resultsLabel.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
    [self.view addSubview:resultsLabel];
}
#pragma mark---分期金额  分期期数  月利率(%)的view---
- (void)underView
{
    //底部的白色view
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 388*BOScreenH/1334, BOScreenW, 300*BOScreenH/1334)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    NSArray *carArr = @[@"分期金额",@"分期期数",@"月利率(%)"];
    for (int i = 0 ; i < 3; i ++)
    {
        UILabel *carLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*BOScreenW/750, 35*BOScreenH/1334 + i*(30*BOScreenH/1334+70*BOScreenH/1334), 230*BOScreenW/750, 30*BOScreenH/1334)];
        carLabel.text = carArr[i];
        [carLabel setFont:[UIFont systemFontOfSize:14]];
        carLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
        [bgView addSubview:carLabel];
    }
    //细线
    for (int i = 0; i < 2; i ++)
    {
        UIView *lineView= [[UIView alloc]initWithFrame:CGRectMake(30*BOScreenW/750, 99*BOScreenH/1334 + i*100*BOScreenH/1334, 720*BOScreenW/750, 1*BOScreenH/1334)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#dfe3e6" alpha:1];
        [bgView addSubview:lineView];
    }
    //请输入金额
    _inputTextF = [[UITextField alloc]initWithFrame:CGRectMake(400*BOScreenW/750, 35*BOScreenH/1334, 320*BOScreenW/750, 30*BOScreenH/1334)];
    _inputTextF.delegate = self;
    _inputTextF.placeholder = @"请输入金额";
    _inputTextF.textAlignment = NSTextAlignmentRight;
    _inputTextF.keyboardType = UIKeyboardTypeNumberPad;
    _inputTextF.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    _inputTextF.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_inputTextF];
    
    //请输入期数
    _nperTextField = [[UITextField alloc]initWithFrame:CGRectMake(400*BOScreenW/750, 135*BOScreenH/1334 + 0*100*BOScreenH/1334, 320*BOScreenW/750, 30*BOScreenH/1334)];
    _nperTextField.delegate = self;
    _nperTextField.placeholder = @"请输入期数";
    _nperTextField.textAlignment = NSTextAlignmentRight;
    _nperTextField.keyboardType = UIKeyboardTypeNumberPad;
    _nperTextField.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    _nperTextField.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_nperTextField];
    
    //请输入月利率
    _AnInterestTextField = [[UITextField alloc]initWithFrame:CGRectMake(400*BOScreenW/750, 135*BOScreenH/1334 + 1*100*BOScreenH/1334, 320*BOScreenW/750, 30*BOScreenH/1334)];
    _AnInterestTextField.delegate = self;
    _AnInterestTextField.text = @"0.48";
    _AnInterestTextField.placeholder = @"请输入月利率";
    _AnInterestTextField.textAlignment = NSTextAlignmentRight;
    _AnInterestTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _AnInterestTextField.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    _AnInterestTextField.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_AnInterestTextField];
}
#pragma mark---数据接口----
- (void)installmentData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"at"] = tokenString;
    parameters[@"money"] = _inputTextF.text;
    parameters[@"qishu"] = _nperTextField.text;
    parameters[@"apr"] = _AnInterestTextField.text;
    [manager POST:[NSString stringWithFormat:@"%@Common/jisuanqiFenqi",BASEURL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"r"] integerValue] == 1)
        {
            InstallmentModel *model = [InstallmentModel mj_objectWithKeyValues:responseObject[@"data"]];
            _moneyLabel.text = model.meiyue;
            UILabel *lixiLabel = (UILabel *)[self.view viewWithTag:102];
            lixiLabel.text = model.lixi;
            UILabel *sumLabel = (UILabel *)[self.view viewWithTag:103];
            sumLabel.text = model.sum;
        }
        else
        {
            NSLog(@"返回信息描述%@",responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
    }];
}
#pragma mark ---pop返回前一页---
- (void)leftBarButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textfieldiskong];
}
#pragma mark---判断输入框是否为空---------
- (void)textfieldiskong
{
    if (_inputTextF.text.length>0&&_nperTextField.text.length>0&&_AnInterestTextField.text.length>0)
    {
        unichar single = [_inputTextF.text characterAtIndex:0];//当前输入的字符
        unichar singles = [_AnInterestTextField.text characterAtIndex:0];//当前输入的字符
        if (single == '.' || singles == '.')
        {
            NSLog(@"第一个字符不能为点");
        }else
        {
            if (tokenString)
            {
                [self installmentData];
            }else
            {
                //得到token
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                parameters[@"app_id"] = @"2";
                parameters[@"secret"] = @"2e1eec48cae70a2c3bd8b1f2f2e177ea";
                [manager POST:[NSString stringWithFormat:@"%@Auth/accessToken",BASEURL] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"at"] forKey:@"access_token"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     [self installmentData];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"token请求失败没有网络%@",error);
                 }];
            }
        }
    }else
    {
        _moneyLabel.text = @"0";
        UILabel *label = (UILabel *)[self.view viewWithTag:102];
        label.text = @"0";
        UILabel *labels = (UILabel *)[self.view viewWithTag:103];
        labels.text = @"0";
    }
}
@end
