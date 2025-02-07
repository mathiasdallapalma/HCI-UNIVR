function saveResultToJson(Iw, Ih, fmm, SensorX, SensorY, ls_x, ls_y, T_u, euu_VU)
    % saveResultToJson - Save results to a JSON file.
    % 
    % Inputs:
    % Iw, Ih           - Image size.
    % fmm              - Focal Lenght in mm.
    % SensorX, SensorY - Size of the sensor.
    % ls_x, ls_y       - Lens Shift.
    % T_u              - Position X Y Z.
    % euu_VU           - Rotation X Y Z.

    out_file_path='out.json';
    
    % Create a structured array to organize the data
    resultsStruct = struct();

    resultsStruct.ImageWidth=Iw;
    resultsStruct.ImageHeight=Ih;

    resultsStruct.FocalLenght=fmm;

    resultsStruct.SensorSizeX = SensorX;
    resultsStruct.SensorSizeY = SensorY;

    resultsStruct.LensShiftX = ls_x;
    resultsStruct.LensShiftY = ls_y;

    resultsStruct.PositionX = T_u(1,1);
    resultsStruct.PositionY = T_u(2,1);
    resultsStruct.PositionZ = T_u(3,1);

    resultsStruct.RotationX =euu_VU(1,1);
    resultsStruct.RotationY =euu_VU(2,1);
    resultsStruct.RotationZ =euu_VU(3,1);

    % Convert the structured array to JSON format
    jsonData = jsonencode(resultsStruct);

    % Write the JSON data to the specified file
    try
        % Open the file for writing
        fid = fopen(out_file_path, 'w');
        if fid == -1
            error('Cannot open file for writing: %s', 'out.json');
        end

        % Write the JSON string to the file
        fprintf(fid, '%s', jsonData);
        fclose(fid); % Close the file

        % Display success message
        fprintf('Results successfully saved to %s\n', out_file_path);
    catch ME
        % Handle any errors during file operations
        fprintf('Error saving results to JSON: %s\n', ME.message);
        if exist('fid', 'var') && fid ~= -1
            fclose(fid); % Ensure the file is closed
        end
    end
end
