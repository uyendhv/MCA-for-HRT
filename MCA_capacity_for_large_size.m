clc
clear vars
clear all
close all
%==========================================================================
%for MCA
k = 50;
MCA_capacity = [];
for n = 100:100:700
    avg_capacity = [];
    for m = 10:10:50
        for p1 = 0.5
            for p2 = 0.5
                %count for instances
                c = 0; %for capacity
                t = 0;
                for i = 1:k
                   %load the preference matrices and the matching from file
                    filename = ['input3\I(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                    load(filename,'res_rank_list','hos_rank_list','hos_caps_list','M');
                    c = c + sum(hos_caps_list);
                    t = t + size(hos_caps_list,1);
                end
                avg_capacity(end+1) = c/t;           
            end
        end
    end
    MCA_capacity = [MCA_capacity; avg_capacity];
end
%==========================================================================
%
%for plot figures
MCA_plot_data  = MCA_capacity;

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
hz = zlabel('Average capacity','color','k');
set(hz,'FontSize',13)
%zticks(0:25:200);
zlim([1,80]);
zticks(0:10:70);
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