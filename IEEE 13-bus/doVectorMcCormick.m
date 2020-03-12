


w(:)>=xMin(:).*y(:)+x(:)*yMin(:)-xMin(:).*yMin(:);
w(:)>=xMax(:).*y(:)+x(:).*yMax(:)-xMax(:).*yMax(:);
w(:)<=xMax(:).*y(:)+x(:).*yMin(:)-xMax(:).*yMin(:);
w(:)<=x(:).*yMax(:)+xMin(:).*y(:)-xMin(:).*yMax(:);