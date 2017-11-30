//
//  THShareView.m
//  TingApp
//
//  Created by hublot on 16/9/4.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THShareView.h"
#import <UIButton+HTButtonCategory.h>
#import "HTManagerController.h"

@interface THShareView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *shareButtonPanel;

@property (nonatomic, strong) UILabel *shareToLabel;

@property (nonatomic, strong) NSMutableArray *shareButtonArray;


@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *detail;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, assign) SSDKContentType type;

@end

@implementation THShareView

static THShareView *shareView;

+ (instancetype)defaultShareView {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shareView = [[THShareView alloc] init];
	});
	return shareView;
}

+ (void)showTitle:(NSString *)title detail:(NSString *)detail image:(id)image url:(NSString *)url type:(SSDKContentType)type {
    THShareView *shareView = [THShareView defaultShareView];
    shareView.title = title;
    shareView.detail = detail;
    shareView.image = image;
    shareView.url = url;
	shareView.type = type;
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    [shareView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [shareView.shareButtonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj sizeToFit];
        obj.imageView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:1 delay:idx * 0.2 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            obj.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)didMoveToSuperview {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
    [self addSubview:self.contentView];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(210);
    }];
    [self.contentView addSubview:self.shareToLabel];
    [self.contentView addSubview:self.shareButtonPanel];
    [self.contentView addSubview:self.cancelButton];
    [self.shareToLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.shareButtonPanel.mas_top);
    }];
    [self.shareButtonPanel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.cancelButton.mas_top);
        make.height.mas_equalTo(120);
    }];
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(49);
    }];
    [self ht_whenTap:^(UIView *view) {
        [self.cancelButton ht_responderTap];
    }];
    [self.contentView ht_whenTap:^(UIView *view) {
        
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
    }
    return _contentView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton ht_whenTap:^(UIView *view) {
            [shareView removeFromSuperview];
        }];
    }
    return _cancelButton;
}

- (UIView *)shareButtonPanel {
    if (!_shareButtonPanel) {
        _shareButtonPanel = [[UIView alloc] init];
        NSArray *titleButtonArray = @[@"QQ", @"空间", @"微信", @"朋友圈", @"微博"];
        NSArray *imageButtonArray = @[@"ToeflQQ", @"Toeflkongjian", @"Toeflweixin", @"Toeflpengyouquan", @"Toeflweibo"];
        NSArray <NSNumber *> *shareTypeNumber = @[@(SSDKPlatformTypeQQ), @(SSDKPlatformSubTypeQZone), @(SSDKPlatformTypeWechat), @(SSDKPlatformSubTypeWechatTimeline), @(SSDKPlatformTypeSinaWeibo)];
        [titleButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitleColor:[UIColor ht_colorStyle:HTColorStylePrimaryTitle] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont ht_fontStyle:HTFontStyleHeadSmall];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:imageButtonArray[idx]] forState:UIControlStateNormal];
            [button ht_makeEdgeWithDirection:HTButtonEdgeDirectionVertical imageViewToTitleLabelSpeceOffset:10];
            [button ht_whenTap:^(UIView *view) {
                NSMutableDictionary *shareParams = [@{} mutableCopy];
                [shareParams SSDKSetupShareParamsByText:self.detail
                                                 images:self.image
                                                    url:[NSURL URLWithString:self.url]
                                                  title:self.title
                                                   type:self.type];
                [ShareSDK share:[shareTypeNumber[idx] integerValue] parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
					NSLog(@"分享失败%@",error);
                }];
                [self removeFromSuperview];
            }];
            [self.shareButtonArray addObject:button];
        }];
        [_shareButtonPanel ht_addStackDistanceWithSubViews:self.shareButtonArray foreSpaceDistance:10 backSpaceDistance:10 stackDistanceDirection:HTStackDistanceDirectionHorizontal];
    }
    return _shareButtonPanel;
}

- (UILabel *)shareToLabel {
	if (!_shareToLabel) {
		_shareToLabel = [[UILabel alloc] init];
		_shareToLabel.text = @"分享到";
		_shareToLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_shareToLabel.font = [UIFont systemFontOfSize:14];
	}
	return _shareToLabel;
}

- (NSMutableArray *)shareButtonArray {
	if (!_shareButtonArray) {
		_shareButtonArray = [NSMutableArray new];
	}
	return _shareButtonArray;
}


@end
