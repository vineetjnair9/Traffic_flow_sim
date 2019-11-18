function y = get_peak_mem(p, name)

  N = length(p.FunctionTable);
  for i = 1:N
    if strcmp(p.FunctionTable(i).FunctionName, name)
      y = p.FunctionTable(i).PeakMem / 2^10;  % conversion factor of 2^10 to convert b to KiB
      return
    end
  end
  fprintf('Function name ''%s'' not found!\n',name)

end
