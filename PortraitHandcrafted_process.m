clear all;
warning off



load DatasColor_65TVT.mat
%load MAP2.mat
%scoreLibSVM  è sLBP
NF=size(DATA{3},1); %number of folds
DIV=DATA{3};%divisione fra training e test set
DIM1=DATA{4};%numero di training pattern
DIM2=DATA{5};%numero di pattern
yE=DATA{2};%label dei patterns
NX=DATA{1};%immagini
DA=DATA{4};
TOT=DATA{6};
ngenres=max(yE);

% a=zeros(1,768);
% b=zeros(1,768);
% c=zeros(1,256);


nimages=zeros(max(yE),1);
clear FV1;
clear FV2;
clear FV3;
clear FV4;
clear FV5;
clear FV6;
clear FV7;
clear FV8;
clear FV9;
clear FV10;
clear FV11;
for i=1:DIM2
    nimages(yE(i),1)=nimages(yE(i),1)+1;
end
%load Starting2.mat
for metodoHAND=5:5
    clear FEAT;
    conf=config_gist();
    tic;
    for img=1:length(NX)
        %RGB color ratio
        if metodoHAND==1
            FV1(img,:) = RGBprocess(single(NX{img}),1);
            
            %HSV color ratio
        elseif metodoHAND==2
            FV2(img,:) = HSVprocess(single(NX{img}),1);
            
            %Weber's law based EME feature
        elseif metodoHAND==3
            FV3(img,:)= emeProcess(NX{img},1);
        elseif metodoHAND==4
            FV4(img,:)= HSVprocess(NX{img},2);
        elseif metodoHAND==5
            FV5(img,:)= RGBprocess(NX{img},2);
            
            
        elseif metodoHAND==8
            FV8(img,:)=extract_gist(single(NX{img}));
        elseif metodoHAND==9
            FV9(img,:)=orgLBP(single(NX{img}),3,8,0,'h');
        elseif metodoHAND==10
            FV10(img,:)= emeProcess(NX{img},2);    
        end
        
    end
    if metodoHAND==6
        %MetodoHAND 6: RGB-MCD
        for fold=1:10
            try
                DIM1=DA(fold);
            end
            fprintf("Dati RGBMCD fold %d\n",fold)
            trainPattern=(DIV(fold,1:DIM1));
            testPattern=(DIV(fold,DIM1+1:DIM2));
            y=yE(DIV(fold,1:DIM1));%(fold)));%training label
            yy=yE(DIV(fold,DIM1+1:DIM2));%(fold)+1:DIM2));%test label
            
            %This methods needs to operate only on the training set to
            %realize a color palette
            tic;
            %Create Feature vectors for MCD method(RGB version)
            Fog=zeros(1800,3,ngenres);
            %Extract n representative colors from each training image
            for img=1:DIM1
                Fog(1:8*nimages(yE(trainPattern(img))),:,yE(trainPattern(img)))=cat(1,Fog(1:8*(nimages(yE(trainPattern(img)))-1),:,yE(trainPattern(img))),imageRaprColors(single(NX{trainPattern(img)})));
            end
            toc;
            %Create a 16 colors palette for each genere (96 colors in total)
            palette=zeros(16*ngenres,3);
            for i=1:ngenres
                [index,palette(16*(i-1)+1:16*i,:)]=kmeans(Fog(:,:,i),16);
            end
            
            %Merge with existent feature vectors
            tic;
            parfor img=1:DIM2
                FV6(img,:,fold)=RGBMCD(single(NX{img}),palette);
            end
            toc;
            
            
        end
    end
    
   if metodoHAND==11
        %MetodoHAND 10: LAB-MCD
        for fold=1:10
            try
                DIM1=DA(fold);
            end
            fprintf("Dati LABMCD fold %d\n",fold)
            trainPattern=(DIV(fold,1:DIM1));
            testPattern=(DIV(fold,DIM1+1:DIM2));
            y=yE(DIV(fold,1:DIM1));%(fold)));%training label
            yy=yE(DIV(fold,DIM1+1:DIM2));%(fold)+1:DIM2));%test label
            
            %This methods needs to operate only on the training set to
            %realize a color palette
            tic;
            %Create Feature vectors for MCD method(RGB version)
            Fog=zeros(1800,3,ngenres);
            %Extract n representative colors from each training image
            for img=1:DIM1
                Fog(1:8*nimages(yE(trainPattern(img))),:,yE(trainPattern(img)))=cat(1,Fog(1:8*(nimages(yE(trainPattern(img)))-1),:,yE(trainPattern(img))),imageRaprColors(rgb2lab(single(NX{trainPattern(img)}))));
            end
            toc;
            %Create a 16 colors palette for each genere (96 colors in total)
            palette=zeros(16*ngenres,3);
            for i=1:ngenres
                [index,palette(16*(i-1)+1:16*i,:)]=kmeans(Fog(:,:,i),16);
            end
            
            %Merge with existent feature vectors
            tic;
            parfor img=1:TOT
                FV11(img,:,fold)=RGBMCD(rgb2lab(single(NX{img})),palette);
            end
            toc;
            
            
        end
    end
    fprintf("Time to get the full feature vectors set:");
    toc;
    
end



%%
%%k=[0.002,0.00096,0.00028,0.00019,0.04,1.8,0.00001,0.00008,0.004,0.0001,1.4];
clear acc;
for k=71:80
    k
Perf=zeros(6,10);
for metodoHAND=5:5
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
        tmp1=cat(2,FV3(:,:),FV8(:,:));
        tmp2=cat(2,tmp1(:,:),FV6(:,:,fold));
        FEAT=cat(2,tmp2(:,:),FV2(:,:));
        elseif metodoHAND==8
            FEAT=FV8(:,:);
        elseif metodoHAND==9
            FEAT=FV9(:,:);
        elseif metodoHAND==10
            FEAT=FV10(:,:);
        elseif metodoHAND==11
            FEAT=FV11(:,:,fold);
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
         
        [scoreLibSVMnoRed{metodoHAND,fold} ]=PoolSVMnormalizationRID_tesi(sets{1},sets{2},y,yy,k/1000000);
        %[DecisionValuea,DecisionValueb,scoreLibSVMnoRed{metodoHAND,fold},DecisionValued]=PoolSVMnormalizationGridSearch(sets{1},sets{2},double(y),double(yy));
        
    end
end   
    %


    
    
  
 for metodoHAND=5:5
    for fold=1:10
        
        try
            DIM1=DA(fold);
        end
        y=yE(DIV(fold,1:DIM1));%(fold)));%training label
        yy=yE(DIV(fold,DIM1+1:DIM2));%(fold)+1:DIM2));%test label
        
        [a,b]=max((scoreLibSVMnoRed{metodoHAND,fold}'));%+scoreLibSVMnoRed{2,fold}'+scoreLibSVMnoRed{3,fold}'))+scoreLibSVMnoRed{280,fold}+scoreLibSVMnoRed{269,fold}+scoreLibSVMnoRed{270,fold}+scoreLibSVMnoRed{271,fold}+scoreLibSVMnoRed{272,fold}+scoreLibSVMnoRed{273,fold}+scoreLibSVMnoRed{276,fold}+scoreLibSVMnoRed{160,fold})');
        Perf(metodoHAND,fold)=sum(b==yy)./length(yy);
    end
    
    acc(k)=mean(Perf(metodoHAND,:));

 end

end

acc
