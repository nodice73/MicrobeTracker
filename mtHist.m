function res = mtHist(data, nbins, plot_type)
    total_cells = sum(data.cellListN);
    
    ints_per_area = [];
    ints_per_vol = [];
    idx = 1;
    for i=1:numel(data.cellList)
        img = data.cellList{i};
        img = img(~cellfun('isempty', img));
        for j=1:numel(img)
            %fprintf('i: %d j: %d\n', i, j);
            total_int = sum(img{j}.signal1);
            ints_per_area{idx} = total_int/img{j}.area;
            ints_per_vol{idx}  = total_int/img{j}.volume;
            idx = idx + 1;
        end
    end
    res.ints_per_area = cell2mat(ints_per_area);
    res.ints_per_vol = cell2mat(ints_per_vol);
    if strcmp(plot_type, 'area')
        val =res.ints_per_area;
    elseif strcmp(plot_type, 'volume')
        val = res.ints_per_vol;
    end

    edges = linspace(min(val), max(val), nbins);
    [counts, edges] = histcounts(val, edges);
    bin_width = edges(2)-edges(1);
    bin_centers = (edges(2:end)+edges(1:(end-1)))./2;
    pdf = counts./(sum(counts)*bin_width);
    
    res.h = plot(bin_centers, pdf);
end