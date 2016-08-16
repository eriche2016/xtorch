require 'nn'

function getVGG()
    local vgg = nn.Sequential()

    local function ConvBNReLU(nInputPlane, nOutputPlane)
        vgg:add(nn.SpatialConvolution(nInputPlane, nOutputPlane, 3, 3, 1, 1, 1, 1))
        vgg:add(nn.SpatialBatchNormalization(nOutputPlane, 1e-3))
        vgg:add(nn.ReLU(true))
        return vgg
    end

    local MaxPooling = nn.SpatialMaxPooling

    ConvBNReLU(3,64):add(nn.Dropout(0.3));
    ConvBNReLU(64,64);
    vgg:add(MaxPooling(2,2,2,2):ceil());

    ConvBNReLU(64,128):add(nn.Dropout(0.4));
    ConvBNReLU(128,128);
    vgg:add(MaxPooling(2,2,2,2):ceil());

    ConvBNReLU(128,256):add(nn.Dropout(0.4));
    ConvBNReLU(256,256):add(nn.Dropout(0.4));
    ConvBNReLU(256,256);
    vgg:add(MaxPooling(2,2,2,2):ceil());

    ConvBNReLU(256,512):add(nn.Dropout(0.4));
    ConvBNReLU(512,512):add(nn.Dropout(0.4));
    ConvBNReLU(512,512);
    vgg:add(MaxPooling(2,2,2,2):ceil());

    ConvBNReLU(512,512):add(nn.Dropout(0.4))
    ConvBNReLU(512,512):add(nn.Dropout(0.4))
    ConvBNReLU(512,512)
    vgg:add(MaxPooling(2,2,2,2):ceil())
    vgg:add(nn.View(512):setNumInputDims(3))

    vgg:add(nn.Dropout(0.5))
    vgg:add(nn.Linear(512,512))
    vgg:add(nn.BatchNormalization(512))
    vgg:add(nn.ReLU(true))
    vgg:add(nn.Dropout(0.5))
    vgg:add(nn.Linear(512,10))

    return vgg
end
