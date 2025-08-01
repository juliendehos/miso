-----------------------------------------------------------------------------
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE OverloadedLabels      #-}
-----------------------------------------------------------------------------
{-# OPTIONS_GHC -fno-warn-orphans  #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Miso.Style.Color
-- Copyright   :  (C) 2016-2025 David M. Johnson
-- License     :  BSD3-style (see the file LICENSE)
-- Maintainer  :  David M. Johnson <code@dmj.io>
-- Stability   :  experimental
-- Portability :  non-portable
-----------------------------------------------------------------------------
module Miso.Style.Color
  ( -- *** Types
    Color (RGB, RGBA, HSL, HSLA, Hex)
    -- *** Smart constructor
  , rgba
  , rgb
  , hsl
  , hsla
  , hex
  , var
    -- *** Render
  , renderColor
    -- *** Colors
  , transparent
  , aliceblue
  , antiquewhite
  , aqua
  , aquamarine
  , azure
  , beige
  , bisque
  , black
  , blanchedalmond
  , blue
  , blueviolet
  , brown
  , burlywood
  , cadetblue
  , chartreuse
  , chocolate
  , coral
  , cornflowerblue
  , cornsilk
  , crimson
  , cyan
  , darkblue
  , darkcyan
  , darkgoldenrod
  , darkgray
  , darkgreen
  , darkgrey
  , darkkhaki
  , darkmagenta
  , darkolivegreen
  , darkorange
  , darkorchid
  , darkred
  , darksalmon
  , darkseagreen
  , darkslateblue
  , darkslategray
  , darkslategrey
  , darkturquoise
  , darkviolet
  , deeppink
  , deepskyblue
  , dimgray
  , dimgrey
  , dodgerblue
  , firebrick
  , floralwhite
  , forestgreen
  , fuchsia
  , gainsboro
  , ghostwhite
  , gold
  , goldenrod
  , gray
  , green
  , greenyellow
  , grey
  , honeydew
  , hotpink
  , indianred
  , indigo
  , ivory
  , khaki
  , lavender
  , lavenderblush
  , lawngreen
  , lemonchiffon
  , lightblue
  , lightcoral
  , lightcyan
  , lightgoldenrodyellow
  , lightgray
  , lightgreen
  , lightgrey
  , lightpink
  , lightsalmon
  , lightseagreen
  , lightskyblue
  , lightslategray
  , lightslategrey
  , lightsteelblue
  , lightyellow
  , lime
  , limegreen
  , linen
  , magenta
  , maroon
  , mediumaquamarine
  , mediumblue
  , mediumorchid
  , mediumpurple
  , mediumseagreen
  , mediumslateblue
  , mediumspringgreen
  , mediumturquoise
  , mediumvioletred
  , midnightblue
  , mintcream
  , mistyrose
  , moccasin
  , navajowhite
  , navy
  , oldlace
  , olive
  , olivedrab
  , orange
  , orangered
  , orchid
  , palegoldenrod
  , palegreen
  , paleturquoise
  , palevioletred
  , papayawhip
  , peachpuff
  , peru
  , pink
  , plum
  , powderblue
  , purple
  , red
  , rosybrown
  , royalblue
  , saddlebrown
  , salmon
  , sandybrown
  , seagreen
  , seashell
  , sienna
  , silver
  , skyblue
  , slateblue
  , slategray
  , slategrey
  , snow
  , springgreen
  , steelblue
  , tan
  , teal
  , thistle
  , tomato
  , turquoise
  , violet
  , wheat
  , white
  , whitesmoke
  , yellow
  , yellowgreen
  ) where
-----------------------------------------------------------------------------
import           Miso.String (MisoString, ms)
import qualified Miso.String as MS
-----------------------------------------------------------------------------
import           Data.Proxy
import           GHC.TypeLits
import           GHC.OverloadedLabels
import           Numeric (showHex)
import           Language.Javascript.JSaddle (ToJSVal(..), MakeArgs(..))
import           Prelude hiding (tan)
-----------------------------------------------------------------------------
data Color
  = RGBA Int Int Int Double
  | RGB Int Int Int
  | HSL Int Int Int
  | HSLA Int Int Int Double
  | Hex MisoString
  | VarColor MisoString
  deriving (Show, Eq)
-----------------------------------------------------------------------------
-- | This instance exists to make it easy to define hex colors.
--
-- @
-- grey :: Color
-- grey = #cccccc
-- @
--
instance KnownSymbol color => IsLabel color Color where
  fromLabel = Hex (ms color)
    where
      color = symbolVal (Proxy @color)
-----------------------------------------------------------------------------
instance KnownSymbol hex => IsLabel hex MisoString where
  fromLabel = ms (symbolVal (Proxy @hex))
-----------------------------------------------------------------------------
instance MakeArgs Color where
  makeArgs color = (:[]) <$> toJSVal color
-----------------------------------------------------------------------------
instance ToJSVal Color where
  toJSVal = toJSVal . renderColor
-----------------------------------------------------------------------------
renderColor :: Color -> MisoString
renderColor (RGBA r g b a) = "rgba(" <> values <> ")"
  where
    values = MS.intercalate ","
      [ MS.ms r
      , MS.ms g
      , MS.ms b
      , MS.ms a
      ]
renderColor (RGB r g b) = "rgb(" <> values <> ")"
  where
    values = MS.intercalate ","
      [ MS.ms r
      , MS.ms g
      , MS.ms b
      ]
renderColor (HSLA h s l a) = "hsla(" <> values <> ")"
  where
    values = MS.intercalate ","
      [ MS.ms h
      , MS.ms s
      , MS.ms l
      , MS.ms a
      ]
renderColor (HSL h s l) = "hsl(" <> values <> ")"
  where
    values = MS.intercalate ","
      [ MS.ms h
      , MS.ms s
      , MS.ms l
      ]
renderColor (Hex s) = "#" <> s
renderColor (VarColor n) = "var(--" <> n <> ")"
-----------------------------------------------------------------------------
var :: MisoString -> Color
var = VarColor
-----------------------------------------------------------------------------
rgba :: Int -> Int -> Int -> Double -> Color
rgba = RGBA
-----------------------------------------------------------------------------
rgb :: Int -> Int -> Int -> Color
rgb = RGB
-----------------------------------------------------------------------------
hsl :: Int -> Int -> Int -> Color
hsl = HSL
-----------------------------------------------------------------------------
hsla :: Int -> Int -> Int -> Double -> Color
hsla = HSLA
-----------------------------------------------------------------------------
-- | Smart constructor for color in hexadecimal
--
-- > div [ style_ [ backgroundColor (hex 0xAABBCC) ] ] [ ]
-- > -- "#aabbcc"
--
hex :: Int -> Color
hex = Hex . ms . flip showHex ""
-----------------------------------------------------------------------------
transparent :: Color
transparent = rgba 0 0 0 0
-----------------------------------------------------------------------------
aliceblue :: Color
aliceblue = rgba 240 248 255 1
-----------------------------------------------------------------------------
antiquewhite :: Color
antiquewhite = rgba 250 235 215 1
-----------------------------------------------------------------------------
aqua :: Color
aqua = rgba 0 255 255 1
-----------------------------------------------------------------------------
aquamarine :: Color
aquamarine = rgba 127 255 212 1
-----------------------------------------------------------------------------
azure :: Color
azure = rgba 240 255 255 1
-----------------------------------------------------------------------------
beige :: Color
beige = rgba 245 245 220 1
-----------------------------------------------------------------------------
bisque :: Color
bisque = rgba 255 228 196 1
-----------------------------------------------------------------------------
black :: Color
black = rgba 0 0 0 1
-----------------------------------------------------------------------------
blanchedalmond :: Color
blanchedalmond = rgba 255 235 205 1
-----------------------------------------------------------------------------
blue :: Color
blue = rgba 0 0 255 1
-----------------------------------------------------------------------------
blueviolet :: Color
blueviolet = rgba 138 43 226 1
-----------------------------------------------------------------------------
brown :: Color
brown = rgba 165 42 42 1
-----------------------------------------------------------------------------
burlywood :: Color
burlywood = rgba 222 184 135 1
-----------------------------------------------------------------------------
cadetblue :: Color
cadetblue = rgba 95 158 160 1
-----------------------------------------------------------------------------
chartreuse :: Color
chartreuse = rgba 127 255 0 1
-----------------------------------------------------------------------------
chocolate :: Color
chocolate = rgba 210 105 30 1
-----------------------------------------------------------------------------
coral :: Color
coral = rgba 255 127 80 1
-----------------------------------------------------------------------------
cornflowerblue :: Color
cornflowerblue = rgba 100 149 237 1
-----------------------------------------------------------------------------
cornsilk :: Color
cornsilk = rgba 255 248 220 1
-----------------------------------------------------------------------------
crimson :: Color
crimson = rgba 220 20 60 1
-----------------------------------------------------------------------------
cyan :: Color
cyan = rgba 0 255 255 1
-----------------------------------------------------------------------------
darkblue :: Color
darkblue = rgba 0 0 139 1
-----------------------------------------------------------------------------
darkcyan :: Color
darkcyan = rgba 0 139 139 1
-----------------------------------------------------------------------------
darkgoldenrod :: Color
darkgoldenrod = rgba 184 134 11 1
-----------------------------------------------------------------------------
darkgray :: Color
darkgray = rgba 169 169 169 1
-----------------------------------------------------------------------------
darkgreen :: Color
darkgreen = rgba 0 100 0 1
-----------------------------------------------------------------------------
darkgrey :: Color
darkgrey = rgba 169 169 169 1
-----------------------------------------------------------------------------
darkkhaki :: Color
darkkhaki = rgba 189 183 107 1
-----------------------------------------------------------------------------
darkmagenta :: Color
darkmagenta = rgba 139 0 139 1
-----------------------------------------------------------------------------
darkolivegreen :: Color
darkolivegreen = rgba 85 107 47 1
-----------------------------------------------------------------------------
darkorange :: Color
darkorange = rgba 255 140 0 1
-----------------------------------------------------------------------------
darkorchid :: Color
darkorchid = rgba 153 50 204 1
-----------------------------------------------------------------------------
darkred :: Color
darkred = rgba 139 0 0 1
-----------------------------------------------------------------------------
darksalmon :: Color
darksalmon = rgba 233 150 122 1
-----------------------------------------------------------------------------
darkseagreen :: Color
darkseagreen = rgba 143 188 143 1
-----------------------------------------------------------------------------
darkslateblue :: Color
darkslateblue = rgba 72 61 139 1
-----------------------------------------------------------------------------
darkslategray :: Color
darkslategray = rgba 47 79 79 1
-----------------------------------------------------------------------------
darkslategrey :: Color
darkslategrey = rgba 47 79 79 1
-----------------------------------------------------------------------------
darkturquoise :: Color
darkturquoise = rgba 0 206 209 1
-----------------------------------------------------------------------------
darkviolet :: Color
darkviolet = rgba 148 0 211 1
-----------------------------------------------------------------------------
deeppink :: Color
deeppink = rgba 255 20 147 1
-----------------------------------------------------------------------------
deepskyblue :: Color
deepskyblue = rgba 0 191 255 1
-----------------------------------------------------------------------------
dimgray :: Color
dimgray = rgba 105 105 105 1
-----------------------------------------------------------------------------
dimgrey :: Color
dimgrey = rgba 105 105 105 1
-----------------------------------------------------------------------------
dodgerblue :: Color
dodgerblue = rgba 30 144 255 1
-----------------------------------------------------------------------------
firebrick :: Color
firebrick = rgba 178 34 34 1
-----------------------------------------------------------------------------
floralwhite :: Color
floralwhite = rgba 255 250 240 1
-----------------------------------------------------------------------------
forestgreen :: Color
forestgreen = rgba 34 139 34 1
-----------------------------------------------------------------------------
fuchsia :: Color
fuchsia = rgba 255 0 255 1
-----------------------------------------------------------------------------
gainsboro :: Color
gainsboro = rgba 220 220 220 1
-----------------------------------------------------------------------------
ghostwhite :: Color
ghostwhite = rgba 248 248 255 1
-----------------------------------------------------------------------------
gold :: Color
gold = rgba 255 215 0 1
-----------------------------------------------------------------------------
goldenrod :: Color
goldenrod = rgba 218 165 32 1
-----------------------------------------------------------------------------
gray :: Color
gray = rgba 128 128 128 1
-----------------------------------------------------------------------------
green :: Color
green = rgba 0 128 0 1
-----------------------------------------------------------------------------
greenyellow :: Color
greenyellow = rgba 173 255 47 1
-----------------------------------------------------------------------------
grey :: Color
grey = rgba 128 128 128 1
-----------------------------------------------------------------------------
honeydew :: Color
honeydew = rgba 240 255 240 1
-----------------------------------------------------------------------------
hotpink :: Color
hotpink = rgba 255 105 180 1
-----------------------------------------------------------------------------
indianred :: Color
indianred = rgba 205 92 92 1
-----------------------------------------------------------------------------
indigo :: Color
indigo = rgba 75 0 130 1
-----------------------------------------------------------------------------
ivory :: Color
ivory = rgba 255 255 240 1
-----------------------------------------------------------------------------
khaki :: Color
khaki = rgba 240 230 140 1
-----------------------------------------------------------------------------
lavender :: Color
lavender = rgba 230 230 250 1
-----------------------------------------------------------------------------
lavenderblush :: Color
lavenderblush = rgba 255 240 245 1
-----------------------------------------------------------------------------
lawngreen :: Color
lawngreen = rgba 124 252 0 1
-----------------------------------------------------------------------------
lemonchiffon :: Color
lemonchiffon = rgba 255 250 205 1
-----------------------------------------------------------------------------
lightblue :: Color
lightblue = rgba 173 216 230 1
-----------------------------------------------------------------------------
lightcoral :: Color
lightcoral = rgba 240 128 128 1
-----------------------------------------------------------------------------
lightcyan :: Color
lightcyan = rgba 224 255 255 1
-----------------------------------------------------------------------------
lightgoldenrodyellow :: Color
lightgoldenrodyellow = rgba 250 250 210 1
-----------------------------------------------------------------------------
lightgray :: Color
lightgray = rgba 211 211 211 1
-----------------------------------------------------------------------------
lightgreen :: Color
lightgreen = rgba 144 238 144 1
-----------------------------------------------------------------------------
lightgrey :: Color
lightgrey = rgba 211 211 211 1
-----------------------------------------------------------------------------
lightpink :: Color
lightpink = rgba 255 182 193 1
-----------------------------------------------------------------------------
lightsalmon :: Color
lightsalmon = rgba 255 160 122 1
-----------------------------------------------------------------------------
lightseagreen :: Color
lightseagreen = rgba 32 178 170 1
-----------------------------------------------------------------------------
lightskyblue :: Color
lightskyblue = rgba 135 206 250 1
-----------------------------------------------------------------------------
lightslategray :: Color
lightslategray = rgba 119 136 153 1
-----------------------------------------------------------------------------
lightslategrey :: Color
lightslategrey = rgba 119 136 153 1
-----------------------------------------------------------------------------
lightsteelblue :: Color
lightsteelblue = rgba 176 196 222 1
-----------------------------------------------------------------------------
lightyellow :: Color
lightyellow = rgba 255 255 224 1
-----------------------------------------------------------------------------
lime :: Color
lime = rgba 0 255 0 1
-----------------------------------------------------------------------------
limegreen :: Color
limegreen = rgba 50 205 50 1
-----------------------------------------------------------------------------
linen :: Color
linen = rgba 250 240 230 1
-----------------------------------------------------------------------------
magenta :: Color
magenta = rgba 255 0 255 1
-----------------------------------------------------------------------------
maroon :: Color
maroon = rgba 128 0 0 1
-----------------------------------------------------------------------------
mediumaquamarine :: Color
mediumaquamarine = rgba 102 205 170 1
-----------------------------------------------------------------------------
mediumblue :: Color
mediumblue = rgba 0 0 205 1
-----------------------------------------------------------------------------
mediumorchid :: Color
mediumorchid = rgba 186 85 211 1
-----------------------------------------------------------------------------
mediumpurple :: Color
mediumpurple = rgba 147 112 219 1
-----------------------------------------------------------------------------
mediumseagreen :: Color
mediumseagreen = rgba 60 179 113 1
-----------------------------------------------------------------------------
mediumslateblue :: Color
mediumslateblue = rgba 123 104 238 1
-----------------------------------------------------------------------------
mediumspringgreen :: Color
mediumspringgreen = rgba 0 250 154 1
-----------------------------------------------------------------------------
mediumturquoise :: Color
mediumturquoise = rgba 72 209 204 1
-----------------------------------------------------------------------------
mediumvioletred :: Color
mediumvioletred = rgba 199 21 133 1
-----------------------------------------------------------------------------
midnightblue :: Color
midnightblue = rgba 25 25 112 1
-----------------------------------------------------------------------------
mintcream :: Color
mintcream = rgba 245 255 250 1
-----------------------------------------------------------------------------
mistyrose :: Color
mistyrose = rgba 255 228 225 1
-----------------------------------------------------------------------------
moccasin :: Color
moccasin = rgba 255 228 181 1
-----------------------------------------------------------------------------
navajowhite :: Color
navajowhite = rgba 255 222 173 1
-----------------------------------------------------------------------------
navy :: Color
navy = rgba 0 0 128 1
-----------------------------------------------------------------------------
oldlace :: Color
oldlace = rgba 253 245 230 1
-----------------------------------------------------------------------------
olive :: Color
olive = rgba 128 128 0 1
-----------------------------------------------------------------------------
olivedrab :: Color
olivedrab = rgba 107 142 35 1
-----------------------------------------------------------------------------
orange :: Color
orange = rgba 255 165 0 1
-----------------------------------------------------------------------------
orangered :: Color
orangered = rgba 255 69 0 1
-----------------------------------------------------------------------------
orchid :: Color
orchid = rgba 218 112 214 1
-----------------------------------------------------------------------------
palegoldenrod :: Color
palegoldenrod = rgba 238 232 170 1
-----------------------------------------------------------------------------
palegreen :: Color
palegreen = rgba 152 251 152 1
-----------------------------------------------------------------------------
paleturquoise :: Color
paleturquoise = rgba 175 238 238 1
-----------------------------------------------------------------------------
palevioletred :: Color
palevioletred = rgba 219 112 147 1
-----------------------------------------------------------------------------
papayawhip :: Color
papayawhip = rgba 255 239 213 1
-----------------------------------------------------------------------------
peachpuff :: Color
peachpuff = rgba 255 218 185 1
-----------------------------------------------------------------------------
peru :: Color
peru = rgba 205 133 63 1
-----------------------------------------------------------------------------
pink :: Color
pink = rgba 255 192 203 1
-----------------------------------------------------------------------------
plum :: Color
plum = rgba 221 160 221 1
-----------------------------------------------------------------------------
powderblue :: Color
powderblue = rgba 176 224 230 1
-----------------------------------------------------------------------------
purple :: Color
purple = rgba 128 0 128 1
-----------------------------------------------------------------------------
red :: Color
red = rgba 255 0 0 1
-----------------------------------------------------------------------------
rosybrown :: Color
rosybrown = rgba 188 143 143 1
-----------------------------------------------------------------------------
royalblue :: Color
royalblue = rgba 65 105 225 1
-----------------------------------------------------------------------------
saddlebrown :: Color
saddlebrown = rgba 139 69 19 1
-----------------------------------------------------------------------------
salmon :: Color
salmon = rgba 250 128 114 1
-----------------------------------------------------------------------------
sandybrown :: Color
sandybrown = rgba 244 164 96 1
-----------------------------------------------------------------------------
seagreen :: Color
seagreen = rgba 46 139 87 1
-----------------------------------------------------------------------------
seashell :: Color
seashell = rgba 255 245 238 1
-----------------------------------------------------------------------------
sienna :: Color
sienna = rgba 160 82 45 1
-----------------------------------------------------------------------------
silver :: Color
silver = rgba 192 192 192 1
-----------------------------------------------------------------------------
skyblue :: Color
skyblue = rgba 135 206 235 1
-----------------------------------------------------------------------------
slateblue :: Color
slateblue = rgba 106 90 205 1
-----------------------------------------------------------------------------
slategray :: Color
slategray = rgba 112 128 144 1
-----------------------------------------------------------------------------
slategrey :: Color
slategrey = rgba 112 128 144 1
-----------------------------------------------------------------------------
snow :: Color
snow = rgba 255 250 250 1
-----------------------------------------------------------------------------
springgreen :: Color
springgreen = rgba 0 255 127 1
-----------------------------------------------------------------------------
steelblue :: Color
steelblue = rgba 70 130 180 1
-----------------------------------------------------------------------------
tan :: Color
tan = rgba 210 180 140 1
-----------------------------------------------------------------------------
teal :: Color
teal = rgba 0 128 128 1
-----------------------------------------------------------------------------
thistle :: Color
thistle = rgba 216 191 216 1
-----------------------------------------------------------------------------
tomato :: Color
tomato = rgba 255 99 71 1
-----------------------------------------------------------------------------
turquoise :: Color
turquoise = rgba 64 224 208 1
-----------------------------------------------------------------------------
violet :: Color
violet = rgba 238 130 238 1
-----------------------------------------------------------------------------
wheat :: Color
wheat = rgba 245 222 179 1
-----------------------------------------------------------------------------
white :: Color
white = rgba 255 255 255 1
-----------------------------------------------------------------------------
whitesmoke :: Color
whitesmoke = rgba 245 245 245 1
-----------------------------------------------------------------------------
yellow :: Color
yellow = rgba 255 255 0 1
-----------------------------------------------------------------------------
yellowgreen :: Color
yellowgreen = rgba 154 205 50 1
-----------------------------------------------------------------------------
