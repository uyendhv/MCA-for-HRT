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
rows = 1:4;
LTIU_plot_data = LTIU_time(rows,:);
MCS_plot_data  = MCA_time(rows,:);
%
%create a figure (left,top,width,height) 
figure('position',[50, 50, 800, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 500, 300]);
hold on
%
%for LTIU - lines
LTIU_line1 = plot(LTIU_plot_data(1,:),'--bo','MarkerEdgeColor','k');
LTIU_line2 = plot(LTIU_plot_data(2,:),'--bs','MarkerEdgeColor','k','MarkerSize',7);
LTIU_line3 = plot(LTIU_plot_data(3,:),'--b>','MarkerEdgeColor','k');
LTIU_line4 = plot(LTIU_plot_data(4,:),'--b^','MarkerEdgeColor','k');
%
%for MCA - lines
MCA_line1 = plot(MCS_plot_data(1,:),'--ro','MarkerEdgeColor','k','MarkerFaceColor','k');
MCA_line2 = plot(MCS_plot_data(2,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',7);
MCA_line3 = plot(MCS_plot_data(3,:),'--r>','MarkerEdgeColor','k','MarkerFaceColor','k');
MCA_line4 = plot(MCS_plot_data(4,:),'--r^','MarkerEdgeColor','k','MarkerFaceColor','k');
%=========================================================================
%for legend for p1 = 0.1-0.4
if (rows(1) == 1)
hand = legend([LTIU_line1,LTIU_line2,LTIU_line3,LTIU_line4,...
               MCA_line1,MCA_line2,MCA_line3,MCA_line4],...
       'LTIU p_1 = 0.1','LTIU p_1 = 0.2','LTIU p_1 = 0.3','LTIU p_1 = 0.4',...
       'MCA p_1 = 0.1','MCA p_1 = 0.2','MCA p_1 = 0.3','MCA p_1 = 0.4');  
else
hand = legend([LTIU_line1,LTIU_line2,LTIU_line3,LTIU_line4,...
               MCA_line1,MCA_line2,MCA_line3,MCA_line4],...
       'LTIU p_1 = 0.5','LTIU p_1 = 0.6','LTIU p_1 = 0.7','LTIU p_1 = 0.8',...
       'MCA p_1 = 0.5','MCA p_1 = 0.6','MCA p_1 = 0.7','MCA p_1 = 0.8');  
end   
%=========================================================================
%for layout of figure
set(hand,'fontsize',13,'Position',[0.76, 0.3, 0.2, 0.5]);  
legend('boxoff')
set(gcf,'color','w');
xlim([1 11]);
xticks(1:11);
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'})
%ylim([-1.5,2]);
%yticks(-1.5:0.5:2);
%
hx = xlabel('Probability of ties p_2','color','k');
set(hx, 'FontSize', 13)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',13)
%
hy = ylabel('Average execution time(s)(log10 scale)','color','k');
set(hy,'FontSize',13)
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