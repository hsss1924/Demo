//
//  PreView.m
//  aasiBusiness
//
//  Created by superMan on 16/7/22.
//  Copyright © 2016年 zxyuan. All rights reserved.
//

#import "PreView.h"
#import "Masonry.h"

// 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#define kScreenHigh  [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface PreView ()
@property(nonatomic,strong)UIImageView *bgImage;
//添加线
@property (nonatomic, strong) UIImageView* lineImageView;
//定时器
@property (nonatomic, strong) CADisplayLink* displayLink;
@end

@implementation PreView
/**
 *  layer
 *
 *  @return 返回AVCaptureVideoPreviewLayer 特殊的layer 可以展示输入设备采集到的信息
 */
+(Class)layerClass{
    return [AVCaptureVideoPreviewLayer class];
}

-(AVCaptureVideoPreviewLayer *)previewLayer{
    
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    return layer;
}

-(void)setSession:(AVCaptureSession *)session{
    
    _session = session;
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    layer.session = session;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setMask];
        
    }
    return self;
}
-(void)setMask{
    
    //添加扫描线
    self.lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    self.lineImageView.frame = CGRectMake((kScreenWidth - 280) / 2, 100, 280, 2);
    [self addSubview:self.lineImageView];
    //计时器
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scanAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    //创建一个maskView
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHigh-64)];
    //颜色设置透明
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:maskView];
    //创建一个中间有镂空区域的path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHigh-64)];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((kScreenWidth-280)/2, 100-64, 280, 280) cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    
    maskLayer.path = maskPath.CGPath;
    
    maskView.layer.mask = maskLayer;
    
    [self addSubview:self.bgImage];
    _bgImage.frame = CGRectMake((kScreenWidth-280)/2, 100, 280, 280);
}


#pragma mark--扫描动画--
- (void)scanAnimation
{
    CGRect frame = self.lineImageView.frame;
    if (self.lineImageView.frame.origin.y > 100 + 270) {
        frame.origin.y = 100;
        self.lineImageView.frame = frame;
    }
    else {
        frame.origin.y += 2;
        self.lineImageView.frame = frame;
    }
}

#pragma mark --懒加载
-(UIImageView *)bgImage{
    
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_scanbg"]];
        
    }
    return _bgImage;
}


@end
