//
//  HTDownloadProgressCell.m
//  GMat
//
//  Created by hublot on 2017/6/28.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTDownloadProgressCell.h"
#import "HTFileDownloadModel.h"

@interface HTDownloadProgressCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) UIButton *downloadButton;

@property (nonatomic, strong) CAShapeLayer *backgroundShapeLayer;

@property (nonatomic, strong) CAShapeLayer *progressShapeLayer;

@property (nonatomic, strong) HTFileDownloadModel *model;

@end

@implementation HTDownloadProgressCell

- (void)didMoveToSuperview {
	
	UIView *selectedColorView = [[UIView alloc] init];
	selectedColorView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
	[self.selectedBackgroundView addSubview:selectedColorView];
	[selectedColorView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(self.selectedBackgroundView);
	}];
	
	[self.contentView addSubview:self.headImageView];
	[self.contentView addSubview:self.titleNameLabel];
	[self.contentView addSubview:self.detailNameLabel];
	[self.contentView addSubview:self.downloadButton];
	[self.contentView.layer addSublayer:self.backgroundShapeLayer];
	[self.contentView.layer addSublayer:self.progressShapeLayer];
	[self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(20);
		make.centerY.mas_equalTo(self);
		make.width.height.mas_equalTo(60);
	}];
	[self.titleNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.headImageView).offset(5);
		make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
		make.right.mas_equalTo(self.downloadButton.mas_left).offset(- 10);
	}];
	[self.detailNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.titleNameLabel);
		make.bottom.mas_equalTo(self.headImageView).offset(- 5);
		make.right.mas_equalTo(self.downloadButton.mas_left).offset(- 10);
	}];
	[self.downloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(- 20);
		make.centerY.mas_equalTo(self);
		make.width.height.mas_equalTo(30);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.downloadButton.center radius:self.downloadButton.bounds.size.width / 2.0 startAngle: - M_PI_2 endAngle:M_PI * 1.5 clockwise:true];
	self.backgroundShapeLayer.path = bezierPath.CGPath;
	self.progressShapeLayer.path = bezierPath.CGPath;
}

- (void)setModel:(HTFileDownloadModel *)model row:(NSInteger)row {
	_model = model;
	
	__weak typeof(self) weakSelf = self;
	
	NSString *(^convertByteString)(CGFloat megaByte) = ^NSString *(CGFloat megaByte) {
        if (megaByte == - 1) {
            return @"未知";
        } else if (megaByte <= 0) {
			return @"0 MB";
		} else if (megaByte < 1) {
			return [NSString stringWithFormat:@"%.2lf KB", megaByte * 1024];
		} else {
			return [NSString stringWithFormat:@"%.2lf MB", megaByte];
		}
	};
	[model bk_removeAllBlockObservers];
	[model bk_addObserverForKeyPath:NSStringFromSelector(@selector(completedMegaByte)) options:NSKeyValueObservingOptionInitial task:^(id obj, NSDictionary *change) {
		weakSelf.progressShapeLayer.strokeEnd = weakSelf.model.completedMegaByte / weakSelf.model.totalMegaByte;
		NSString *totalString = convertByteString(weakSelf.model.totalMegaByte);
		NSString *completeString = convertByteString(weakSelf.model.completedMegaByte);
		if (weakSelf.model.completedMegaByte >= weakSelf.model.totalMegaByte && weakSelf.model.totalMegaByte != - 1) {
			weakSelf.progressShapeLayer.hidden = weakSelf.backgroundShapeLayer.hidden = weakSelf.downloadButton.hidden = true;
			weakSelf.detailNameLabel.text = totalString;
		} else {
			weakSelf.progressShapeLayer.hidden = weakSelf.backgroundShapeLayer.hidden = weakSelf.downloadButton.hidden = false;
			weakSelf.detailNameLabel.text = [NSString stringWithFormat:@"%@/%@", completeString, totalString];
		}
	}];
	self.titleNameLabel.text = model.fileTitleName;
	self.headImageView.image = [UIImage imageNamed:@"CommunityDiscoverFile"];
    [model setSelectedObserver:^(BOOL selected) {
        weakSelf.downloadButton.selected = selected;
    }];
	
	self.downloadButton.selected = weakSelf.model.selected;
    [self.downloadButton ht_whenTap:^(UIView *view) {
		weakSelf.model.selected = !weakSelf.model.selected;
    }];
    [self layoutSubviews];
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
	}
	return _headImageView;
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:15];
		_titleNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
	}
	return _titleNameLabel;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStyleSecondaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:13];
	}
	return _detailNameLabel;
}

- (UIButton *)downloadButton {
	if (!_downloadButton) {
		_downloadButton = [[UIButton alloc] init];
		UIImage *normalImage = [UIImage imageNamed:@"CommunityDiscoverStop"];
		UIImage *selectedImage = [UIImage imageNamed:@"CommunityDiscoverStart"];
		[_downloadButton setImage:[normalImage ht_resetSize:CGSizeMake(12, 12)] forState:UIControlStateNormal];
		[_downloadButton setImage:[selectedImage ht_resetSize:CGSizeMake(12, 12)] forState:UIControlStateSelected];
		[_downloadButton setContentHuggingPriority:999 forAxis:UILayoutConstraintAxisHorizontal];
		[_downloadButton setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisHorizontal];
	}
	return _downloadButton;
}

- (CAShapeLayer *)backgroundShapeLayer {
	if (!_backgroundShapeLayer) {
		_backgroundShapeLayer = [CAShapeLayer layer];
		_backgroundShapeLayer.fillColor = [UIColor clearColor].CGColor;
		_backgroundShapeLayer.strokeColor = [UIColor ht_colorString:@"a0a0a0"].CGColor;
		_backgroundShapeLayer.lineWidth = 2;
	}
	return _backgroundShapeLayer;
}

- (CAShapeLayer *)progressShapeLayer {
	if (!_progressShapeLayer) {
		_progressShapeLayer = [CAShapeLayer layer];
		_progressShapeLayer.fillColor = [UIColor clearColor].CGColor;
		_progressShapeLayer.strokeColor = [UIColor ht_colorString:@"2479da"].CGColor;
		_progressShapeLayer.lineWidth = self.backgroundShapeLayer.lineWidth;
		_progressShapeLayer.lineCap = kCALineCapRound;
		_progressShapeLayer.lineJoin = kCALineJoinRound;
		_progressShapeLayer.strokeEnd = 0;
	}
	return _progressShapeLayer;
}

@end
