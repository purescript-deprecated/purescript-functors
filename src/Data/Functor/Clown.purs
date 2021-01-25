module Data.Functor.Clown where

import Prelude

import Data.Functor.FunctorRight (class FunctorRight)
import Data.Newtype (class Newtype)

-- | Lifts a type that takes a single type parameter to a type that takes
-- | two type parameters where the second parameter is a phantom type.
-- | If you want the first parameter to be the phantom type instead of
-- | the second type parameter, see the `Joker` newtype.
-- |
-- | ```purescript
-- | data Box a = Box a
-- | -- these values are the same at runtime
-- |        Box a  ::       Box a
-- | Clown (Box a) :: Clown Box a Int
-- | Clown (Box a) :: Clown Box a String
-- |
-- | newtype TupleInt a = TupleInt (Tuple Int a)
-- | -- these values are the same at runtime
-- |        TupleInt (Tuple 4 true) ::        TupleInt Boolean
-- | Clown (TupleInt (Tuple 4 true)) :: Clown TupleInt Boolean Int
-- | Clown (TupleInt (Tuple 4 true)) :: Clown TupleInt Boolean String
-- | ```
newtype Clown :: forall k. (k -> Type) -> k -> Type -> Type
newtype Clown f a b = Clown (f a)

derive instance newtypeClown :: Newtype (Clown f a b) _

derive newtype instance eqClown :: Eq (f a) => Eq (Clown f a b)

derive newtype instance ordClown :: Ord (f a) => Ord (Clown f a b)

instance showClown :: Show (f a) => Show (Clown f a b) where
  show (Clown x) = "(Clown " <> show x <> ")"

instance functorClown :: Functor (Clown f a) where
  map _ (Clown a) = Clown a

instance functorRightClown :: FunctorRight (Clown f) where
  rmap = map

hoistClown :: forall f g a b. (f ~> g) -> Clown f a b -> Clown g a b
hoistClown f (Clown a) = Clown (f a)