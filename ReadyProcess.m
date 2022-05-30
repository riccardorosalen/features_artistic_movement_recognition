clear all;
warning off;



% load DatasColor_65.mat
% %load MAP2.mat
% %scoreLibSVM  è sLBP    
% NF=size(DATA{3},1); %number of folds
% DIV=DATA{3};%divisione fra training e test set
% DIM1=DATA{4};%numero di training pattern
% DIM2=DATA{5};%numero di pattern
% yE=DATA{2};%label dei patterns
% NX=DATA{1};%immagini
% DA=DATA{4};
% ngenres=max(yE);

load Starting.mat


%k=[6/2000,6/1500,28/100000,6/1500,6/2000,1/10000,6/1500,6/1000,8/100000,1/100];
% 
%    for k=1:100
Perf=zeros(6,10);
for metodoHAND=1:10
    clear FEAT;
    for fold=1:10
        try
            DIM1=DA(fold);
        end
        
        trainPattern=(DIV(fold,1:DIM1));
        testPattern=(DIV(fold,DIM1+1:DIM2));
        y=yE(DIV(fold,1:DIM1));%(fold)));%training label
        yy=yE(DIV(fold,DIM1+1:DIM2));%(fold)+1:DIM2));%test label
        
        if metodoHAND==1
            FEAT=FV1(:,:);
        elseif metodoHAND==2
            FEAT=FV2(:,:);
        elseif metodoHAND==3
            FEAT=FV3(:,:);
        elseif metodoHAND==4
            FEAT=FV4(:,:);
        elseif metodoHAND==5
            FEAT=FV5(:,:);
        elseif metodoHAND==6
            FEAT=FV6(:,:,fold);
        elseif metodoHAND==7
%             tmp1=cat(2,FV2(:,:),FV3(:,:));
% %             tmp2=cat(2,tmp1(:,:),FV4(:,:));
%             tmp3=cat(2,tmp1(:,:),FV5(:,:));
%             tmp4=cat(2,tmp3(:,:),double(FV8(:,:)));
%             %tmp5=cat(2,tmp4(:,:),FV10(:,:));
%             tmp5=cat(2,tmp4(:,:),FV6(:,:,fold));
%             FEAT=cat(2,tmp5(:,:),FV10(:,:));
        tmp1=cat(2,FV10(:,:),double(FV8(:,:)));
        tmp2=cat(2,tmp1(:,:),FV6(:,:,fold));
        tmp3=cat(2,tmp2(:,:),FV11(:,:,fold));
        tmp4=cat(2,tmp3(:,:),FV3(:,:));
        tmp5=cat(2,tmp4(:,:),FV5(:,:));
        tmp6=cat(2,tmp5(:,:),FV1(:,:));
        tmp7=cat(2,tmp6(:,:),FV9(:,:));
        tmp8=cat(2,tmp7(:,:),FV2(:,:));
        FEAT=cat(2,tmp8(:,:),FV4(:,:));
        elseif metodoHAND==8
            FEAT=FV8(:,:);
        elseif metodoHAND==9
            FEAT=FV9(:,:);
        elseif metodoHAND==10
            FEAT=FV10(:,:);
        elseif metodoHAND==11
            FEAT=FV11(:,:,fold);
        end
        
        for i=1:5
            for j=i+1:6
                
            end
        end
        
        
        trainingF=FEAT(trainPattern,:); %training set
        testingF=FEAT(testPattern,:); %test set        
        y=yE(DIV(fold,1:DIM1));%(fold)));%training label
        yy=yE(DIV(fold,DIM1+1:DIM2));%(fold)+1:DIM2));%test label
        sets = {trainingF,testingF};
        
        %                 Mdl = fitcecoc(sets{1},y,'KernelFunction','polynomial');
        %
        %                 yAA=predict(Mdl,sets{1}, 'ObservationsIn', 'rows');
        %                 [presunteLabel,svm_scores]=predict(Mdl,sets{2}, 'ObservationsIn', 'rows');
        %
        %                 scoresSVMnoRed{metodoHAND,fold}=svm_scores;
        
        [scoreLibSVMnoRed{metodoHAND,fold} ]=PoolSVMnormalizationRID_tesi(sets{1},sets{2},y,yy,1/10000);
        %[DecisionValuea,DecisionValueb,scoreLibSVMnoRed{metodoHAND,fold},DecisionValued]=PoolSVMnormalizationGridSearch(sets{1},sets{2},double(y),double(yy));
        
    end
end   
    %


    
    
  
 for metodoHAND=7:7
    for fold=1:10
        
        try
            DIM1=DA(fold);
        end
        y=yE(DIV(fold,1:DIM1));%(fold)));%training label
        yy=yE(DIV(fold,DIM1+1:DIM2));%(fold)+1:DIM2));%test label
        
        [a,b]=max((scoreLibSVMnoRed{metodoHAND,fold}'));%+scoreLibSVMnoRed{2,fold}'+scoreLibSVMnoRed{3,fold}'))+scoreLibSVMnoRed{280,fold}+scoreLibSVMnoRed{269,fold}+scoreLibSVMnoRed{270,fold}+scoreLibSVMnoRed{271,fold}+scoreLibSVMnoRed{272,fold}+scoreLibSVMnoRed{273,fold}+scoreLibSVMnoRed{276,fold}+scoreLibSVMnoRed{160,fold})');
        Perf(metodoHAND,fold)=sum(b==yy)./length(yy);
    end
    
    acc=mean(Perf(metodoHAND,:));

 end

   %end

acc