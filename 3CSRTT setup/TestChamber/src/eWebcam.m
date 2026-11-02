classdef eWebcam < handle
    properties
        cam
        VideoImg = {};
        videoStatus;
    end
    
    methods
        function obj = eWebcam(Cam)
            Cam.Resolution = '640x480';
            obj.cam = Cam;
        end
        
        function initVideo(obj)
            obj.VideoImg = {};
            obj.videoStatus = 'fullVideo';
        end
        
        function ErrorReport(obj)
            obj.videoStatus = 'videoError';
            fprintf('\n Video stopped\n');
        end
        
        function TakePhoto(obj)
            img = snapshot(obj.cam);
            
            if isempty(obj.VideoImg)
                obj.VideoImg = {img};
            else
                obj.VideoImg{end + 1} = img;
            end
        end
        
        function Preview(obj)
            preview(obj.cam)
        end
        
        function ClosePreview(obj)
            closePreview(obj.cam)
        end
    end
end