{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE TypeFamilies              #-}

-- Algo for doing image creation/manipulation
module FrameCreator where

import AppData

import Data.ByteString
import qualified Data.ByteString.Lazy

import Diagrams.TwoD.Image
import Diagrams.TwoD.Size
import Diagrams.Prelude
import Diagrams.Backend.Rasterific
import Codec.Picture.Png

parseImageData :: 
     (ByteString, Int)
  -> Maybe (PatternData)
parseImageData (bsData, c) = 
  PatternData <$> pd <*> pure Horizontal
    <*> (getDefaultRadius c <$> pd)
    <*> pure c
  where
    pd = case loadImageEmbBS bsData of
          (Left _) -> Nothing
          (Right dimg) -> Just $ image dimg

getPngForPD :: PatternData -> Int -> ByteString
getPngForPD pd width = Data.ByteString.Lazy.toStrict $
  encodePng $ renderDia Rasterific
          (RasterificOptions (mkWidth w))
          (origPatternData pd)
  where 
    w :: Double
    w = fromIntegral width

getDefaultRadius :: Int -> Diagram B -> Double
getDefaultRadius num' img = (h/2) + (w/2)/(tan (alpha/2))
  where
    w = width img
    h = height img
    num = fromIntegral num'
    alpha = (2*pi)/num
                                  
-- createForeground :: MonadResource m => 
--      Source m ByteString
--   -> Source m ByteString
-- createForeground inpSrc =
--   mapMaybe bsToMaybeImage
--   --loadImageEmbBS :: Num n => ByteString -> Either String (DImage n Embedded)
--   let 
--   -- renderDia :: Rasterific -> Options Rasterific V2 n -> QDiagram Rasterific V2
--   -- n m -> 'Image PixelRGBA8'
--     outputImg = renderDia Rasterific
--           (RasterificOptions (mkWidth outputSize))
--           (createDia origImg)
--   
-- 
-- createDia :: Diagram B -> Diagram B
-- createDia origImg = finalImg
--   where
--     finalImg = origImg
