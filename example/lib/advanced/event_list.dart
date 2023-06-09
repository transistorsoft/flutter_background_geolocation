import 'package:flutter/material.dart';
import 'shared_events.dart';

/// Renders a simple list of [BackgroundGeolocation] events.  Fetches its data from [SharedEvents] (which is an [InheritedWidget].
///
class EventList extends StatefulWidget {
  @override
  State createState() => EventListState();
}

class EventListState extends State<EventList>
    with AutomaticKeepAliveClientMixin<EventList> {
  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Fetch SharedEvents for events data.
    final events = SharedEvents.of(context);

    return Container(
        //color: Color.fromRGBO(20, 20, 20, 1.0),
        color: Colors.white,
        padding: EdgeInsets.all(5.0),
        child: ListView.builder(
            itemCount: events?.events.length,
            itemBuilder: (BuildContext context, int index) => InputDecorator(
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 5.0, top: 0.0, bottom: 5.0),
                  isDense: true,
                  labelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  labelText: events?.events[index].name,
                ),
                child: Text(events!.events[index].content,
                    style: TextStyle(color: Colors.black, fontSize: 16.0)
                )
            )
        )
    );
  }
}
