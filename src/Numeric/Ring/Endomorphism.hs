{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances #-}
module Numeric.Ring.Endomorphism 
  ( End(..)
  , toEnd
  , fromEnd
  , frobenius
  ) where

import Data.Monoid
import Numeric.Algebra
import Prelude hiding ((*),(+),(-),negate,subtract)
import Data.Proxy

-- | The endomorphism ring of an abelian group or the endomorphism semiring of an abelian monoid
-- 
-- http://en.wikipedia.org/wiki/Endomorphism_ring
newtype End a = End { appEnd :: a -> a }
instance Monoid (End r) where
  mappend (End a) (End b) = End (a . b)
  mempty = End id
instance Additive r => Additive (End r) where
  End f + End g = End (f + g)
instance Abelian r => Abelian (End r)
instance Monoidal r => Monoidal (End r) where
  zero = End (const zero)
instance Group r => Group (End r) where
  End f - End g = End (f - g)
  negate (End f) = End (negate f)
  subtract (End f) (End g) = End (subtract f g)
instance Multiplicative (End r) where
  End f * End g = End (f . g)
instance Unital (End r) where
  one = End id
instance (Abelian r, Commutative r) => Commutative (End r) 
instance (Abelian r, Monoidal r) => Semiring (End r)
instance (Abelian r, Monoidal r) => Rig (End r)
instance (Abelian r, Group r) => Ring (End r)
instance (Monoidal m, Abelian m) => LeftModule (End m) (End m) where
  End f .* End g = End (f . g)
instance (Monoidal m, Abelian m) => RightModule (End m) (End m) where
  End f *. End g = End (f . g)
instance LeftModule r m => LeftModule r (End m) where
  r .* End f = End (\e -> r .* f e)
instance RightModule r m => RightModule r (End m) where
  End f *. r = End (\e -> f e *. r)

-- TODO: Involutive? Invertible?
-- instance SimpleAdditiveAbelianGroup r => DivisionRing (End r) where

-- ring isomorphism from r to the endomorphism ring of r.
toEnd :: Multiplicative r => r -> End r
toEnd r = End (*r)

-- ring isomorphism from the endormorphism ring of r to r.
fromEnd :: Unital r => End r -> r
fromEnd (End f) = f one

-- the frobenius ring endomorphism (assuming the characteristic is prime)
frobenius :: Characteristic r => End r
frobenius = End $ \r -> r `pow` char (ofRing r)

ofRing :: r -> Proxy r
ofRing _ = Proxy

