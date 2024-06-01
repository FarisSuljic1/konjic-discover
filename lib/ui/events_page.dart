import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:discover/backend.dart';
import 'package:discover/postavke.dart';
import 'package:discover/ui/event_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final postavke = Provider.of<Postavke>(context);
    final dogadjaji = Provider.of<Backend>(context).dogadjaji;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0),
        title: Text(localizations.events),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Theme.of(context).colorScheme.background.withOpacity(0.8),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: dogadjaji.length,
          itemBuilder: (context, index) {
            final dogadjaj = dogadjaji[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EventPage(event: dogadjaj)));
                },
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                            imageUrl: dogadjaj.slike.first, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.5, 0.8],
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  postavke.jezik == Jezik.bosanski
                                      ? dogadjaj.naziv
                                      : dogadjaj.naziv_en,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              if (dogadjaj.vrijeme != null)
                                Text(
                                    DateFormat("EEEE, d.M.y",
                                            localizations.localeName)
                                        .format(dogadjaj.vrijeme!)
                                        .replaceFirstMapped(
                                            RegExp(r"(\w+)"),
                                            (match) =>
                                                match
                                                    .group(0)!
                                                    .substring(0, 1)
                                                    .toUpperCase() +
                                                match.group(0)!.substring(1)),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 15,
                                        fontFamily: "Montserrat-Light",
                                        fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
