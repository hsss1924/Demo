//
//  ScanViewController.m
//  aasiBusiness
//
//  Created by superMan on 16/7/21.
//  Copyright © 2016年 zxyuan. All rights reserved.
//

#import "PreView.h"
#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

// 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#define kScreenHigh  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

//1.输入设备(从外界采集信息)  输入设备很多种  摄像头  麦克风  键盘
@property (nonatomic, strong) AVCaptureDeviceInput* input;
//2.输出设备 (解析采集来得内容 然后获取到数据) Metadata 元数据
@property (nonatomic, strong) AVCaptureMetadataOutput* output;
//3.会话 session (连接输入和输出进行工作)
@property (nonatomic, strong) AVCaptureSession* session;
//4.展示layer
@property (nonatomic, strong) PreView* preView;
@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
//    //导航栏上标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//    //导航栏背景颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    //导航栏item颜色
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    //设置状态栏颜色(黑)
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startScan];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.session stopRunning];
}
-(void)viewDidDisappear:(BOOL)animated{
    //移除特殊的图层
    [self.preView removeFromSuperview];
    
}
#pragma mark--开始扫描
- (void)startScan
{
    
    //1.输入设备(从外界采集信息)
    //创建具体的设备  摄像头
    //AVMediaTypeVideo  摄像头       AVMediaTypeAudio 麦克风
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    //2.输出设备 (解析采集来得内容 然后获取到数据) Metadata 元数据
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    //3.会话 session (连接输入和输出进行工作)
    
    self.session = [[AVCaptureSession alloc] init];
    
    //会话扫描展示的大小
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    //添加输入设备和输出设备
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //指定输出设备的 代理   来返回 解析到得数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置元数据类型 QRCode 二维码+条形码
    [self.output setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code ]];
    
    //.创建特殊视图展示二维码界面
    self.preView = [[PreView alloc] initWithFrame:self.view.bounds];
    self.preView.session = self.session;
    [self.view addSubview:self.preView];

    
    //设置扫描区域-需要先设置frame 然后转化添加到上去
    CGRect rect = CGRectMake(30, 100, 300, 300);
    CGRect interRect = [self.preView.previewLayer metadataOutputRectOfInterestForRect:rect];
    self.output.rectOfInterest = interRect;
    
    //5.开启 会话
    [self.session startRunning];
}
#pragma mark--扫描成功 二维码代理--
/**
 *  解析出元数据就会调用
 *
 *  @param captureOutput   输出
 *  @param metadataObjects 元数据数组
 *  @param connection      连接
 */
- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputMetadataObjects:(NSArray*)metadataObjects fromConnection:(AVCaptureConnection*)connection
{
    //结束扫描
    [self stopScan];
    NSMutableString* str = [NSMutableString string];
    for (AVMetadataMachineReadableCodeObject* objc in metadataObjects) {
        //        NSLog(@"%@",objc.stringValue);
        [str appendString:objc.stringValue];
    }
    //打印
    NSLog(@"%@",(NSString *)str);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--设置UI--
- (void)setUI
{
    self.view.backgroundColor = [UIColor blackColor];
    [[UINavigationBar appearance]setBarTintColor:[UIColor blackColor]];
    self.title = @"二维码扫描";
    //在导航栏添加一个返回按钮
    UIBarButtonItem* backBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backHome)];
    self.navigationItem.backBarButtonItem = backBtn;
}
#pragma mark--结束扫描
- (void)stopScan
{
    
    //停止会话
    [self.session stopRunning];
    
    //移除特殊的图层
    [self.preView removeFromSuperview];

}

#pragma mark--返回首页--
- (void)backHome
{
    [self stopScan];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--手动填写编号--
- (void)manualFill
{
    NSLog(@"text");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
