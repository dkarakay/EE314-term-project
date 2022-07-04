%read the image
name = 'droppedYellow';
file_name = append(name,'.jpeg')
output = append(name,'.txt')

I = imread(file_name);
size(I)
I = imresize(I,[40,80]);
size(I)

%Extract RED, GREEN and BLUE components from the image
R = I(:,:,1);			
G = I(:,:,2);
B = I(:,:,3);

%make the numbers to be of double format for 
R = double(R);	
G = double(G);
B = double(B);


size(R,1)*size(R,2)

%Raise each member of the component by appropriate value. 
R = R.^(3/8); % 8 bits -> 3 bits
G = G.^(3/8); % 8 bits -> 3 bits
B = B.^(1/4); % 8 bits -> 2 bits

%tranlate to integer
R = uint8(R); % float -> uint8
G = uint8(G);
B = uint8(B);

%minus one cause sometimes conversion to integers rounds up the numbers wrongly
R = R-1; % 3 bits -> max value is 111 (bin) -> 7 (dec)(hex)
G = G-1;
B = B-1; % 11 (bin) -> 3 (dec)(hex)

%shift bits and construct one Byte from 3 + 3 + 2 bits
G = bitshift(G, 3); % 3 << G (shift by 3 bits)
B = bitshift(B, 6); % 6 << B (shift by 6 bits)
COLOR = R+G+B;      % R + 3 << G + 6 << B

%save variable COLOR to a file in HEX format for the chip to read
fileID = fopen (output, 'w');
for i = 1:size(COLOR(:), 1)-1
    fprintf (fileID, '%x\n', COLOR(i)); % COLOR (dec) -> print to file (hex)
end
fprintf (fileID, '%x', COLOR(size(COLOR(:), 1))); % COLOR (dec) -> print to file (hex)
%save variable COLOR to a file in HEX format for the chip to read
%fileID = fopen ('Mickey.list', 'w');
%fprintf (fileID, '%x\n', COLOR); % COLOR (dec) -> print to file (hex)
fclose (fileID);

%translate to hex to see how many lines
COLOR_HEX = dec2hex(COLOR);
