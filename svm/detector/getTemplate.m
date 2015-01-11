function [pEx,sizeT] = getTemplate( feature, bb)
% get feature image
bbh=bb(4)-bb(2);
bbw=bb(3)-bb(1);
pscale=(8000/(bbh*bbw))^0.5;
[~,level]=findnearest(pscale,feature.scale);
rscale=feature.scale(level);

%get positive example
template_level = level;
F=feature.feat{template_level};
[fh fw fz]=size(F);
template_width = round(bbw*rscale/8)+1;
template_height= round(bbh*rscale/8)+1;
template_left  = max(1,floor(bb(1)*rscale/8)+1);
template_top  = max(1,floor(bb(2)*rscale/8)+1);
pEx = feature.feat{template_level}(template_top:min(size(feature.feat{template_level},1),(template_top+template_height-1)),...
                                   template_left:min(size(feature.feat{template_level},2),(template_left+template_width-1)),:);
sizeT=size(pEx);
pEx=pEx(:);


end

function out = randvalues(in,k)
% Randomly selects 'k' values from vector 'in'.

out = [];

N = size(in,2);

if k == 0
  return;
end

if k > N
  k = N;
end

if k/N < 0.0001
 i1 = unique(ceil(N*rand(1,k)));
 out = in(:,i1);
 
else
 i2 = randperm(N);
 out = in(:,sort(i2(1:k)));
end
end
function [y,ind]=findnearest(x,array)
if isempty (array), y=-99999;return ; end
mind=999999;
n=0;
for i=1:length(array)
    d=abs(x-array(i));
    if d<mind,
        mind=d;
        n=i;
    end
end
y=array(n);
ind=n;
end