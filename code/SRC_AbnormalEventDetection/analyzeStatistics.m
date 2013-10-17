%
%compute the TP FP TN FN and draw the ROC curve
%

%%
%vedio 1  samples_num = 1049 
%postive_sample = 481:615   1291:1440

% outputs = zeros(1,1049);
% targets = zeros(1,1049);
% targets(1,81:214) = 1;
% targets(1,791:1040) = 1;
% for i=401:1449
%     if abnormalframe(i,1) >0
%         outputs(1,i-400) = 1;
%     end
% end
% plotroc(targets, outputs);

tp_num = 0;
fp_num = 0;
tn_num = 0;
fn_num = 0;

for i=401:1449
    if (i>=481 && i<=615) || (i>=1291 && i<=1440)
        if abnormalframe(i,1) >0
            tp_num = tp_num + 1;
        else
            fn_num = fn_num +1;
        end
    else
        if abnormalframe(i,1) >0
            fp_num = fp_num + 1;
        else
            tn_num = tn_num +1;
        end
    end
end

tpr = tp_num/(tp_num + fn_num);
fpr = fp_num/(fp_num + tn_num);
disp(['tpr:',num2str(tpr),' fpr:',num2str(fpr)]);

