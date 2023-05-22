function [M] = make_random_matching(res_rank_list,hos_rank_list,hos_caps_list)
%create a random matching M in which r and h find each other acceptable
%
n = size(res_rank_list,1);
m = size(hos_rank_list,1);
M = randi([0,m],1,n);
%
for ri = 1:n
    hi = M(ri);
    if (hi ~=0)
        rank_ri_hi = res_rank_list(ri,hi);
        rank_hi_ri = hos_rank_list(hi,ri);
        if (rank_ri_hi == 0) || (rank_hi_ri == 0)
            M(ri) = 0;
        end
        if (sum(M ==hi) >= hos_caps_list(hi))
            M(ri) = 0;
        end
    end
end
%check if M = zeros
%if (~any(M))
%    M = make_random_matching(res_rank_list,hos_rank_list,hos_caps_list);
%end
end
%==========================================================================