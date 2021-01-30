% ENSC180-Assignment3

% Student Name 1: Harpreet

% Student 1 #: 30124364

% Student 1 userid (email): hhoonjan@sfu.ca (stu1@sfu.ca)

% Student Name 2: Armaan Bandali

% Student 2 #: 301322810

% Student 2 userid (email): abandali@sfu.ca(stu2@sfu.ca)

% Below, edit to list any people who helped you with the assignment, 
%      or put ‘none’ if nobody helped (the two of) you.

% Helpers: _everybody helped us/me with the assignment (list names or put ‘none’)__

% Instructions:
% * Put your name(s), student number(s), userid(s) in the above section.
% * Edit the "Helpers" line.  
% * Your group name should be "A3_<userid1>_<userid2>" (eg. A3_stu1_stu2)
% * Form a group 
%   as described at:  https://courses.cs.sfu.ca/docs/students
% * You will submit THIS file (assignment3_2017.m),    
%   and your video file (assignment3.avi or possibly similar).
% Craig Scratchley, Spring 2017

function frameArray = assignment3_2017
%theta=0;
MAX_FRAMES = 1200; 
RESOLUTION = 720; 
DURATION = 40; 


MAX_DEPTH = 10000; 
CMAP0=colormap(flipud(gray(MAX_DEPTH)));
CMAP1=colormap(flipud(jet(MAX_DEPTH)));
CMAP2=colormap(flipud(winter(MAX_DEPTH))); 
CMAP3=colormap(flipud(parula(MAX_DEPTH))); 
CMAP4=colormap(flipud(cool(MAX_DEPTH)));
CMAP5=colormap(flipud(flag(MAX_DEPTH)));

WRITE_VIDEO_TO_FILE = true; 
DO_IN_PARALLEL = true; 

if DO_IN_PARALLEL
    startClusterIfNeeded
end

if WRITE_VIDEO_TO_FILE
    openVideoFile
end

if DO_IN_PARALLEL || ~WRITE_VIDEO_TO_FILE 
    %preallocate struct array
    %frameArray=struct('cdata',cell(1,MAX_FRAMES),'colormap',cell(1,MAX_FRAMES));
    %%%%%%%%%LOOK INTO THIS FOR ROTATION POSSIBLY%%%%%%%%%%%
end

%ASSUMING MAX INDEX IS 1000
%           index  centre      number of times to zoom in by 2
PATH_POINTS = [0,      0,                      10E-12;
              5,       -1.4003322346975-0.0000518798833787i,           1/2100;   %zoomed in mandelbrot    zoom 1;
              50,      -1.40187988281+0.000732421875i,                 1/256;   %zoom out to next mandelbrot zoom 2<zoom 1;
              75,      -1.30999023425+0.0032714843125i,                1/17;   %see above; zoom 3<zoom 2
              125,      0+0.5i,                                        1;   %zoom out to overall mandelbrot set; zoom5=2
              175,     -1.7497591451303665-0.0000000036851380i,        1.0E-5;   %pan over to first interesting point while maintaining zoom5;
              225,      -1.7497591451303665-0.0000000036851380i,       1.0E-9;  %index dif of 150 ensures slower zoom into interesting point 1;
              325,      -1.7497591451303665-0.0000000036851380i,       1.0E-12;  %zoom out back to zoom 5=2;
              475,      0+0.5i,                                        1;
              515,     -0.7474609375-0.083203125i,                     1/32;  
              625,     -0.752673339843-0.0412109375i,                  1/512; %zoom into int point 2;
              725,     -0.76251907348651-0.089530944824224i,          1/8192; %zoom out to zoom 5=2;
              800,     -0.7525678634635965-0.04090251922607425i,       1/57825.882;%pan to last int point at zoom5=2;
              850,     -0.752567668407396655-0.0409032656749349025i,   1/7401712.8; %zoom into last int point;
              1000,    -0.7625584044961188295-0.0895524575840728661i,  1.3421773E-8;]%zoom back out to zoom5=2;


SIZE_0 = 1.5; % the "size" from the centre of a frame with no zooming.

% scale indeces to number of frames.
scaledIndexArray = PATH_POINTS(:, 1).*((MAX_FRAMES-1)/PATH_POINTS(end, 1));
%%%%%%%%%THE SCALED INDEX ARRAY IS JUST INDEX/(MAX
%%%%%%%%%INDEX)=NUMFRAMES/(MAXFRAMES-1)

% interpolate centres and zoom levels.
interpArray = interp1(scaledIndexArray, PATH_POINTS(:, 2:end), 0:(MAX_FRAMES-1), 'pchip');

zoomArray = interpArray(:,2); % zoom level of each frame

% ***** modify the below line to consider zoom levels.
sizeArray = zoomArray .* ones(MAX_FRAMES,1); % size from centre of each frame.

centreArray = interpArray(:,1);  % centre of each frame

iterateHandle = @iterate;

tic % begin timing
if DO_IN_PARALLEL
    parfor frameNum = 1:MAX_FRAMES
        %evaluate function iterate with handle iterateHandle
        frameArray(frameNum) = feval(iterateHandle, frameNum);
    end
else
    for frameNum = 1:MAX_FRAMES
        if WRITE_VIDEO_TO_FILE
            %frame has already been written in this case
            iterate(frameNum);
        else
            frameArray(frameNum) = iterate(frameNum);
        end
    end
end

if WRITE_VIDEO_TO_FILE
    if DO_IN_PARALLEL
        writeVideo(vidObj, frameArray);
    end
    close(vidObj);
    toc %end timing
else
    toc %end timing
    %clf;
    set(gcf, 'Position', [100, 100, RESOLUTION + 10, RESOLUTION + 10]);
    axis off;
    shg; % bring the figure to the top to be seen.
    movie(gcf, frameArray, 1, MAX_FRAMES/DURATION, [5, 5, 0, 0]);
end

    function frame = iterate (frameNum)

        centreX = real(centreArray(frameNum)); 
        centreY = imag(centreArray(frameNum)); 
        size = sizeArray(frameNum); 
        x = linspace(centreX - size, centreX + size, RESOLUTION);
        %you can modify the aspect ratio if you want.
        y = linspace(centreY - size, centreY + size, RESOLUTION);
        
        % the below might work okay unless you want to further optimize
        % Create the two-dimensional complex grid using meshgrid
        [X,Y] = meshgrid(x,y);
        z0 = X + 1i*Y;
        
        % Initialize the iterates and counts arrays.
        z = z0;
        
        % needed for mex, assumedly to make z elements separate
        %in memory from z0 elements.
        z(1,1) = z0(1,1); 
        
        % make c of type uint16 (unsigned 16-bit integer)
        c = zeros(RESOLUTION, RESOLUTION, 'uint16');
        
        % Here is the Mandelbrot iteration.
        c(abs(z) < 2) = 1;
        
        % below line turns warning off for MATLAB R2015b and similar
        %   releases of MATLAB.  Those releases have a bug causing a 
        %   warning for mex invocations like ours.  
        % warning( 'off', 'MATLAB:lang:badlyScopedReturnValue' );

        depth = MAX_DEPTH; % you can make depth dynamic if you want.
        
        for k = 2:depth
            [z,c] = mandelbrot_step(z,c,z0,k);
            % mandelbrot_step is a c-mex file that does one step of:
            %  z = z.^2 + z0;
            %  c(abs(z) < 2) = k;
        end
        
        
        % create an image from c and then convert to frame.  Use CMAP
        if frameNum<=150 %first frame zoom1
            colMap=ind2rgb(c,CMAP0);
        elseif frameNum<=300
                colMap=ind2rgb(c,CMAP1);
        elseif frameNum<=450
                colMap=ind2rgb(c,CMAP2);
        elseif frameNum<=600
                colMap=ind2rgb(c,CMAP3);
        elseif frameNum<=750
                colMap=ind2rgb(c,CMAP4);
        elseif frameNum<=900
                colMap=ind2rgb(c,CMAP2);
        elseif frameNum<=1050
                colMap=ind2rgb(c,CMAP1);
        elseif frameNum<=1200
                colMap=ind2rgb(c,CMAP5);
        end
        %IF YOU WANT TO DO SLIGHT SHAKING OF THE FRAME:
        %ShakeMap=imrotate(colMap, theta);    Can incorporate into only
                                           %certain parts by putting code
                                           %in the corresponding colour map
                                           %if statement.
        %frameMap=im2frame(ShakeMap);
        %frame=frameMap;
        %if mod(frameNum,2)==0
            %theta=theta+2;
        %else
            %theta=theta-2;
        %end
        frameMap=im2frame(colMap);
        frame = frameMap;
        
        
        if WRITE_VIDEO_TO_FILE && ~DO_IN_PARALLEL
            writeVideo(vidObj, frame);
        end
        
        disp(['frame=' num2str(frameNum)]);
    end

    function startClusterIfNeeded
        myCluster = parcluster('local');
        if isempty(myCluster.Jobs) || ~strcmp(myCluster.Jobs(1).State, 'running')
            PHYSICAL_CORES = feature('numCores');
            
            % "hyperthreads" per physical core
            LOGICAL_PER_PHYSICAL = 2; %valid for the i7 on Craig's desktop
            
            % you can change the NUM_WORKERS calculation below if you want.
            NUM_WORKERS = (LOGICAL_PER_PHYSICAL + 1) * PHYSICAL_CORES;
            myCluster.NumWorkers = NUM_WORKERS;
            saveProfile(myCluster);
            disp('This may take a while when needed!')
            parpool(NUM_WORKERS);
        end
    end

    function openVideoFile
        % create video object
        vidObj = VideoWriter('assignment3');
        vidObj.Quality = 100; %%%%%%%%%CONSIDER THIS
        vidObj.FrameRate = MAX_FRAMES/DURATION;
        open(vidObj);
    end

end

%ASSIGNMENT 3 QUESTIONS & INSPIRATION HERE
