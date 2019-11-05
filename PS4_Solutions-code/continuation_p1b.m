function [q, xs] = continuation_p1b(z, x0)

q = 0.1:0.1:1.0;

for idx = 1:length(q)

    z_it = q(idx)*z;
    z_it(3) = z_it(3) + (1 - q(idx));

    f_it = @(x) fjpoly(x, z_it);

    if idx == 1
        x0_iter(idx) = x0;
    else
        x0_iter(idx) = xs(idx-1);
    end
    xs(idx) = newton1d(f_it,x0_iter(idx),0,'off');

end
