clc
clear vars
clear all
close all
%==========================================================================
%for MCA
MCA_time = [];
MCA_iter = [];
for n = 100:100:700
    f_avg_time = [];
    f_avg_iter = [];
    for m = 10:10:50
        for p1 = 0.5
            for p2 = 0.5
                %load to file for averaging results
                filename = ['output2\MCA(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
                load(filename,'f_results');
                f_avg_time(end+1) = mean(f_results(:,1));
                f_avg_iter(end+1) = mean(f_results(:,4));                
            end
        end
    end
    MCA_time = [MCA_time;f_avg_time];
    MCA_iter = [MCA_iter;f_avg_iter];
end
%==========================================================================
%
%for plot figures
%type = 1;
%MCA_plot_data  = MCA_time;

type = 2;
MCA_plot_data  = MCA_iter;
%
%create a figure (left,top,width,height) 
figure('position',[50, 50, 1000, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 600, 300]);
hold on

%---------------------------------------------------------------
[P2,P1] = meshgrid([100:100:700],[10:10:50]);
surf(MCA_plot_data);
%legend([h1,h2], {'LTIU', 'MCA'});
%
set(gcf,'color','w');
xticks(1:1:5);
xticklabels({'10','20','30','40','50'});
yticks(1:1:7);
yticklabels({'100','200','300','400','500','600','700'});
%
hx = xlabel('Number of hospitals','color','k');
set(hx, 'FontSize', 13)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',13)
%
hy = ylabel('Number of residents','color','k');
set(hy, 'FontSize', 13)
hxb = get(gca,'YTickLabel');
set(gca,'YTickLabel',hxb,'fontsize',13)
%
if (type == 1)
    hz = zlabel('Average execution time(s)','color','k');
else
    hz = zlabel('Average number of iterations','color','k');
end
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