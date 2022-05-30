clear all
warning off
LASTN = maxNumCompThreads(8);



load DatasColor_65.mat
%load MAP2.mat
%scoreLibSVM  è sLBP
NF=size(DATA{3},1); %number of folds
DIV=DATA{3};%divisione fra training e test set
DIM1=DATA{4};%numero di training pattern
DIM2=DATA{5};%numero di pattern
yE=DATA{2};%label dei patterns
NX=DATA{1};%immagini
DA=DATA{4};
ngenres=max(yE);
clear FEAT;
nimages=[163;204;147;170;116;127];

for fold=1:10
    try
        DIM1=DA(fold);
    end
    fprintf("Dati LAB fold %d\n",fold)
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
    
    parfor (img=1:DIM2,8)
        tic;
        FEAT(img,:,fold)=RGBMCD(rgb2lab(single(NX{img})),palette);
        toc;
    end
    
    trainingF=FEAT(trainPattern,:); %training set
    testingF=FEAT(testPattern,:); %test set
    
    sets = {trainingF,testingF};
    
    %                 Mdl = fitcecoc(sets{1},y,'KernelFunction','polynomial');
    %
    %                 yAA=predict(Mdl,sets{1}, 'ObservationsIn', 'rows');
    %                 [presunteLabel,svm_scores]=predict(Mdl,sets{2}, 'ObservationsIn', 'rows');
    %
    %                 scoresSVMnoRed{metodoHAND,fold}=svm_scores;
    
    [scoreLibSVMnoRed{fold}]=PoolSVMnormalizationRID_tesi(sets{1},sets{2},y,yy,1/100);
    %[DecisionValuea,DecisionValueb,scoreLibSVMnoRed{metodoHAND,fold},DecisionValued]=PoolSVMnormalizationGridSearch(sets{1},sets{2},double(y),double(yy));
    
    
end

%%


for fold=1:10
    
    try
        DIM1=DA(fold);
    end
    y=yE(DIV(fold,1:DIM1));%(fold)));%training label
    yy=yE(DIV(fold,DIM1+1:DIM2));%(fold)+1:DIM2));%test label
    
    [a,b]=max((scoreLibSVMnoRed{fold}'));%+scoreLibSVMnoRed{2,fold}'+scoreLibSVMnoRed{3,fold}'))+scoreLibSVMnoRed{280,fold}+scoreLibSVMnoRed{269,fold}+scoreLibSVMnoRed{270,fold}+scoreLibSVMnoRed{271,fold}+scoreLibSVMnoRed{272,fold}+scoreLibSVMnoRed{273,fold}+scoreLibSVMnoRed{276,fold}+scoreLibSVMnoRed{160,fold})');
    Perf=sum(b==yy)./length(yy);
end

acc=mean(Perf);



acc
