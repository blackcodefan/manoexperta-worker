import 'package:flutter/material.dart';
import 'package:workerf/redux/index.dart';
import 'AuthState.dart';
import 'CredentialState.dart';
import 'HintState.dart';
import 'CategoryState.dart';
import 'PackageState.dart';
import 'DetailState.dart';
import 'MarketState.dart';

@immutable
class AppState{
  final AuthState authState;
  final LocalStorageState credentialState;
  final HintState hintState;
  final CategoryState categoryState;
  final PProjectState pProjectState;
  final PackageState packageState;
  final ProjectState projectState;
  final DetailState detailState;
  final BidState bidState;
  final MarketState marketState;

  AppState({
    this.authState,
    this.credentialState,
    this.hintState,
    this.categoryState,
    this.pProjectState,
    this.packageState,
    this.projectState,
    this.detailState,
    this.bidState,
    this.marketState
  });

  factory AppState.init() => AppState(
      authState: AuthState.init(),
      credentialState: LocalStorageState.init(),
      hintState: HintState.init(),
      categoryState: CategoryState.init(),
      pProjectState: PProjectState.init(),
      packageState: PackageState.init(),
      projectState: ProjectState.init(),
      detailState: DetailState.init(),
      bidState: BidState.init(),
      marketState: MarketState.init()
  );

  AppState copyWith({
    AuthState auth,
    LocalStorageState credential,
    HintState hints,
    CategoryState category,
    PProjectState pProjects,
    PackageState packages,
    ProjectState projects,
    DetailState detail,
    BidState bid,
    MarketState market
  }){
    return AppState(
        authState: auth??this.authState,
        credentialState: credential??this.credentialState,
        hintState: hints??this.hintState,
        categoryState: category??this.categoryState,
        pProjectState: pProjects??this.pProjectState,
        packageState: packages??this.packageState,
        projectState: projects??this.projectState,
        detailState: detail??this.detailState,
        bidState: bid??this.bidState,
        marketState: market??this.marketState
    );
  }
}