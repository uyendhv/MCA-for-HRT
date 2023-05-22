function main
clc
clear vars
clear all
close all
%run algorithms
alg = 1;
%number of instances has the same (n,m,p1,p2)
k = 10; 
for n = 1000
    for m = 100
        for p1 = 0.5 %0.1:0.1:0.8
            for p2 = 0.5 %0.0:0.1:1.0 
                f_results= [];
                i = 1;
                while (i <= k)
                    %load the preference matrices and the matching from file
                    filename = ['tests\I(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                    load(filename,'res_rank_list','hos_rank_list','hos_caps_list','M');
                    %run algorithms
                    if (alg == 1)                    
                        [f_time,f_cost,f_stable,f_iter,f_reset] = MCA(res_rank_list,hos_rank_list,hos_caps_list,M);
                    end
                    if (alg == 2)
                        %[f_time,f_cost,f_stable,f_iter,f_reset] = LTIU(res_rank_list,hos_rank_list,hos_caps_list,M);
                    end
                    %
                    f_results = [f_results; f_time,f_cost,f_stable,f_iter,f_reset];
                    %
                    fprintf('\nI(%d,%d,%0.1f,%0.1f)-%d: time = %3.3f, f(M)=%d, stable=%d, iters=%d, reset=%d',n,m,p1,p2,i,f_time,f_cost,f_stable,f_iter,f_reset);
                    %
                    i = i + 1;
                end
                %
                %save to file for averaging results
                if (alg == 1)
                    %filename2 = ['output3\MCA(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
                    %save(filename2,'f_results');
                end
                if (alg == 2)
                    %filename2 = ['output1\LTIU(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
                    %save(filename2,'f_results');
                end
            end
        end
    end
end
end
%==========================================================================