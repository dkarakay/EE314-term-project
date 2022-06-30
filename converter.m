clc
%read the image
I = imread('pie.png');	
imshow(I);
		
%Extract RED, GREEN and BLUE components from the image
R = I(:,:,1);			
G = I(:,:,2);
B = I(:,:,3);

%make the numbers to be of double format for 
R = double(R);	
G = double(G);
B = double(B);

% %Raise each member of the component by appropriate value. 
% R = R.^(3/8); % 8 bits -> 3 bits
% G = G.^(3/8); % 8 bits -> 3 bits
% B = B.^(1/4); % 8 bits -> 2 bits
% 
% %tranlate to integer
% R = uint8(R); % float -> uint8
% G = uint8(G);
% B = uint8(B);
% 
% %minus one cause sometimes conversion to integers rounds up the numbers wrongly
% R = R-1; % 3 bits -> max value is 111 (bin) -> 7 (dec)(hex)
% G = G-1;
% B = B-1; % 11 (bin) -> 3 (dec)(hex)

%save variable COLOR to a file in HEX format for the chip to read
fileID = fopen ('pieg.txt', 'w');
for i = 1:size(G(:), 1)-1
    fprintf (fileID, '%x\n', G(i)); % COLOR (dec) -> print to file (hex)
end
fprintf (fileID, '%x', G(size(G(:), 1))); % COLOR (dec) -> print to file (hex)
fclose (fileID);

%save variable COLOR to a file in HEX format for the chip to read
fileID = fopen ('pieb.txt', 'w');
for i = 1:size(B(:), 1)-1
    fprintf (fileID, '%x\n', B(i)); % COLOR (dec) -> print to file (hex)
end
fprintf (fileID, '%x', B(size(B(:), 1))); % COLOR (dec) -> print to file (hex)
fclose (fileID);

%save variable COLOR to a file in HEX format for the chip to read
fileID = fopen ('pier.txt', 'w');
for i = 1:size(R(:), 1)-1
    fprintf (fileID, '%x\n', R(i)); % COLOR (dec) -> print to file (hex)
end
fprintf (fileID, '%x', R(size(R(:), 1))); % COLOR (dec) -> print to file (hex)
fclose (fileID);