function saveResultToXMP(xmpFile,G)
    % saveResultToXMP - Save results to a XMP file.
    % 
    % Inputs:
    % xmpFile          - path to the original XMP file.
    % G                - 3x4 Matrix [R t] where R is a 3x3 rotational
    %                     matrix and t is a 3x1 translation vector

out_file_path='fiore_results.xmp.txt';  

% Read XML file
xmlData = xmlread(xmpFile);

% Locate the translation element
extrinsics = xmlData.getElementsByTagName('extrinsics').item(0);
translationNode = extrinsics.getElementsByTagName('translation').item(0);
rotationNode    = extrinsics.getElementsByTagName('rotation').item(0);


% Convert back to string
newTranslationText = sprintf('%.12f %.12f %.12f', G(1,4),G(2,4),G(3,4));
newRotationText    = sprintf('%.12f %.12f %.12f %.12f %.12f %.12f %.12f %.12f %.12f', G(1:3,1:3)');
                                          

% Update XML content
translationNode.getFirstChild.setData(newTranslationText);
rotationNode.getFirstChild.setData(newRotationText);


% Write back to file
xmlwrite(out_file_path, xmlData);

disp('File copied and modified successfully.');