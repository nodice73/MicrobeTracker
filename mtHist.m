function res = mtHist(data, nbins, plot_type)
    total_cells = sum(data.cellListN);
    
    total_int = [];
    area = [];
    volume = [];
    ints_per_area = [];
    ints_per_vol = [];
    idx = 1;
    for i=1:numel(data.cellList)
        img = data.cellList{i};
        img = img(~cellfun('isempty', img));
        for j=1:numel(img)
            %fprintf('i: %d j: %d\n', i, j);
            total_int{idx} = sum(img{j}.signal1);
            area{idx} = img{j}.area;
            volume{idx} = img{j}.volume;
            ints_per_area{idx} = total_int{idx}/img{j}.area;
            ints_per_vol{idx}  = total_int{idx}/img{j}.volume;
            idx = idx + 1;
        end
    end
    res.total_int = cell2mat(total_int);
    res.area = cell2mat(area);
    res.volume = cell2mat(volume);
    res.ints_per_area = cell2mat(ints_per_area);
    res.ints_per_vol = cell2mat(ints_per_vol);
    if strcmp(plot_type, 'area')
        val =res.ints_per_area;
    elseif strcmp(plot_type, 'volume')
        val = res.ints_per_vol;
    elseif strcmp(plot_type, 'total')
        val = res.total_int;
    end

    edges = linspace(min(val), max(val), nbins);
    [counts, edges] = histcounts(val, edges);
    bin_width = edges(2)-edges(1);
    bin_centers = (edges(2:end)+edges(1:(end-1)))./2;
    pdf = counts./(sum(counts)*bin_width);
    
    res.h = plot(bin_centers, pdf);
end