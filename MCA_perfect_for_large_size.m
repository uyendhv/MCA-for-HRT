clc
clear vars
clear all
close all
%==========================================================================
%for MCA
k = 50;
MCA_num_perfect_matching = [];
for n = 100:100:700
    num_perfect_matching = [];
    for m = 10:10:50
        for p1 = 0.5
            for p2 = 0.5
                %load to file for averaging results
                filename = ['output3\MCA(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
                load(filename,'f_results');
                %count for instances
                p = 0; %for the perfect matchings
                for i = 1:k
                    if (f_results(i,2) == 0)&&(f_results(i,3) == 1)
                        p = p + 1;
                    end
                end
                num_perfect_matching(end+1) = p;           
            end
        end
    end
    MCA_num_perfect_matching = [MCA_num_perfect_matching; num_perfect_matching];
end
%==========================================================================
%
%for plot figures
MCA_plot_data  = MCA_num_perfect_matching*100/50;

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
hz = zlabel('Percentage of perfect matchings','color','k');
set(hz,'FontSize',13)
zlim([0,100]);
zticks(0:10:100);
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