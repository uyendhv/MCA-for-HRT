function [f_time,f_cost,f_stable,f_iter,f_reset]= LTIU(res_rank_list,hos_rank_list,hos_caps_list,M)
%==========================================================================
% By Hoang Huu Viet
% LTIU algorithm
% reference: M. Gelain, M. S. Pini, F. Rossi, K. B. Venable1, T. Wals
% Local search for stable marriage problems with ties and incomplete lists
%==========================================================================
n = size(res_rank_list,1);
f = find_cost_of_matching(res_rank_list,hos_rank_list,hos_caps_list,M);
%
%initialize the best matching
M_best = M;
f_best = f;
f_stable = 0;
f_reset = 0;
%
p = 0.03;
MAX_ITERS = 2000;
iter = 0;
tic
while (iter <= MAX_ITERS)
    iter = iter + 1;
    %if a perfect matching is found
    if (f_best == 0) && (f_stable ==1)
        break;
    end
    %swap the role of men and women at iterations
    if (mod(iter,2) == 1)
        X = find_undominated_residents(res_rank_list,hos_rank_list,hos_caps_list,M);
    else
        X = find_undominated_hospitals(res_rank_list,hos_rank_list,hos_caps_list,M);
    end
    %check if the undominated blocking pairs of M is empty, i.e. M is stable
    if (isempty(X))
        f_stable = 1;
        if (f_best > f)
            M_best = M;
            f_best = f;
        end
        %perform a random restart
        if (f_best > 0)
           f_reset = f_reset + 1;
           M = make_random_matching(res_rank_list,hos_rank_list,hos_caps_list);
           f = find_cost_of_matching(res_rank_list,hos_rank_list,hos_caps_list,M);
        end
        continue;
    end
    %find the neighbor set of matching M
    neighbors = {};  
    f_cost = [];
    for i = 1:size(X,1)
        %take undominated blocking pair (ri,hj)     
        ri = X(i,1);
        hi = X(i,2);
        rj = X(i,3);
        hj = X(i,4);
        %
        %remove undominated blocking pair (ri,hj) in M to obtain a neighbor
        M_child = M;
        M_child(ri) = hj;
        if (sum(M_child == hj) > hos_caps_list(hj))
            %rj = find_worst_resident(hos_rank_list,hj,hos_caps_list(hj),M);
            %rj become single
            M_child(rj) = 0;
        end
        %
        %remember a neighbor matching
        neighbors{end+1} = M_child;
        %
        %find the cost after removing undominated blocking pair (ri,hj)
        f = find_cost_of_matching(res_rank_list,hos_rank_list,hos_caps_list,M_child);
        f_cost(end+1) = f;
    end
    %
    if (rand() < p)
        %random walk
        idx = randi(size(f_cost,2),1,1);
    else
        %find the matching with the minnimum cost
        [~,idx] = min(f_cost); 
    end
    %take the best neighbor matching or random walk
    M = neighbors{idx};
    f = f_cost(idx);
end
%M_best
f_time = toc;
f_cost = f_best;
f_iter = iter;
%
%verify the result matching
verify_result_matching(res_rank_list,hos_rank_list,hos_caps_list,M_best);
end
%==========================================================================
%find undominated blocking pairs from resident's point of view
%==========================================================================
function [X] = find_undominated_residents(res_rank_list,hos_rank_list,hos_caps_list,M)
%X: a set of undominated blocking pairs in M from resident's point of view
%
n = size(res_rank_list,1);
m = size(hos_rank_list,1);
%
X = [];
for ri = 1:size(M,2)
    hi = M(ri);
    %
    if (hi > 0)
        rank_ri_hi = res_rank_list(ri,hi);
    else
        rank_ri_hi = n+1;
    end
    %find an undominated blocking pair (ri,hj)
    x = res_rank_list(ri,:);
    [ri_rank_list,idxs] = sort(x); 
    for j = 1:m
        rank_ri_hj = ri_rank_list(j);
        if (rank_ri_hj > 0) && (rank_ri_hj < rank_ri_hi)
            hj = idxs(j);
            cj = hos_caps_list(hj);
            rj = find_worst_resident(hos_rank_list,hj,cj,M);
            if (check_blocking_pair(res_rank_list,hos_rank_list,ri,hi,hj,cj,M) == true)
                %add (ri,hi) and (rj,hj) to X
                X(end+1,:) = [ri,hi,rj,hj];
                break;
            end
        end
    end
end
end
%==========================================================================
%find undominated blocking pairs from hospital's point of view
%==========================================================================
function [X] = find_undominated_hospitals(res_rank_list,hos_rank_list,hos_caps_list,M)
%X: a set of undominated blocking pairs in M from hospital's point of view
%
n = size(res_rank_list,1);
m = size(hos_rank_list,1);
%
X = [];
for hj = 1:m
    cj = hos_caps_list(hj);
    rj = find_worst_resident(hos_rank_list,hj,cj,M);
    if (rj > 0)
        rank_hj_rj= hos_rank_list(hj,rj);
    else
        rank_hj_rj = n+1;
    end
    %        
    %find an undominated blocking pair (ri,hj)
    x = hos_rank_list(hj,:);
    [hj_rank_list,idxs] = sort(x); 
    for i = 1:n
        rank_hj_ri = hj_rank_list(i);
        if (rank_hj_ri > 0) && (rank_hj_ri < rank_hj_rj)
            ri = idxs(i);
            hi = M(ri);
            if (check_blocking_pair(res_rank_list,hos_rank_list,ri,hi,hj,cj,M) == true)
                %add (ri,hi) and (rj,hj) to X
                X(end+1,:) = [ri,hi,rj,hj];
                break;
            end
        end
    end
end
end
%==========================================================================
%find the cost of a matching M
%==========================================================================
function [f] = find_cost_of_matching(res_rank_list,hos_rank_list,hos_caps_list,M)
%f = #nbp + #nsg
%
nbp = 0;
nsg = 0;
for ri = 1:size(M,2)
    %count the number of blocking pairs in M
    hi = M(ri);
    check_bp = false;
    for rj = 1:size(M,2)
        hj = M(rj);
        if (hj == 0)
            continue;
        end
        cj = hos_caps_list(hj);
        if (check_blocking_pair(res_rank_list,hos_rank_list,ri,hi,hj,cj,M) == true)
            %count the number of blocking pairs (ri,hj)
            nbp = nbp + 1;
            check_bp = true;
        end
    end
    %count the number of singles in M which are not in any blocking pairs
    if ((check_bp == false) && (hi == 0))
        nsg = nsg + 1;
    end
end
f = nbp + nsg;
end
%==========================================================================