//
//  HTCommunityDetailHeaderView.m
//  GMat
//
//  Created by hublot on 2016/11/22.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCommunityDetailHeaderView.h"
#import <UIButton+HTButtonCategory.h>
#import "HTLoginManager.h"
#import "HTCommunityReplyKeyBoardView.h"
#import "HTCommunityController.h"
#import "UIScrollView+HTRefresh.h"
#import "UIImageView+YYWebImage.h"
#import "UIImage+YYAdd.h"
#import "YYLabel.h"
#import "HTImageBrowserView.h"
#import "CALayer+YYWebImage.h"
#import "YYImageCoder.h"
#import "LPActionSheet.h"
#import <NSObject+HTTableRowHeight.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface HTCommunityDetailHeaderView ()

@property (nonatomic, strong) HTCommunityUserView *userView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) YYLabel *titleNameLabel;

@property (nonatomic, strong) YYLabel *detailNameLabel;

@property (nonatomic, strong) UIView *imageArrayContentView;

@property (nonatomic, strong) NSArray <HTCommunityImageView *> *imageViewArray;

@property (nonatomic, strong) HTCommunityLikeReplyView *likeReplyView;

@property (nonatomic, strong) HTCommunityLayoutModel *model;

@end

@implementation HTCommunityDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.whiteContentView];
        
        [self.whiteContentView addSubview:self.userView];
        [self.whiteContentView addSubview:self.lineView];
        [self.whiteContentView addSubview:self.titleNameLabel];
        [self.whiteContentView addSubview:self.detailNameLabel];
        [self.whiteContentView addSubview:self.imageArrayContentView];
        __weak HTCommunityDetailHeaderView *weakSelf = self;
        [self.imageViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.imageArrayContentView addSubview:obj];
        }];
        [self.whiteContentView addSubview:self.likeReplyView];
    }
    return self;
}

- (void)setModel:(HTCommunityLayoutModel *)model row:(NSInteger)row type:(HTCommunityDetailType)type isShowDelete:(BOOL)isShowDelete{
    _model = model;
    UIImage *placeImage = [HTPLACEHOLDERIMAGE ht_resetSize:CGSizeMake(CommunityUserHeadImageHeight, CommunityUserHeadImageHeight)];
    placeImage = [placeImage imageByRoundCornerRadius:CommunityUserHeadImageHeight / 2 borderWidth:0 borderColor:nil];
    [self.userView.headImageView.layer setImageWithURL:[NSURL URLWithString:GmatResourse(model.originModel.icon)] placeholder:placeImage options:kNilOptions manager:model.userViewLayoutModel.headImageManager progress:nil transform:nil completion:nil];
    self.userView.userNameLabel.textLayout = model.userViewLayoutModel.userViewTitleNameLayout;
    self.userView.creatTimeLabel.textLayout = model.userViewLayoutModel.userViewDetailNameLayout;
    self.titleNameLabel.textLayout = model.titleNameLayout;
    self.detailNameLabel.textLayout = model.detailNameLayout;
    self.likeReplyView.communityLikeCount = model.originModel.likeNum.integerValue;
    self.likeReplyView.communityReplyCount = model.originModel.reply.count;
    self.likeReplyView.communityLikeButton.selected = model.originModel.likeId;
    
    __weak HTCommunityDetailHeaderView *weakSelf = self;
    
	
	self.likeReplyView.deleteButton.hidden = !isShowDelete;
		
    [self.likeReplyView.deleteButton ht_whenTap:^(UIView *view) {
		[[NSNotificationCenter defaultCenter]postNotificationName:DELETE object:nil userInfo:@{@"model":model.originModel}];
    }];
    
    
    [self.likeReplyView.communityLikeButton ht_whenTap:^(UIView *view) {
        [HTUserManager surePermissionHighOrEqual:HTUserPermissionExerciseAbleUser passCompareBlock:^(HTUser *user) {
            HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
            networkModel.autoAlertString = @"点赞中";
            networkModel.offlineCacheStyle = HTCacheStyleNone;
            networkModel.autoShowError = true;
            
            if (type == HTCommunityTypeGossip) {
                [HTRequestManager requestGossipGoodGossipWithNetworkModel:networkModel gossipIdString:model.originModel.Id complete:^(id response, HTError *errorModel) {
                    if (errorModel.existError) {
                        return;
                    }
                    model.originModel.likeNum = response[@"likeNum"];
                    model.originModel.likeId = !model.originModel.likeId;
                    weakSelf.likeReplyView.communityLikeCount = [response[@"likeNum"] integerValue];
                    weakSelf.likeReplyView.communityLikeButton.selected = !weakSelf.likeReplyView.communityLikeButton.selected;
                }];
            }else {
                [HTRequestManager requestLiveAddLikeWithNetworkModel:networkModel liveIdString:model.originModel.Id complete:^(id response, HTError *errorModel) {
                    if (errorModel.existError) {
                        return;
                    }
                    model.originModel.likeNum = response[@"likeNum"];
                    model.originModel.likeId = !model.originModel.likeId;
                    weakSelf.likeReplyView.communityLikeCount = [response[@"likeNum"] integerValue];
                    weakSelf.likeReplyView.communityLikeButton.selected = !weakSelf.likeReplyView.communityLikeButton.selected;
                }];
            }
        }];
    }];
    
    [self.likeReplyView.communityReplyButton ht_whenTap:^(UIView *view) {
        [HTCommunityReplyKeyBoardView showReplyKeyBoardViewPlaceHodler:@" 评论" keyBoardAppearance:UIKeyboardAppearanceDark completeBlock:^(NSString *replyText) {
            HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
            networkModel.autoAlertString = @"评论中";
            networkModel.offlineCacheStyle = HTCacheStyleNone;
            networkModel.autoShowError = true;
			
			
		if (type == HTCommunityTypeGossip) {
            [HTRequestManager requestGossipReplyGossipOwnerWithNetworkModel:networkModel replyContent:replyText communityLayoutModel:model complete:^(id response, HTError *errorModel) {
                if (errorModel.existError) {
                    return;
                }
                [HTAlert title:@"回复成功"];
				[((HTCommunityController *)weakSelf.ht_controller).tableView ht_startRefreshHeader];
                
            }];
		}else if (type == HTCommunityTypelLive){
			[HTRequestManager requestReplyLiveReplyWithNetworkModel:networkModel replyContent:replyText communityModel:model.originModel beingReplyModel:nil complete:^(id response, HTError *errorModel) {
				if (errorModel.existError) {
					return;
				}
				weakSelf.likeReplyView.communityReplyCount += 1;
				if (weakSelf.delegate)
				{
				 	 CommunityReply *newReply = [CommunityReply mj_objectWithKeyValues:response[@"data"]];
					  [weakSelf.delegate replyPostSuccessWithModel:weakSelf.model reply:newReply];
				}
				[HTAlert title:@"回复成功"];
			}];
			}
        }];
    }];
    
    [self.imageViewArray enumerateObjectsUsingBlock:^(HTCommunityImageView * _Nonnull thubnailImageView, NSUInteger imageIndex, BOOL * _Nonnull stop) {
        if (imageIndex >= model.originModel.image.count) {
            thubnailImageView.hidden = true;
            [thubnailImageView cancelCurrentImageRequest];
        } else {
            thubnailImageView.hidden = false;
            thubnailImageView.model = [NSString stringWithFormat:@"http://bbs.viplgw.cn/%@", model.originModel.image[imageIndex]];
            [thubnailImageView ht_whenTap:^(UIView *view) {
                NSMutableArray <HTImageBrowserModel *> *browserModelArray = [@[] mutableCopy];
                [model.originModel.image enumerateObjectsUsingBlock:^(NSString * _Nonnull model, NSUInteger modelIndex, BOOL * _Nonnull stop) {
                    HTImageBrowserModel *browserModel = [[HTImageBrowserModel alloc] init];
                    browserModel.thubnailImageView = weakSelf.imageViewArray[modelIndex];
                    browserModel.browserModelImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://bbs.viplgw.cn/%@", model]];
                    [browserModelArray addObject:browserModel];
                }];
                [HTImageBrowserView presentModelArray:browserModelArray fromIndex:imageIndex setImageAndProgressBlock:^(HTImageBrowserModel *model, NSInteger index, UIImageView *imageView, NSURL *browserModelImageURL, void (^progressBlock)(HTImageBrowserModel *model, CGFloat progress), void (^setImageBlock)(HTImageBrowserModel *model, NSData *imageData, UIImage *image)) {
                    setImageBlock(model, nil, model.thubnailImageView.image);
                    [imageView setImageWithURL:model.browserModelImageURL placeholder:model.thubnailImageView.image options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        progressBlock(model, receivedSize / (CGFloat)expectedSize);
                    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        setImageBlock(model, [image imageDataRepresentation], image);
                    }];
                } longPressBlock:^(NSData *imageData, HTImageBrowserModel *model, NSInteger pressIndex) {
                    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
                        if (index == 1) {
                            if (!imageData) {
                                [HTAlert title:@"获取图片数据源失败"];
                                return;
                            }
                            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
                            switch (status) {
                                case AVAuthorizationStatusRestricted:
                                case AVAuthorizationStatusDenied: {
                                    NSURL *url;
                                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                                        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]]) {
                                        url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                                    }
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"访问相册失败" message:url ? @"访问系统相册失败" : @"请手动修改设置/相册/权限设置" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        [[UIApplication sharedApplication] openURL:url];
                                    }];
                                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                        
                                    }];
                                    if (url) {
                                        [alertController addAction:sureAction];
                                    }
                                    [alertController addAction:cancelAction];
                                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:true completion:nil];
                                }
                                    break;
                                case AVAuthorizationStatusNotDetermined:
                                case AVAuthorizationStatusAuthorized: {
                                    NSString *customAlbumName = @"雷哥GMAT";
                                    NSDictionary *metadata = @{};
                                    void(^completionBlock)() = ^(){
                                        [HTAlert title:@"保存成功"];
                                    };
                                    void(^failureBlock)(NSError *error) = ^(NSError *error){
                                        [HTAlert title:@"保存失败"];
                                    };
                                    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                                    __weak ALAssetsLibrary *weakLibrary = assetsLibrary;
                                    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
                                        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                                                    [group addAsset:asset];
                                                    if (completionBlock) {
                                                        completionBlock();
                                                    }
                                                }
                                            } failureBlock:^(NSError *error) {
                                                if (failureBlock) {
                                                    failureBlock(error);
                                                }
                                            }];
                                        } failureBlock:^(NSError *error) {
                                            if (failureBlock) {
                                                failureBlock(error);
                                            }
                                        }];
                                    };
                                    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
                                        if (customAlbumName.length) {
                                            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                                                if (group) {
                                                    [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                                        [group addAsset:asset];
                                                        if (completionBlock) {
                                                            completionBlock();
                                                        }
                                                    } failureBlock:^(NSError *error) {
                                                        if (failureBlock) {
                                                            failureBlock(error);
                                                        }
                                                    }];
                                                } else {
                                                    AddAsset(weakLibrary, assetURL);
                                                }
                                            } failureBlock:^(NSError *error) {
                                                AddAsset(weakLibrary, assetURL);
                                            }];
                                        } else {
                                            if (completionBlock) {
                                                completionBlock();
                                            }
                                        }
                                    }];
                                }
                                    break;
                            }
                        }
                    }];
                }];
            }];
        }
    }];
    
    self.titleNameLabel.ht_h = model.titleNameLabelHeight;
    
    self.detailNameLabel.ht_y = self.titleNameLabel.ht_y + self.titleNameLabel.ht_h;
    self.detailNameLabel.ht_h = model.detailNameLabelHeight;
    
    self.imageArrayContentView.ht_y = self.detailNameLabel.ht_y + self.detailNameLabel.ht_h;
    self.imageArrayContentView.ht_h = model.imageCollectionViewHeight;
    
    self.likeReplyView.ht_y = self.imageArrayContentView.ht_y + self.imageArrayContentView.ht_h;
    
    self.whiteContentView.ht_h = self.likeReplyView.ht_y + self.likeReplyView.ht_h;
    
    CGFloat modelHeight = self.whiteContentView.ht_h + CommunityCellMargin;
    self.heightForLive = self.whiteContentView.ht_h;
    self.ht_h = modelHeight;
    
}

- (UIView *)whiteContentView {
    if (!_whiteContentView) {
        _whiteContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 0)];
        _whiteContentView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteContentView;
}

- (HTCommunityUserView *)userView {
    if (!_userView) {
        _userView = [[HTCommunityUserView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, CommunityUserViewHeight)];
    }
    return _userView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userView.ht_h, HTSCREENWIDTH, 1 / [UIScreen mainScreen].scale)];
        _lineView.backgroundColor = [UIColor ht_colorStyle:HTColorStylePrimarySeparate];
    }
    return _lineView;
}

- (YYLabel *)titleNameLabel {
    if (!_titleNameLabel) {
        _titleNameLabel = [[YYLabel alloc] initWithFrame:CGRectMake((HTSCREENWIDTH - CommunityCellContentWidth) / 2, CommunityUserViewHeight + self.lineView.ht_h, CommunityCellContentWidth, 0)];
        _titleNameLabel.displaysAsynchronously = YES;
        _titleNameLabel.ignoreCommonProperties = YES;
        _titleNameLabel.fadeOnHighlight = NO;
		_titleNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleNameLabel.fadeOnAsynchronouslyDisplay = NO;
    }
    return _titleNameLabel;
}

- (YYLabel *)detailNameLabel {
    if (!_detailNameLabel) {
        _detailNameLabel = [[YYLabel alloc] initWithFrame:CGRectMake((HTSCREENWIDTH - CommunityCellContentWidth) / 2, 0, CommunityCellContentWidth, 0)];
        _detailNameLabel.displaysAsynchronously = YES;
        _detailNameLabel.ignoreCommonProperties = YES;
        _detailNameLabel.fadeOnHighlight = NO;
		_detailNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailNameLabel.fadeOnAsynchronouslyDisplay = NO;
    }
    return _detailNameLabel;
}

- (UIView *)imageArrayContentView {
    if (!_imageArrayContentView) {
        _imageArrayContentView = [[UIView alloc] initWithFrame:CGRectMake((HTSCREENWIDTH - CommunityCellContentWidth) / 2, 0, CommunityCellContentWidth, 0)];
    }
    return _imageArrayContentView;
}

- (NSArray<HTCommunityImageView *> *)imageViewArray {
    if (!_imageViewArray) {
        NSMutableArray *imageViewArray = [@[] mutableCopy];
        for (NSInteger index = 0; index < 9; index ++) {
            HTCommunityImageView *imageView = [[HTCommunityImageView alloc] initWithFrame:CGRectMake((index % 3) * (((CommunityCellContentWidth - CommunityImagePadding * 2) / 3.0) + CommunityImagePadding), (index / 3) * (((CommunityCellContentWidth - CommunityImagePadding * 2) / 3.0) + CommunityImagePadding), ((CommunityCellContentWidth - CommunityImagePadding * 2) / 3.0), ((CommunityCellContentWidth - CommunityImagePadding * 2) / 3.0))];
            [imageViewArray addObject:imageView];
        }
        _imageViewArray = imageViewArray;
    }
    return _imageViewArray;
}

- (HTCommunityLikeReplyView *)likeReplyView {
    if (!_likeReplyView) {
        _likeReplyView = [[HTCommunityLikeReplyView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, CommunityLikeReplyViewHeight)];
    }
    return _likeReplyView;
}



@end
