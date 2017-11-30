//
//  HTDiscoverDownloadCell.m
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDiscoverDownloadCell.h"
#import "THToeflDiscoverModel.h"

@interface HTDiscoverDownloadCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) UIButton *downloadCountButton;

@end

@implementation HTDiscoverDownloadCell

- (void)didMoveToSuperview {
	[self addSubview:self.headImageView];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.detailNameLabel];
	[self addSubview:self.downloadCountButton];
	[self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(20);
		make.centerY.mas_equalTo(self);
		make.width.height.mas_equalTo(45);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.headImageView.mas_right).offset(15);
		make.top.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(self.downloadCountButton.mas_left);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.bottom.mas_equalTo(self.headImageView);
		make.right.mas_equalTo(self.downloadCountButton.mas_left);
	}];
	[self.downloadCountButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(- 30);
		make.centerY.mas_equalTo(self);
	}];
}

- (void)setModel:(THToeflDiscoverModel *)model row:(NSInteger)row {
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[[UIImage imageNamed:@"CommunityDiscoverPlaceholder"] ht_imageByRoundCornerRadius:45 / 2.0 corners:UIRectCornerAllCorners borderWidth:0 borderColor:nil borderLineJoin:kCGLineJoinRound]];
	self.titleNameLabel.font = [[UIFont systemFontOfSize:15] ht_userSizeFont];
	self.titleNameLabel.text = model.title;
	
	self.detailNameLabel.attributedText = model.detailAttributedString;
	
	NSDictionary *normalDictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
	NSDictionary *selectedDictionary = @{NSForegroundColorAttributeName:[UIColor ht_colorString:@"f4cd6f"]};
	NSMutableAttributedString *downloadAttributedString = [[[NSAttributedString alloc] initWithString:@"已有" attributes:normalDictionary] mutableCopy];
	NSAttributedString *appendAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人\n", model.viewCount] attributes:selectedDictionary];
	[downloadAttributedString appendAttributedString:appendAttributedString];
	appendAttributedString = [[NSAttributedString alloc] initWithString:@"下载" attributes:normalDictionary];
	[downloadAttributedString appendAttributedString:appendAttributedString];
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	[downloadAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
											  NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, downloadAttributedString.length)];
	[self.downloadCountButton setAttributedTitle:downloadAttributedString forState:UIControlStateNormal];
	
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
//		_headImageView.layer.cornerRadius = 45 / 2;
//		_headImageView.layer.masksToBounds = true;
	}
	return _headImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
	}
	return _detailNameLabel;
}

- (UIButton *)downloadCountButton {
	if (!_downloadCountButton) {
		_downloadCountButton = [[UIButton alloc] init];
		_downloadCountButton.titleLabel.numberOfLines = 0;
		UIColor *normalColor = [UIColor ht_colorString:@"2479da"];
		UIColor *higlightColor = [normalColor colorWithAlphaComponent:0.5];
		[_downloadCountButton setBackgroundImage:[UIImage ht_pureColor:normalColor] forState:UIControlStateNormal];
		[_downloadCountButton setBackgroundImage:[UIImage ht_pureColor:higlightColor] forState:UIControlStateHighlighted];
		_downloadCountButton.layer.cornerRadius = 2;
		_downloadCountButton.layer.masksToBounds = true;
		_downloadCountButton.contentEdgeInsets = UIEdgeInsetsMake(3, 7, 3, 7);
		[_downloadCountButton setContentHuggingPriority:999 forAxis:UILayoutConstraintAxisHorizontal];
		[_downloadCountButton setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisHorizontal];
		_downloadCountButton.userInteractionEnabled = false;
	}
	return _downloadCountButton;
}

@end
