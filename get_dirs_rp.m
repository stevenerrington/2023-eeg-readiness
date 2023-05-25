function dirs = get_dirs_rp(user)

switch user
    case 'mac'
        dirs.root = '/Users/stevenerrington/Desktop/Projects/2023-eeg-readiness';
        dirs.raw_data = '/Volumes/Alpha/data/2012_Cmand_EuX/rawData/';
        
    case 'home'
        dirs.root = 'D:\projects\2023-eeg-readiness\';
        dirs.raw_data = 'D:\data\2012_Cmand_EuX\rawData\';
        
    case 'wustl'
        dirs.root = '';
        dirs.raw_data = '';
        fprintf('!: Directory needs to be setup \n')
        
end

addpath(genpath(dirs.root));

end

