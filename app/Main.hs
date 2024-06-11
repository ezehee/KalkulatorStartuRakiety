{-# LANGUAGE OverloadedStrings #-}

import Graphics.UI.Threepenny.Core
import qualified Graphics.UI.Threepenny as UI
import RocketThrust (obliczPaliwo, dostosujDeltaV)
import GraphGenerator (generujWykres)

main :: IO ()
main = do
    startGUI defaultConfig { jsPort = Just 8023 } setup

setup :: Window -> UI ()
setup okno = do
    return okno # set title "Kalkulator Ciągu Rakietowego"

    -- Pola wejściowe
    masaWejscie <- mkInputWithPlaceholder "Masa (kg)"
    ispWejscie <- mkInputWithPlaceholder "ISP (s)"
    deltaVWejscie <- mkInputWithPlaceholder "Delta V (m/s)"
    
    -- Lista rozwijana do wyboru miejsca startu
    listaMiejscStartowych <- UI.select # set UI.id_ "listaMiejscStartowych"
                                    #+ map mkOption miejscaStartowe

    -- Przycisk
    przyciskOblicz <- UI.button #+ [string "Oblicz"]

    -- Pole wyjściowe
    wynikWyjscie <- UI.div

    -- Układ
    getBody okno #+ [column [ element masaWejscie
                               , element ispWejscie
                               , element deltaVWejscie
                               , element listaMiejscStartowych
                               , element przyciskOblicz
                               , element wynikWyjscie
                               ]
                      ]

    -- Obsługa zdarzeń
    on UI.click przyciskOblicz $ \_ -> do
        masaStr <- get value masaWejscie
        ispStr <- get value ispWejscie
        deltaVStr <- get value deltaVWejscie
        miejsceStartu <- get value listaMiejscStartowych
        
        let masa = read masaStr :: Double
            isp = read ispStr :: Double
            deltaV = read deltaVStr :: Double

            (szerokoscGeograficzna, dlugoscGeograficzna) = pobierzWspolrzedne miejsceStartu

            -- Dostosuj deltaV do obrotu Ziemi
            deltaV' = dostosujDeltaV deltaV szerokoscGeograficzna

            -- Oblicz zapotrzebowanie na paliwo uwzględniając obrót Ziemi
            paliwo = obliczPaliwo masa isp deltaV' szerokoscGeograficzna

        element wynikWyjscie # set text ("Wymagane paliwo: " ++ show paliwo ++ " kg")

        -- Generuj punkty danych dla wykresu
        let punkty = [(wys, obliczPredkosc wys masa isp deltaV' szerokoscGeograficzna) | wys <- [0, 1000 .. 10000]]
        
        -- Generuj wykres z punktami danych
        liftIO $ generujWykres punkty

-- Funkcja do obliczania prędkości na podstawie wysokości (to jest tylko zastępcza implementacja)
obliczPredkosc :: Double -> Double -> Double -> Double -> Double -> Double
obliczPredkosc wysokosc masa isp deltaV szerokoscGeograficzna = 
    wysokosc * (deltaV / 10000) -- Prosta zależność liniowa dla celów demonstracyjnych

-- Funkcja pomocnicza do tworzenia pól wejściowych z tekstem zastępczym
mkInputWithPlaceholder :: String -> UI Element
mkInputWithPlaceholder tekstZastepczy = UI.input # set (UI.attr "placeholder") tekstZastepczy

-- Funkcja pomocnicza do tworzenia opcji rozwijanej listy
mkOption :: String -> UI Element
mkOption wartosc = UI.option # set UI.text wartosc

-- Lista miejsc startowych
miejscaStartowe :: [String]
miejscaStartowe = ["Przylądek Canaveral", "Centrum Kosmiczne im. Kennedy'ego", "Kosmodrom Bajkonur", "Port Kosmiczny Gujarat"]

-- Funkcja do pobierania współrzędnych dla danego miejsca startu
pobierzWspolrzedne :: String -> (Double, Double)
pobierzWspolrzedne "Przylądek Canaveral" = (28.5623, -80.5774)
pobierzWspolrzedne "Centrum Kosmiczne im. Kennedy'ego" = (28.5721, -80.648)
pobierzWspolrzedne "Kosmodrom Bajkonur" = (45.965, 63.305)
pobierzWspolrzedne "Port Kosmiczny Gujarat" = (21.104, 72.741)
pobierzWspolrzedne _ = (0, 0) -- Domyślne współrzędne, jeśli żadne nie pasują
