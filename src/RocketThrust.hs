module RocketThrust
    ( obliczPaliwo
    , dostosujDeltaV
    ) where

-- Stałe
predkoscObrotuZiemi :: Double
predkoscObrotuZiemi = 1670.0 -- w km/h na równiku

przyspieszenieGrawitacyjne :: Double
przyspieszenieGrawitacyjne = 9.81 -- m/s^2

-- Oblicz efektywną prędkość wyloczniającą
efektywnaPredkoscWyloczniajaca :: Double -> Double -> Double
efektywnaPredkoscWyloczniajaca isp grawitacja = isp * grawitacja

-- Oblicz zapotrzebowanie na paliwo uwzględniając obrót Ziemi
obliczPaliwo :: Double -> Double -> Double -> Double -> Double
obliczPaliwo masa isp deltaV szerokoscGeograficzna = 
    masa * (1 - exp (-deltaV / efektywnaPredkoscWyloczniajaca isp przyspieszenieGrawitacyjne))

-- Oblicz ciąg
obliczCiąg :: Double -> Double -> Double
obliczCiąg mDot vE = mDot * vE

-- Dostosuj deltaV do obrotu Ziemi
dostosujDeltaV :: Double -> Double -> Double
dostosujDeltaV deltaV szerokoscGeograficzna = 
    deltaV - (predkoscObrotuZiemi * cos (szerokoscGeograficzna * pi / 180))

