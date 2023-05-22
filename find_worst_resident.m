function [rw] = find_worst_resident(hos_rank_list,hj,cj,M)
%find the worst resident, rw, assigned to hj in M
%cj - capacity of hj
%
if (sum(M == hj) >= cj)
    idxs = find(M == hj);
    rank_hj_ri = zeros(1,size(idxs,2));
    for i = 1:size(idxs,2)
        ri = idxs(i);
        rank_hj_ri(i) = hos_rank_list(hj,ri);
    end
    [~,idx] = max(rank_hj_ri);
    rw = idxs(idx);
else
    rw = 0;
end
end
%==========================================================================