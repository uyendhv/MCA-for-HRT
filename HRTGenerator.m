%======================================================================================
%By Hoang Huu Viet
%Adopt from: Ian Philip Gent, Patrick Prosser. An Empirical Study of the Stable Marriage Problem with
%Ties and Incomplete Lists
%======================================================================================
function HRTGenerator()
clc
clear vars
clear all
close all
%number of instances has the same (n,m,p1,p2)
k = 50;
for n = 100:100:700
    for m = 10:10:50
        for p1 = 0.5 %0.1:0.1:0.8
            for p2 = 0.5 % 0.0:0.1:1.0
                i = 1;
                while (i <= k)
                    R = rand(n,m);
                    H = rand(m,n);
                    %generate residents' and hospitals' preference lists
                    [~,res_pref_list] = sort(R,2);
                    [~,hos_pref_list] = sort(H,2);
                    %generate an HRT instance
                    [res_rank_list,hos_rank_list,hos_caps_list] = make_rank_lists(res_pref_list,hos_pref_list,p1,p2);
                    %
                    if (~isempty(res_rank_list)) 
                        %create a random matching
                        M = make_random_matching(res_rank_list,hos_rank_list,hos_caps_list);
                        %save preference matrices and the matching to file
                        filename = ['input3\I(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                        save(filename,'res_rank_list','hos_rank_list','hos_caps_list','M');
                        %res_pref_list
                        %hos_rank_list
                        %
                        %res_pref_list
                        %hos_rank_list
                        i = i + 1;
                    end
                end
            end
        end
    end
end
end
%============================================================================================
function [res_rank_list,hos_rank_list,hos_caps_list] = make_rank_lists(res_pref_list,hos_pref_list,p1,p2)
%size of HRT instance
n = size(res_pref_list,1);
m = size(hos_pref_list,1);
%
%1. generate an instance of HRP with incomplete lists
%
%generate randomly using a probability 
for i = 1:n
    %r - rank
    for r1 = 1:m
        if (rand() <= p1)
            %delete hospital j from resident i's list
            j = res_pref_list(i,r1);
            res_pref_list(i,r1) = 0;
            %delete resident i from hospital j's list
            r2 = find(hos_pref_list(j,:) == i,1,'first');
            hos_pref_list(j,r2) = 0;
        end
    end
end
%
%2. generate an instance of HRP with Ties, i.e. HRT
%
res_rank_list = zeros(n,m);
hos_rank_list = zeros(m,n);
hos_caps_list = zeros(m,1);
%check if any resident has an empty preference list, discard the instance
for i = 1:n
    if ~any(res_pref_list(i,:))
        res_rank_list = [];
        return;
    end
end
%check if any hospital has an empty preference list, discard the instance
for i = 1:m
    if ~any(hos_pref_list(i,:))
        res_rank_list = [];
        return;
    end
end
%
%create ties in residents' rank list
for i = 1:n
    %
    idx = find(res_pref_list(i,:) ~=0,1,'first');
    res_rank_list(i,res_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:m
        if (res_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            res_rank_list(i,res_pref_list(i,j)) = cj;
        end
    end
end
%
%create ties in hospitals' rank list
for i = 1:m
    %
    idx = find(hos_pref_list(i,:) ~=0,1,'first');
    hos_rank_list(i,hos_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:n
        if (hos_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            hos_rank_list(i,hos_pref_list(i,j)) = cj;
        end
    end
end
%
%3. generate capacity for hospitals
for i = 1:m
    %res_idxs = find(hos_rank_list(i,:) > 0);
    %hos_caps_list(i) = randi(size(res_idxs,2),1,1);
    hos_caps_list(i) = ceil(n/m);
end    
end
%==========================================================================