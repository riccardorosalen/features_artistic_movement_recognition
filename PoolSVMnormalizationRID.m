%TR training set, TE test set, yTR training label, yy test label
function [PreLabel,Score]=PoolSVMnormalizationRID(TR,TE,yTR,yy,boxConstraint)

%normalization between [0,1]
massimo=max(TR)+0.00001;
minimo=min(TR);
training=[];
testing=[];
for i=1:size(TR,2)
    training(1:size(TR,1),i)=double(TR(1:size(TR,1),i)-minimo(i))/(massimo(i)-minimo(i));
end
for i=1:size(TE,2)
    testing(1:size(TE,1),i)=double(TE(1:size(TE,1),i)-minimo(i))/(massimo(i)-minimo(i));
end
tra=[];
TR=training;
TE=testing;

%cd .\dataset\orgImg\

for i=1:max(yTR)
    
%     y(find(yTR==i))=1;
%     y(find(yTR~=i))=2;
%     
%     if ~isrow(y)
%         y=y';
%     end
%     if ~isrow(yy)
%         yy=yy';
%     end
    
    model = fitcsvm(TR,yTR,'KernelFunction','polynomial','BoxConstraint',6/1500);
    [PreLabel, Score] = predict(model,TE);
    %DecisionValuec(:,i)=CheckScoresSVM(Decision,PreLabel);
    %DecisionValuec(find(isnan(DecisionValuec)))=0;
    
    
    %if max(yTR)==2
        %DecisionValuec(:,2)=DecisionValuec(:,1)*-1;
        %break;
    %end
    
    
end