//
//  HTCommunityLayoutModel.m
//  GMat
//
//  Created by hublot on 2017/1/12.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTCommunityLayoutModel.h"
#import "NSAttributedString+YYText.h"
#import <HTCacheManager.h>
#import "UIImage+YYAdd.h"
#import "HTMineFontSizeController.h"

@implementation HTCommunityLayoutModel

- (void)dealloc {
	
}

+ (instancetype)layoutModelWithOriginModel:(HTCommunityModel *)orginModel isDetail:(BOOL)isDetail {
	
	CGFloat userFontZoomNumber = [HTMineFontSizeController fontZoomNumber];
	
	// cell 的标题字体大小
	
	CGFloat CommunityTitleNameFontSize = 16 * userFontZoomNumber;
	
	// cell 的详情字体大小
	CGFloat CommunityDetailNameFontSize = 14 * userFontZoomNumber;
	
	
	
	HTCommunityLayoutModel *layoutModel = [[HTCommunityLayoutModel alloc] init];
	layoutModel.originModel = orginModel;
	
    // 发表人
    
    layoutModel.userViewLayoutModel = [HTCommunityUserViewLayoutModel userViewReplyModelWithCommunityModel:layoutModel.originModel];
	
	// 内容标题
	NSMutableAttributedString *titleNameAttributedString = [[NSMutableAttributedString alloc] initWithString:layoutModel.originModel.title];

	titleNameAttributedString.font = [UIFont systemFontOfSize:CommunityTitleNameFontSize];
	titleNameAttributedString.color = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
	
	WBTextLinePositionModifier *titleNameModifier = [WBTextLinePositionModifier new];
	titleNameModifier.font = [UIFont fontWithName:@"Heiti SC" size:CommunityTitleNameFontSize];
	titleNameModifier.paddingTop = CommunityTextPadding;
	titleNameModifier.paddingBottom = 0;
	
	YYTextContainer *titleNameContainer = [[YYTextContainer alloc] init];
	titleNameContainer.size = CGSizeMake(CommunityCellContentWidth, HUGE);
    if (!isDetail) {
        titleNameContainer.maximumNumberOfRows = 1;
    }
	titleNameContainer.linePositionModifier = titleNameModifier;
	layoutModel.titleNameLayout = [YYTextLayout layoutWithContainer:titleNameContainer text:titleNameAttributedString];
	layoutModel.titleNameLabelHeight = [titleNameModifier heightForLineCount:layoutModel.titleNameLayout.lines.count];
	
	
	// 内容详情
	NSMutableAttributedString *detailNameAttributedString = [[NSMutableAttributedString alloc] initWithString:layoutModel.originModel.content];
	detailNameAttributedString.font = [UIFont systemFontOfSize:CommunityDetailNameFontSize];
	detailNameAttributedString.color = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
	
	WBTextLinePositionModifier *detailNameModifier = [WBTextLinePositionModifier new];
	detailNameModifier.font = [UIFont fontWithName:@"Heiti SC" size:CommunityTitleNameFontSize];
	detailNameModifier.paddingTop = 0;
	detailNameModifier.paddingBottom = CommunityTextPadding * 2;
	
	YYTextContainer *detailTextContainer = [[YYTextContainer alloc] init];
	detailTextContainer.size = CGSizeMake(CommunityCellContentWidth, HUGE);
	detailTextContainer.linePositionModifier = detailNameModifier;
    if (!isDetail) {
        detailTextContainer.maximumNumberOfRows = CommunityDetailNameNumberOfLines;
    }
	layoutModel.detailNameLayout = [YYTextLayout layoutWithContainer:detailTextContainer text:detailNameAttributedString];
	layoutModel.detailNameLabelHeight = [detailNameModifier heightForLineCount:layoutModel.detailNameLayout.rowCount];
	
	
	// 图片总高度
	layoutModel.imageCollectionViewHeight = layoutModel.originModel.image.count ? ((ceil)(layoutModel.originModel.image.count / 3.0)) * ((CommunityCellContentWidth - CommunityImagePadding * 2) / 3.0) + ((ceilf(layoutModel.originModel.image.count / 3.0)) - 1) * CommunityImagePadding : 0;
	
	// 分享点赞总高度
	layoutModel.likeReplyViewHeight = CommunityLikeReplyViewHeight;
    
    
    // 回复总高度
    NSMutableArray *replyLayoutModelArray = [@[] mutableCopy];
    [layoutModel.originModel.reply enumerateObjectsUsingBlock:^(CommunityReply * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isDetail || idx < CommunityReplyTableMaxCount) {
            HTCommunityReplyLayoutModel *replyLayoutModel = [HTCommunityReplyLayoutModel replyLayoutModelWithOriginReplyModel:obj];
            [replyLayoutModelArray addObject:replyLayoutModel];
        } else {
            *stop = true;
        }
    }];
    layoutModel.replyLayoutModelArray = replyLayoutModelArray;
    
    if (isDetail) {
        [layoutModel.replyLayoutModelArray enumerateObjectsUsingBlock:^(HTCommunityReplyLayoutModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userViewLayoutModel = [HTCommunityUserViewLayoutModel userViewReplyModelWithReplyModel:obj.originReplyModel];
        }];
        return layoutModel;
    } else {
        // 回复表格
        [layoutModel.replyLayoutModelArray enumerateObjectsUsingBlock:^(HTCommunityReplyLayoutModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableAttributedString *replyAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", obj.originReplyModel.uName, obj.originReplyModel.content]];
            [replyAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(obj.originReplyModel.uName.length, obj.originReplyModel.content.length + 2)];
            [replyAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, obj.originReplyModel.uName.length)];
            if (obj.originReplyModel.type.integerValue == 2) {
                NSMutableAttributedString *insertAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 回复 %@", obj.originReplyModel.replyUserName]];
                [insertAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(1, 2)];
                [insertAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(4, obj.originReplyModel.replyUserName.length)];
                [replyAttributedString insertAttributedString:insertAttributedString atIndex:obj.originReplyModel.uName.length];
            }
			replyAttributedString.font = [UIFont systemFontOfSize:CommunityReplyTableViewCellFontSize];
            WBTextLinePositionModifier *titleNameModifier = [WBTextLinePositionModifier new];
            titleNameModifier.font = [UIFont fontWithName:@"Heiti SC" size:CommunityReplyTableViewCellFontSize];
            titleNameModifier.paddingTop = 0;
            titleNameModifier.paddingBottom = 0;
            
            YYTextContainer *titleNameContainer = [[YYTextContainer alloc] init];
            titleNameContainer.size = CGSizeMake(HTSCREENWIDTH, HUGE);
            titleNameContainer.insets = UIEdgeInsetsMake(0, (HTSCREENWIDTH - CommunityReplyTableContentWidth) / 2, 0, (HTSCREENWIDTH - CommunityReplyTableContentWidth) / 2);
            titleNameContainer.maximumNumberOfRows = CommunityReplyCellNumberOfLines;
            titleNameContainer.linePositionModifier = titleNameModifier;
            
            obj.titleNameLayout = [YYTextLayout layoutWithContainer:titleNameContainer text:replyAttributedString];
            obj.titleNameHeight = [titleNameModifier heightForLineCount:obj.titleNameLayout.lines.count] + CommunityReplyCellTextPading * 2;
            layoutModel.replyContentHeight += obj.titleNameHeight;
        }];
        
        if (layoutModel.originModel.reply.count > CommunityReplyTableMaxCount) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"查看全部 %ld 条评论", layoutModel.originModel.reply.count]];
            attributedString.font = [UIFont systemFontOfSize:15];
            attributedString.color = [UIColor ht_colorStyle:HTColorStylePrimaryTheme];
            YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:[YYTextContainer containerWithSize:CGSizeMake(CommunityCellContentWidth, CommunityReplyTableFootHeight)] text:attributedString];
            layoutModel.lookMoreReplyLayout = textLayout;
            layoutModel.replyContentHeight += CommunityReplyTableFootHeight;
        }
        return layoutModel;
    }
}

@end


@implementation HTCommunityUserViewLayoutModel

- (instancetype)init {
    if (self = [super init]) {
        static YYWebImageManager *manager;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *path = [[HTCacheManager rootCacheFloderPath] stringByAppendingPathComponent:@"weibo.avatar"];
            YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
            manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
            manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
                if (!image) return image;
                image = [image ht_resetSize:CGSizeMake(CommunityUserHeadImageHeight, CommunityUserHeadImageHeight)];
                return [image imageByRoundCornerRadius:CommunityUserHeadImageHeight / 2.0];
            };
        });
        self.headImageManager = manager;
    }
    return self;
}

+ (instancetype)userViewReplyModelWithReplyModel:(CommunityReply *)replyModel {
    HTCommunityUserViewLayoutModel *userViewLayoutModel = [[HTCommunityUserViewLayoutModel alloc] init];
    
    // 回复内容
    NSMutableAttributedString *replyAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", replyModel.uName, replyModel.content]];
    [replyAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(replyModel.uName.length, replyModel.content.length + 2)];
    [replyAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, replyModel.uName.length)];
    if (replyModel.type.integerValue == 2) {
        NSMutableAttributedString *insertAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 回复 %@", replyModel.replyUserName]];
        [insertAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStyleSecondaryTitle]} range:NSMakeRange(1, 2)];
        [insertAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(4, replyModel.replyUserName.length)];
        [replyAttributedString insertAttributedString:insertAttributedString atIndex:replyModel.uName.length];
    }
	replyAttributedString.font = [UIFont systemFontOfSize:CommunityUserViewTitleFontSize];
	
    WBTextLinePositionModifier *titleNameModifier = [WBTextLinePositionModifier new];
    titleNameModifier.font = [UIFont fontWithName:@"Heiti SC" size:CommunityUserViewTitleFontSize];
    titleNameModifier.paddingBottom = CommunityImagePadding;
    
    YYTextContainer *titleNameContainer = [[YYTextContainer alloc] init];
    titleNameContainer.size = CGSizeMake(CommunityUserViewTextWidth, 9999);
    titleNameContainer.linePositionModifier = titleNameModifier;
    userViewLayoutModel.userViewTitleNameLayout  = [YYTextLayout layoutWithContainer:titleNameContainer text:replyAttributedString];
    userViewLayoutModel.userViewAutoLabelHeight = MAX(CommunityUserHeadImageHeight / 2, [titleNameModifier heightForLineCount:userViewLayoutModel.userViewTitleNameLayout.rowCount]);

    // 回复时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    NSString *userViewDetailNameTimeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:replyModel.createTime.integerValue]];
    NSMutableAttributedString *userViewDetailNameAttributedString = [[NSMutableAttributedString alloc] initWithString:userViewDetailNameTimeString];
    userViewDetailNameAttributedString.font = [UIFont systemFontOfSize:CommunityUserViewDetailFontSize];
    userViewDetailNameAttributedString.color = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
    userViewDetailNameAttributedString.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *userViewDetailNameTextContainer = [YYTextContainer containerWithSize:CGSizeMake(CommunityUserViewTextWidth, 9999)];
    userViewDetailNameTextContainer.maximumNumberOfRows = 1;
    userViewLayoutModel.userViewDetailNameLayout = [YYTextLayout layoutWithContainer:userViewDetailNameTextContainer text:userViewDetailNameAttributedString];
    
    userViewLayoutModel.userViewHeight = CommunityUserViewHeight - CommunityUserHeadImageHeight / 2 + userViewLayoutModel.userViewAutoLabelHeight;
    
    return userViewLayoutModel;
}

+ (instancetype)userViewReplyModelWithCommunityModel:(HTCommunityModel *)communityModel {
    HTCommunityUserViewLayoutModel *userViewLayoutModel = [[HTCommunityUserViewLayoutModel alloc] init];
    
    // 名字
    NSMutableAttributedString *userViewTitleNameAttributedString = [[NSMutableAttributedString alloc] initWithString:communityModel.publisher];
    userViewTitleNameAttributedString.font = [UIFont systemFontOfSize:CommunityUserViewTitleFontSize];
    userViewTitleNameAttributedString.color = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
    userViewTitleNameAttributedString.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *userViewTitleNameTextContainer = [YYTextContainer containerWithSize:CGSizeMake(CommunityUserViewTextWidth, 9999)];
    userViewTitleNameTextContainer.maximumNumberOfRows = 1;
    userViewLayoutModel.userViewTitleNameLayout = [YYTextLayout layoutWithContainer:userViewTitleNameTextContainer text:userViewTitleNameAttributedString];
    
    // 发表时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    NSString *userViewDetailNameTimeString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:communityModel.createTime.integerValue]];
    NSMutableAttributedString *userViewDetailNameAttributedString = [[NSMutableAttributedString alloc] initWithString:userViewDetailNameTimeString];
    userViewDetailNameAttributedString.font = [UIFont systemFontOfSize:CommunityUserViewDetailFontSize];
    userViewDetailNameAttributedString.color = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
    userViewDetailNameAttributedString.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *userViewDetailNameTextContainer = [YYTextContainer containerWithSize:CGSizeMake(CommunityUserViewTextWidth, 9999)];
    userViewDetailNameTextContainer.maximumNumberOfRows = 1;
    userViewLayoutModel.userViewDetailNameLayout = [YYTextLayout layoutWithContainer:userViewDetailNameTextContainer text:userViewDetailNameAttributedString];
    
    // 整个userView 高度
    userViewLayoutModel.userViewHeight = CommunityUserViewHeight;

    return userViewLayoutModel;
}

@end



@implementation HTCommunityReplyLayoutModel

- (void)dealloc {
	
}

+ (instancetype)replyLayoutModelWithOriginReplyModel:(CommunityReply *)originReplyModel {
	HTCommunityReplyLayoutModel *replyLayoutModel = [[HTCommunityReplyLayoutModel alloc] init];
	replyLayoutModel.originReplyModel = originReplyModel;
	return replyLayoutModel;
}

@end



























@implementation WBTextLinePositionModifier

- (instancetype)init {
	self = [super init];
	
	#ifdef __IPHONE_9_0
		_lineHeightMultiple = 1.34;   // for PingFang SC
	#elif
	    _lineHeightMultiple = 1.3125; // for Heiti SC
	#endif
	
	return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
	//CGFloat ascent = _font.ascender;
	CGFloat ascent = _font.pointSize * 0.86;
	
	CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
	for (YYTextLine *line in lines) {
		CGPoint position = line.position;
		position.y = _paddingTop + ascent + line.row  * lineHeight;
		line.position = position;
	}
}

- (id)copyWithZone:(NSZone *)zone {
	WBTextLinePositionModifier *one = [self.class new];
	one->_font = _font;
	one->_paddingTop = _paddingTop;
	one->_paddingBottom = _paddingBottom;
	one->_lineHeightMultiple = _lineHeightMultiple;
	return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
	if (lineCount == 0) return 0;
	//    CGFloat ascent = _font.ascender;
	//    CGFloat descent = -_font.descender;
	CGFloat ascent = _font.pointSize * 0.86;
	CGFloat descent = _font.pointSize * 0.14;
	CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
	return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end
