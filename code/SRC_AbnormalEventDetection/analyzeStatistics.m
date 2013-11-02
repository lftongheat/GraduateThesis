%
%compute the TP FP TN FN and draw the ROC curve
%

%%

tp_num = 0;
fp_num = 0;
tn_num = 0;
fn_num = 0;

%scene1
% for i=401:1449
%     if (i>=501 && i<=613) || (i>=1330 && i<=1440)
%         if abnormalframe(i,1) >0
%             tp_num = tp_num + 1;
%         else
%             fn_num = fn_num +1;
%         end
%     else
%         if abnormalframe(i,1) >0
%             fp_num = fp_num + 1;
%         else
%             tn_num = tn_num +1;
%         end
%     end
% end

%scene2
for i=311:(4140)
    if (i>=1784-1454 && i<=1950-1454) || (i>=2599-1454 && i<=2660-1454)...
            || (i>=3189-1454 && i<=3290-1454) || (i>=3926-1454 && i<=3986-1454)...
            || (i>=4770-1454 && i<=4890-1454) || (i>=5395-1454 && i<=5495-1454)
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

%scene3
% for i=401:7738-5599
%     if (i>=6140-5599 && i<=6200-5599) || (i>=6870-5599 && i<=6900-5599) || (i>=7640-5599 && i<=7670-5599)
%         if abnormalframe(i,1) >0
%             tp_num = tp_num + 1;
%         else
%             fn_num = fn_num +1;
%         end
%     else
%         if abnormalframe(i,1) >0
%             fp_num = fp_num + 1;
%         else
%             tn_num = tn_num +1;
%         end
%     end
% end

tpr = tp_num/(tp_num + fn_num);
fpr = fp_num/(fp_num + tn_num);
acc = (tp_num+tn_num)/(tp_num+fp_num+tn_num+fn_num);
disp(['tpr:',num2str(tpr),' fpr:',num2str(fpr),' acc:',num2str(acc)]);

