function find_rvlv_batch( inDir )
%FIND_RVLV_BATCH 
%   author: Konrad Werys (konradwerys@gmail.com)

% add folders to path if needed:
addpath(fullfile('..','mrtoolbox'))

% get all dirs in inDir, also subdirs
dirs = get_all_dirs(inDir);
% numeber of dirs:
nDirs=size(dirs,1);
% counter of processed studies
k=0;

tic
% loop to check every dir in inDir
for iDir=1:nDirs
    % get current directory name, get char not cell
    iDirName = cell2mat(dirs(iDir));
    % list of everything in current directory 
    iDirFiles=ls(iDirName);
    % size of iDirFiles
    nFiles=size(iDirFiles,1);
    
    % loop to check everything in iDirName
    for iFile=1:nFiles
        % check if the 'file' has a chosen string in it, for example mrData
        if strfind(iDirFiles(iFile,:),'dcmData')
            try
                % get path to the chosen file and try to load it
                dcmDataPath=fullfile(iDirName,iDirFiles(iFile,:));
                load(dcmDataPath,'-mat')
                
                %%% PROCESSING %%%
                
                [ RV, LV ] = find_rvlv_test( double(dcmData) );

                %%% END OF PROCESSING %%%
                
                % set path to save file with processed data
                myPath=fullfile(iDirName,'rvlvData.mat');
                save(myPath,'dcmData','RV','LV')
                
                cla
                imshow(dcmData(:,:,1,1),[]),hold on,
                plot(RV(2), RV(1),'o');
                plot(LV(2), LV(1),'or');
                pause(.1)
                
                % processed correctly, iterate counter of processed studies
                k=k+1;
            catch ex
                disp(ex.message)
            end

        end
    end

    if k>1 %&& mod(k,floor((size(dirs,1)-(iDir-k))/20))==0
        fprintf(' %2.0f%% Approx. remaining time: %.2f minutes \n',100*k/(size(dirs,1)-(iDir-k)), toc*((size(dirs,1)-(iDir-k))/k-1)/60 )
    end
end

disp(['Time in minutes= ',num2str(toc/60)])
disp([num2str(k),' studies processed'])
end

