function [Iw,Ih,fx,fy,cx,cy,R,t] = getParamsFromXMP(xmpFilePath)
    % Function to read camera calibration data from an XMP file.
    % 
    % Input:
    %   xmpFilePath - Path to the XMP file.
    % 
    % Outputs:
    %   Iw - Image width
    %   Ih - Image height
    %   fx - Focal length in pixels (x-axis)
    %   fy - Focal length in pixels (y-axis)
    %   cx - Principal point in pixels (x-axis)
    %   cy - Principal point in pixels (y-axis)
    %   R  - Rotation matrix
    %   t  - Translation vector


    % Check if the file exists
    if ~isfile(xmpFilePath)
        error('The specified XMP file does not exist.');
    end

    % Read the XMP file as text
    fileContent = fileread(xmpFilePath);

    % Extract the required attributes using regular expressions
    Iw_temp = str2double(extractBetween(fileContent, 'w="', '"'));
    Iw = Iw_temp(1,1);
    Ih = str2double(extractBetween(fileContent, 'h="', '"'));
    fx = str2double(extractBetween(fileContent, 'fx="', '"'));
    fy = str2double(extractBetween(fileContent, 'fy="', '"'));
    cx = str2double(extractBetween(fileContent, 'cx="', '"'));
    cy = str2double(extractBetween(fileContent, 'cy="', '"'));

    rotation_array = str2double(split(extractBetween(fileContent,'<rotation>','</rotation>')));
    R=reshape(rotation_array,3,3)';

    t = str2double(split(extractBetween(fileContent,'<translation>','</translation>')));

end
