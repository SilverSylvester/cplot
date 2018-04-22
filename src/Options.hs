{-# LANGUAGE TemplateHaskell #-}

module Options
  ( AppOptions
  , HasAppOptions
  , parseArgs

  -- AppOptions lenses
  , appOptions
  , initialCharts
  ) where

import           Control.Arrow       (left)
import           Control.Lens
import           Data.Default
import           Data.HashMap.Strict   (HashMap)
import qualified Data.HashMap.Strict   as Map
import           Data.Monoid         ((<>))
import           Data.Text           (Text)
import qualified Data.Text           as T
import           Options.Applicative

import qualified Parser.Options      as MP
import qualified Text.Megaparsec     as MP

import           Chart.Types

data AppOptions = AppOptions
  { _initialCharts :: HashMap Text Chart
  -- ^ The initial set of charts defined by the command line options.
  }

instance Default AppOptions where
  def = AppOptions Map.empty

makeClassy ''AppOptions


parseArgs :: IO AppOptions
parseArgs = execParser (info (helper <*> parseOptions)
                             (header "cplot"))

parseOptions :: Parser AppOptions
parseOptions = AppOptions . toChartMap <$> chartsParser
  where
    chartsParser =
      some $ option chartReader $
        long "chart"
     <> short 'c'
     <> help (mconcat [ "Constructs a chart from a string containing the name "
                      , "of the chart, the label for the data in the plot, and "
                      , "the kind of data (one of 'line', 'scatter', or "
                      , "'histogram'). For example: `cplot -c 'WebData Clickstream "
                      , "line'` will create a chart called 'WebData' with a line plot "
                      , "called 'Clickstream'"
                      ])

    toChartMap cs = Map.fromList [ (chart^.title, chart) | chart <- cs ]

-- | Transforms megaparsec parsers into optparse ReadM parsers
parsecReadM :: MP.Parser a -> ReadM a
parsecReadM p = eitherReader (left MP.parseErrorPretty . MP.parse p "" . T.pack)

-- | Convert megaparsec 'parseChart' parser to a ReadM parser.
chartReader :: ReadM Chart
chartReader = parsecReadM MP.parseChart
