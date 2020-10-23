enum ChatType {
  text,
  image,
  pickUpLoaction,
  dropLocation,
  pickDropLocation,
  command,
  shop,
  needs,
}
enum OrderType { shopping, packageDelivery }
enum OrderStatus { subitted, assigned, completed, cancelled }
enum OfferStatus { sent, accepted, rejected, cancelled, completed }
enum RatingStatus { sent, approved, unapproved }
enum ChatButtons {
  MyLastOrders,
  NewOrders,
  PackageDelivery,
  ShopList,
  ShopLocation,
  PickFromMenu,
  ChangePickFromMenu,
  WriteWhatYouWant,
  ChangeWriteWhatYouWant,
  DropLocation,
  AddCoupon,
  DontHaveCoupon,
  CashPayment,
  Submit,
  Change,
  Cancel,
  PickAndDropLocation,
}
enum LocationType { PickUp, Drop, PickAndDrop }
