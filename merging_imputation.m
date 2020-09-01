%% Tests for robustness to data merging and imputation, for Fig. 1I

for K = 1:100
res=[];
resb=[];
im_res = [];
im_resb = [];

for II=1:100
    ev = [];
    mean_im = [];
    rand_merg = floor(12*rand); % Number of samples to merge or impute
    for i = 1:60 % 60 samples in reference dataset
        XX = 1./wblrnd(0.7,1.7,30,1);
        mean_im(i) = max(XX(1+rand_merg:end)); % Mean/median imputation is equivalent to taking max of remaining samples
        XX = XX + vertcat(1./wblrnd(0.7,1.7,rand_merg,1),zeros(30-rand_merg,1));
        ev(i) = max(XX);
    end
    [h p]= kstest2(x,ev);
    res(II,:) = [h p];
    [h p]= kstest2(x,mean_im);
    im_res(II,:) = [h p];
    
    evb=[];
    mean_im_2 = [];
    rand_merg = floor(4000*rand);
    R0 = 6*rand;
    k = 1*rand;
    for i = 1:60
        nbinomial = nbinrnd(k,(1+R0/k)^(-1),10000,1);
        mean_im_2(i) = max(nbinomial(1+rand_merg:end)); 
        nbinomial = nbinomial + vertcat(nbinrnd(k,(1+R0/k)^(-1),rand_merg,1),zeros(10000-rand_merg,1));
        evb(i) = max(nbinomial);
    end
    [h p] = kstest2(x,evb);
    resb(II,:) = [h p];
    [h p] = kstest2(x,mean_im_2);
    im_resb(II,:) = [h p];
end

RESULTS(K,:) = [mean(res(:,1)) mean(resb(:,1)) mean(im_res(:,1)) mean(im_resb(:,1))];
end

cis = [bootci(1000,@mean,RESULTS(:,1)) bootci(1000,@mean,RESULTS(:,2)) bootci(1000,@mean,RESULTS(:,3)) bootci(1000,@mean,RESULTS(:,4))];

figure; 
subplot(2,2,1)
hold on
xx = mean(RESULTS,1);
bar(xx,'BarWidth',0.5)
errorbar([1:4],xx,xx-cis(1,:),cis(2,:)-xx,'k','LineStyle','none')
box on
ylabel('Fraction of samples rejected')