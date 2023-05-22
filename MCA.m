function [f_time,f_cost,f_stable,f_iter,f_reset]= MCA(res_rank_list,hos_rank_list,hos_caps_list,M)
%==========================================================================
% By Hoang Huu Viet
% MCA: a min-conflicts search algorithm for HRT
%==========================================================================
n = size(res_rank_list,1);
%
%initialize the best matching
M_best = M;
f_best = n;
f_stable = 0;
f_reset = 0;
%
p = 0.03;
MAX_ITERS = 2000;
iter = 0;
tic
while (iter <= MAX_ITERS)
    %find the cost, undominated blocking pairs in M
    [f,X] = find_cost_and_blocking_pairs(res_rank_list,hos_rank_list,hos_caps_list,M);
    %
    %check if the undominated blocking pairs of M is empty, i.e. M is stable
    if isempty(X)
        f_stable = 1;
        if (f_best > f)
            M_best = M;
            f_best = f;
        end
        %escape from a local minimum
        if (f > 0)
            f_reset = f_reset + 1;
            M = make_random_matching(res_rank_list,hos_rank_list,hos_caps_list);
            continue;
        else
            break;
        end
    end
    %
    if (rand() < p)
        %take a random man in undominated blocking pairs
        idx = randi(size(X,1),1,1);
    else
        %take the man with min-conflicts
        [~,idx] = min(X(:,5));
    end
    %
    %take undominated pair (ri,hj) 
    ri = X(idx,1);
    hi = X(idx,2);
    rj = X(idx,3);
    hj = X(idx,4);
    %
    %remove blocking pair (ri,hj) 
    M(ri) = hj;
    if (sum(M == hj) > hos_caps_list(hj))
        %rj - the worst resident assigned to hj become single
        M(rj) = 0;
    end
    %
    iter = iter + 1;
end
M_best
f_time = toc;
f_cost = f_best;
f_iter = iter;
%verify the result matching;
verify_result_matching(res_rank_list,hos_rank_list,hos_caps_list,M_best);
end
%==========================================================================
function [f,X] = find_cost_and_blocking_pairs(res_rank_list,hos_rank_list,hos_caps_list,M)
%f: the cost function of M 
%X: a set of blocking pairs in M
%nbp: the numer of blocking pairs in M
%nsg: the number of singles which are not in blocking pairs
%
n = size(res_rank_list,1);
m = size(hos_rank_list,1);
%
%initalize variables
X = [];
nbp = 0;
nsg = 0;
%
for ri = 1:size(M,2)
    hi = M(ri);
    check_bp = false;
    %
    if (hi > 0)
        rank_ri_hi = res_rank_list(ri,hi);
    else
        rank_ri_hi = n+1;
    end
    %find blocking pairs (ri,hj)
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
                rank_hj_ri = hos_rank_list(hj,ri);
                X(end+1,:) = [ri,hi,rj,hj,rank_hj_ri];
                %increase the number of blocking pairs
                nbp = nbp + 1;
                %find an undominated blocking pair
                check_bp = true;
                break;
            end
        end
    end
    %increase the number of singles which are not in blocking pairs
    if ((check_bp == false) && (hi == 0))
        nsg = nsg + 1;
    end
end
nbp
%cost of matching M
f = nbp + nsg
end
%==========================================================================
function [M] = escape_local_minimum(res_rank_list,M)
%find the positions of single residents
idxr = find(M ==0);
%select a random single resident, ri
i = randi(size(idxr,2),1,1);
ri = idxr(i);
%
%find all hospitals in ri's rank list
idxh = find(res_rank_list(ri,:) > 0);
%make all the hospitals in ri's rank list to be single
for i = 1:size(idxh,2)
    hi = idxh(i);
    %find hospital hi in M
    idxs = find(M == hi);
    for j = 1:size(idxs,2)
        M(j) = 0;
    end
end
end
%==========================================================================