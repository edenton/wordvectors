clf;clear;load('proj_3d_pairs.mat')
for t=1:size(idx_values,1)
    col(t)=1;
    size_pt(t)=10;
    for i=1:max(size(indices))
    	if sum(idx_values(t,1) == indices{i}(:,1) & idx_values(t,2) == indices{i}(:,2))
    		col(t)=2;
            size_pt(t)=45;
    	end
    end
end
scatter3(proj_all(:,1),proj_all(:,2),proj_all(:,3),size_pt,col,'filled');