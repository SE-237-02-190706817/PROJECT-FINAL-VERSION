import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:crypto_application/models/fetchCoins_models/fetch_coins_models.dart';
import 'package:flutter_svg/svg.dart';

class CoinDetailAppBar extends StatelessWidget {
  final DataModel coin;
  final String coinIconUrl;
  const CoinDetailAppBar({
    Key? key,
    required this.coin,
    required this.coinIconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36.0)),
      pinned: true,
      snap: true,
      floating: true,
      backgroundColor: Color.fromRGBO(11, 12, 54, 1),
      expandedHeight: 280.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 4.4, 0.0),
          width: double.infinity,
          height: 56.0,
          child: ListTile(
            title: Text(
              coin.name + " " + coin.symbol + " #" + coin.cmcRank.toString(),
              style: TextStyle(color: Colors.white, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
            // subtitle: Text(coin.slug),
          ),
        ),
        background: CachedNetworkImage(
          imageUrl: ((coinIconUrl + coin.symbol + ".png").toLowerCase()),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              SvgPicture.asset('assets/icons/dollar.svg'),
          fit: BoxFit.contain,
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}
