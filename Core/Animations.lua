VisibleWhilePlayingAnimationMixin = {}

function VisibleWhilePlayingAnimationMixin:Show()
	self:GetParent():Show();
end

function VisibleWhilePlayingAnimationMixin:Hide()
	self:GetParent():Hide();
end

TargetsVisibleWhilePlayingAnimationMixin = {}

function TargetsVisibleWhilePlayingAnimationMixin:Show()
	self:SetTargetsShown(true, self:GetAnimations());
end

function TargetsVisibleWhilePlayingAnimationMixin:Hide()
	self:SetTargetsShown(false, self:GetAnimations());
end

function TargetsVisibleWhilePlayingAnimationMixin:SetTargetsShown(shown, ...)
	for i = 1, select("#", ...) do
		local anim = select(i, ...);
		if anim then
			local target = anim:GetTarget();
			if target and target.SetShown then
				target:SetShown(shown);
			end
		end
	end
end