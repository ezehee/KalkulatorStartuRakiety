module GraphGenerator (generujWykres) where

import Graphics.Rendering.Chart.Easy
import Graphics.Rendering.Chart.Backend.Cairo
import Data.Default.Class (def)

generujWykres :: [(Double, Double)] -> IO ()
generujWykres punkty = toFile def "predkosc_vs_wysokosc.png" $ do
    layout_title .= "Prędkość Rakiety vs Wysokość"
    plot (line "predkosc" [punkty])
