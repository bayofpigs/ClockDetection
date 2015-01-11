function showHOG(w)

hogim = HOGpicture(w);
size(hogim)
imagesc(hogim)
axis image
axis off
grid on
drawnow
