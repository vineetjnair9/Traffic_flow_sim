function tolval = delta_fun(iter)
delta_base = 0.1;
if iter > 5
    tolval = delta_base*(0.5^iter);
else
    tolval = delta_base;
end
end

