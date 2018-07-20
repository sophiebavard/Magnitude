function [Ntrial,Nsub] = BarsAndErrorPlot_Total(DataMatrix,Colors,Yinf,Ysup,Font,Title,LabelX,LabelY,varargin)

% Creates a bar plot with error bars.
% Warning : the function can accept any number of arguments > 9.
% After the Title, LabelX, LabelY : varargin names the bars

[Ntrial,Nsub]=size(DataMatrix);

curve= nanmean(DataMatrix,2);
sem  = nanstd(DataMatrix')'/sqrt(Nsub);

% absci=1:Ntrial;

for n=1:Ntrial
    % first bar
    bar(n,curve(n),...
        'FaceColor',Colors(n,:),...
        'EdgeColor',Colors(n,:),...
        'BarWidth',0.75,...
        'LineWidth',1);
    hold on
    errorbar(n,curve(n),sem(n),...
        'Color',[0 0 0],...
        'LineStyle','none',...
        'LineWidth',1);
end

% plot best model

ylim([Yinf Ysup]);
set(gca,'FontSize',Font,...
    'XLim',[0 Ntrial+1],...
    'XTick',1:Ntrial,...
    'YTick',-10:0.2:10,...
    'XTickLabel',varargin);

title(Title);
xlabel(LabelX);
ylabel(LabelY);




 
 
 
 
    




