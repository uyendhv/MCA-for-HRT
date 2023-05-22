clc
clear vars
clear all
close all
% %
% res_rank_list = [1 2 0; 1 2 0; 1 0 2; 0 1 2; 2 1 0; 1 2 0];
% hos_rank_list = [1 2 3 0 4 5; 2 1 0 4 4 3; 0 0 2 1 0 0];
% hos_caps_list = [2 2 2];
% res_rank_list =...
%      [0     1     0     2;
%       3     0     1     4;
%       0     2     0     0;
%       0     1     2     3;
%       1     0     2     1;
%       0     1     0     1];
% 
% hos_rank_list =...
%     [0     1     0     0     0     0;
%      2     0     3     1     0     3;
%      0     2     0     1     3     0;
%      0     2     1     0     0     2];
% hos_caps_list =...
%      [2 2 2 2];
% [M] = make_random_matching(res_rank_list,hos_rank_list,hos_caps_list);
% %res_rank_list
% %hos_rank_list
% %hos_caps_list
% %M
 res_rank_list = [1 3 2 0 0; 
                 1 0 3 2 2; 
                 1 3 0 0 2; 
                 1 2 0 2 0; 
                 2 3 1 0 0; 
                 2 1 1 0 3
                 4 0 1 2 3
                 0 0 0 2 1];
%
hos_rank_list = [5 2 1 3 2 4 2 0; 
                 4 0 3 3 1 2 0 0; 
                 3 1 0 0 1 2 3 0
                 0 2 0 3 0 0 4 1
                 0 3 1 0 0 2 2 2];
%
hos_caps_list = [2 3 1 1 1];
% %
 [M] = make_random_matching(res_rank_list,hos_rank_list,hos_caps_list);
%  %M =[ 0     1     2     1     0     3     4     5];
% %M=[ 2     1     1     2     3     2     4     5];
% M =[0 5 1 4 0 1 3 0];
[f_time,f_cost,f_stable,f_iter,f_reset]= MCA(res_rank_list,hos_rank_list,hos_caps_list,M);