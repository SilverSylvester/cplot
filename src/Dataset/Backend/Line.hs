module Dataset.Backend.Line
  ( lineDataset
  ) where

import qualified Dataset.Backend.MinMaxQueue as MMQ
import           Dataset.Internal.Types


-- | By default, line data sets use a 'MinMaxQueue'
lineDataset :: Dataset Point
lineDataset = Dataset
  { _insert    = MMQ.push
  , _removeEnd = MMQ.removeEnd
  , _dataset   = MMQ.empty
  , _toList    = MMQ.toList
  , _xbounds   = xbounds
  , _ybounds   = const Nothing
  }

xbounds :: MMQ.MinMaxQueue Point -> Maybe (Double, Double)
xbounds dataset = do
  mx <- MMQ.maximum dataset
  mn <- MMQ.minimum dataset
  case (mn, mx) of
    (Point x _, Point x' _) -> Just (x, x')
    _                       -> Nothing