function plot_newton1d(x,fg,iters,ndx,xrange,frange,itpause)
% plot_newton1d(x,fg,iters,ndx,xrange,frange,itpause)
%
% Plot each step of Newton algorithm, pausing
% for the first itpause steps
%
% Also plot convergence of |f(xk)|, xk, dxk

figure(1);
plot(xrange,frange); grid on; hold on;
for it = 1:length(x)-1
    if it < itpause
    title('Hit Enter to Show Next Step');
    end
    if it < itpause, pause; end
    plot(x(it),0,'k*');
    if it < itpause, pause; end
    plot([x(it),x(it)],[fg(it),0],'r');
    plot(x(it),fg(it),'r*');
    if it < itpause, pause; end
    plot([x(it),x(it+1)],[fg(it),0],'r');
end

figure(2);
subplot(2,2,1); plot(xrange,frange,x,fg,'r*'); grid on;
xlabel('x'); ylabel('f(x)');
subplot(2,2,2); semilogy([0,iters],abs(fg),'*-'); grid on;
xlabel('iteration #'); ylabel('|f(x)|');
subplot(2,2,3); plot([0,iters],x,'k*-');
xlabel('iteration #'); ylabel('x');
subplot(2,2,4); semilogy(iters,ndx,'*-');
% subplot(2,2,4); loglog(iters(1:end-1),ndx,'*-');
xlabel('iteration #'); ylabel('||dx||');
