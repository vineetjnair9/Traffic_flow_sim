function visualizeResults(t,X,n,plottype);

% copyright Luca Daniel, MIT 2018


   subplot(2,1,1)
   %figure(1)
   plot(t(n),X(:,n),plottype); 
   hold on
   xlabel('time')
   subplot(2,1,2)
   %figure(2)
   plot(X(:,n),plottype);
   minX=min(min(X));
   maxX=max(max(X));
   if maxX==minX
      if maxX==0
         minX=-1;
         maxX=1;
      else
         minX=min(minX*0.9,minX*1.1);
         maxX=max(minX*0.9,minX*1.1);
      end
   end
   maxh=size(X,1);
   if maxh==1,
      maxh=2;
   end
   axis([1 maxh minX maxX])
   xlabel('state components')
   drawnow
   %pause(1); 