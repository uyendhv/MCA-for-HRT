clc
clear vars
clear all
close all
n = 50;
m = 10;
%==========================================================================
%LTIU algorithm
LTIU_time = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output1\LTIU(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    LTIU_time = [LTIU_time;f_avg_time];
end
%==========================================================================
%for MCA
MCA_time = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output1\MCA(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    MCA_time = [MCA_time;f_avg_time];
end
%==========================================================================
%
LTIU_time = log10(LTIU_time);
MCA_time  = log10(MCA_time);
%
%for plot figures
rows = 1:8;
LTIU_plot_data = LTIU_time(rows,:);
MCA_plot_data  = MCA_time(rows,:);
%
%create a figure (left,top,width,height) 
figure('position',[50, 50, 1000, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 600, 300]);
hold on

%---------------------------------------------------------------
[P2,P1] = meshgrid([0.0:0.1:1.0],[0.1:0.1:0.8]);
h1= surf(P2,P1,LTIU_plot_data);
h2 = surf(P2,P1,MCA_plot_data);
legend([h1,h2], {'LTIU', 'MCA'});
%
set(gcf,'color','w');
xticks(0.0:0.1:1.0);
yticks(0.1:0.1:0.8);
%
hx = xlabel('Probability of ties p_2','color','k');
set(hx, 'FontSize', 13)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',13)
%
hy = ylabel('Probability of incomplete lists p_1','color','k');
set(hy, 'FontSize', 13)
hxb = get(gca,'YTickLabel');
set(gca,'YTickLabel',hxb,'fontsize',13)
%
hz = zlabel('Average execution time(s)(log10 scale)','color','k');
set(hz,'FontSize',13)
%
grid on
ax = gca;
set(ax,'GridLineStyle','--') 
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.4;
box on
%}