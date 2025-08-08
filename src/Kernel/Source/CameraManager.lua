local CameraManager = {}
CameraManager.__index = CameraManager

function CameraManager.new(camera)
    local self = setmetatable({}, CameraManager)
    self.camera = camera
    return self
end

return CameraManager