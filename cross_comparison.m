%% Summary statistics used for generating Fig. 1J,K of the text

news = [0.8041 0.7821 0.8275 %zipf
    0.6436  0.5243 0.5868 %meplot
    0.7676 0.5249 1.1694 %hill
    ];

kor = [
   0.5742 0.5021 0.6705 %zipf
    0.3388 0.3296 0.3479 %meplot
     0.6464  0.5343  0.7977]; %hill

figure; 
subplot(2,2,1)
bar(news(:,1),'BarWidth', .5);
hold on
errorbar([1:3],news(:,1),news(:,1)-news(:,2),news(:,3)-news(:,1),'k','LineStyle','none')
xticklabels({'Zipf','Meplot','Hill'})
ylabel('$\hat{\xi}$','Interpreter','latex')
box on
title('SSEs with news sources ({\itn} = 74)')

subplot(2,2,2)
bar(kor(:,1),'BarWidth', .5);
hold on
errorbar([1:3],kor(:,1),kor(:,1)-kor(:,2),kor(:,3)-kor(:,1),'k','LineStyle','none')
xticklabels({'Zipf','Meplot','Hill'})
ylabel('$\hat{\xi}$','Interpreter','latex')
box on
title('South Korea ({\itn} = 1,347)')