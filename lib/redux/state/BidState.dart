class BidState{
  dynamic error;
  bool loading;

  BidState({this.error, this.loading});

  factory BidState.init() => BidState(
      error: null,
      loading: false
  );
}