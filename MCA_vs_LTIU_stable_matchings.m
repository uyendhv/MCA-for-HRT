clc
clear vars
clear all
close all
%
n = 50;
m = 10;
k = 50; %the number of instances has the same (n,m,p1,p2)
%==========================================================================
%LTIU algorithm: count the perfect and maximal matchings
%
LTIU_num_stable_matchings = [];
LTIU_num_perfect_matching = []; 
LTIU_num_maximal_matching = [];
LTIU_avg_maximal_matching = [];
for p1 = 0.1:0.1:0.8
    num_stable_matchings = [];
    num_perfect_matching = [];
    num_maximal_matching = [];
    avg_maximal_matching = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output1\LTIU(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %count for instances
        s = 0; %for stable matchings
        p = 0; %for the perfect matchings
        q = 0; %for the maximal matchings
        x = 0; %for average cost of maximal matchings
        for i = 1:k
            if (f_results(i,3) == 1)
                s = s + 1;
            end
            if (f_results(i,2) == 0)&&(f_results(i,3) == 1)
                p = p + 1;
            end
            if (f_results(i,2) ~= 0)&&(f_results(i,3) == 1)
                q = q + 1;
                x = x + f_results(i,2);
            end
        end
        num_stable_matchings(end+1) = s;
        num_perfect_matching(end+1) = p;
        num_maximal_matching(end+1) = q;
        if (q ==0)
            avg_maximal_matching(end+1) = 0;
        else
            avg_maximal_matching(end+1) = x/q;
        end
    end
    LTIU_num_stable_matchings = [LTIU_num_stable_matchings; num_stable_matchings];
    LTIU_num_perfect_matching = [LTIU_num_perfect_matching; num_perfect_matching];
    LTIU_num_maximal_matching = [LTIU_num_maximal_matching; num_maximal_matching];
    LTIU_avg_maximal_matching = [LTIU_avg_maximal_matching; avg_maximal_matching];
end
%==========================================================================
%MCA algorithm: count the perfect, maximal and unstable matchings
%
MCA_num_stable_matchings = [];
MCA_num_perfect_matching = []; 
MCA_num_maximal_matching = [];
MCA_avg_maximal_matching = [];
for p1 = 0.1:0.1:0.8
    num_stable_matchings = [];
    num_perfect_matching = [];
    num_maximal_matching = [];
    avg_maximal_matching = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output1\MCA(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %count for instances
        s = 0; %for stable matchings
        p = 0; %for the perfect matchings
        q = 0; %for the maximal matchings
        x = 0; %for average cost of maximal matchings
        for i = 1:k
            if (f_results(i,3) == 1)
                s = s + 1;
            end
            if (f_results(i,2) == 0)&&(f_results(i,3) == 1)
                p = p + 1;
            end
            if (f_results(i,2) ~= 0)&&(f_results(i,3) == 1)
                q = q + 1;
                x = x + f_results(i,2);
            end
        end
        num_stable_matchings(end+1) = s;
        num_perfect_matching(end+1) = p;
        num_maximal_matching(end+1) = q;
        if (q ==0)
            avg_maximal_matching(end+1) = 0;
        else
            avg_maximal_matching(end+1) = x/q;
        end
    end
    MCA_num_stable_matchings = [MCA_num_stable_matchings; num_stable_matchings];
    MCA_num_perfect_matching = [MCA_num_perfect_matching; num_perfect_matching];
    MCA_num_maximal_matching = [MCA_num_maximal_matching; num_maximal_matching];
    MCA_avg_maximal_matching = [MCA_avg_maximal_matching; avg_maximal_matching];
end
%==========================================================================
%
LTIU_num_stable_matchings = LTIU_num_stable_matchings*100/50;
LTIU_num_perfect_matching = LTIU_num_perfect_matching*100/50;
%
MCA_num_stable_matchings = MCA_num_stable_matchings*100/50;
MCA_num_perfect_matching = MCA_num_perfect_matching*100/50;
%
%for plotting stable matchings
% type = 1;
% rows = 1:4;
% LTIU_plot_data = LTIU_num_stable_matchings(rows,:);
% MCA_plot_data  = MCA_num_stable_matchings(rows,:);
%
%for plotting perfect matching
type = 2;
rows = 5:8;
LTIU_plot_data = LTIU_num_perfect_matching(rows,:);
MCA_plot_data  = MCA_num_perfect_matching(rows,:);


%create a figure (left,top,width,height) 
figure('position',[50, 50, 800, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 500, 300]);
hold on
%
%for LTIU - lines 1-4
LTIU_line1 = plot(LTIU_plot_data(1,:),'--bo','MarkerEdgeColor','k');
LTIU_line2 = plot(LTIU_plot_data(2,:),'--bs','MarkerEdgeColor','k','MarkerSize',7);
LTIU_line3 = plot(LTIU_plot_data(3,:),'--b>','MarkerEdgeColor','k');
LTIU_line4 = plot(LTIU_plot_data(4,:),'--b^','MarkerEdgeColor','k');
%
%for MCA - lines
MCA_line1 = plot(MCA_plot_data(1,:),'--ro','MarkerEdgeColor','k','MarkerFaceColor','k');
MCA_line2 = plot(MCA_plot_data(2,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',7);
MCA_line3 = plot(MCA_plot_data(3,:),'--r>','MarkerEdgeColor','k','MarkerFaceColor','k');
MCA_line4 = plot(MCA_plot_data(4,:),'--r^','MarkerEdgeColor','k','MarkerFaceColor','k');
%
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
ylim([0,105]);
yticks(0:10:105);
%
hx = xlabel('Probability of ties p_2','color','k');
set(hx, 'FontSize', 13)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',13)
%
if (type == 1)
    hy = ylabel('Percentage of stable matchings','color','k');
else
    hy = ylabel('Percentage of perfect matchings','color','k');
end
%
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