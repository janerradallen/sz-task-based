function mfunc_ActivityMap(vectorList, LocalMinIndex, Name)
% Show activity map

[sy, sx] = size(vectorList);

if (nargin < 3) || isempty(Name)
    %Name = 1:sy;
%Internetwork
    %Name = {'AUD', 'VIS', 'SSM', 'ATN', 'SAN', 'FPN', 'DMN', 'BSL', 'THL'};
    
%FPN
    %Name = {'MFG.L&R-IFJ','MFG.L&R-ventral area 9/46','MFG.L&R-lateral area 10','IFG.L&R-dorsal area 44','IFG.L&R-IFS','IPL.L&R-rostrodorsal area 39','IPL.L&R-rostrodorsal area 40','IPL.L&R-caudal area 40'};    
%DMN    
    %Name = {'SFG','MFG','STG','MTG','PhG','IPL','Pcun','CG'};
%VIS
    Name = {'FuG.L&R-rostroventral area 20','FuG.L&R-mediaventral area 37','FuG.L&R-lateroventral area 37','MVOcC.L&R-cLinG/rLinG','MVOcC.L&R-rCunG/cCunG','MVOcC.L&R-vmPOS','LOcC.L&R-mOccG/iOccG','LOcC.L&R-area V5/MT+','LOcC.L&R-OPC','LOcC.L&R-msOccG/lsOccG'};
%ATN    
    %Name = {'MFG.L-ventrolateral area 6', 'MFG.R-ventrolateral area 6','IFG.L-rostral area 45','IFG.R-rostral area 45','STG.L-area 41/42', 'STG.R-area 41/42','MTG.L-dorsolateral area 37','MTG.R-dorsolateral area 37'};
%AUD    
    %Name = {'STG.L-TE1.0 & TE1.2', 'STG.R-TE1.0 & TE1.2', 'STG.L-caudal area 22', 'STG.R-caudal area 22', 'pSTS.L-rostro','pSTS.R-rostro','pSTS.L-caudo', 'pSTS.R-caudo'};
%SAN
    %Name = {'MFG.L&R-area 46','IFG.L&R-caudal area 45','IFG.L&R-opercular area 44','IFG.L&R-ventral area 44','INS.L&R-vla','INS.L&R-dla','INS.L&R-dlg','CG.L&R-pregenual area 32','CG.L&R-caudodorsal area 24'};
%SSM
    %Name = {'SFG','PrG','PCL','SPL','PoG','CG'};
end

dat = vectorList(:,LocalMinIndex);
dat = [dat, dat(:,end)];
dat = [dat; dat(end,:)];

figure(103);
h = surf(dat);
view([0 90]);
colormap([0.3 0.3 0.3;1 1 1]);
%axis ij
axis square

ax = gca;
set(ax, 'FontSize', 14);

len = length(LocalMinIndex);
set(ax, 'Xtick', (1:len) + 0.5);
set(ax, 'XtickLabel', (1:len));
%set(ax, 'XtickLabel', LocalMinIndex);


set(ax, 'Ytick', (1:sy) + 0.5);
% Fix the Name indexing (2018/08)
set(ax, 'YtickLabel', Name);

axis([1 len+1 1 sy+1]);

title('Activity Patterns', 'FontSize', 16);





