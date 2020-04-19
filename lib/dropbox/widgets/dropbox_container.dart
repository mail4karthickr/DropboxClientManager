import 'package:dropbox_clients_manager/common/widget/message_widget.dart';
import 'package:dropbox_clients_manager/dropbox/bloc/dropbox_container_bloc.dart';
import 'package:flutter/material.dart';

import 'dropbox_appbar.dart';

class DropboxContainer extends StatefulWidget {
  final DropboxContainerBloc dropboxBloc;
  final Function makeDropboxItemsList;

  DropboxContainer({@required this.dropboxBloc, this.makeDropboxItemsList}) :
        assert(dropboxBloc != null),
        assert(makeDropboxItemsList != null);

  @override
  _DropboxContainerState createState() => _DropboxContainerState();
}

class _DropboxContainerState extends State<DropboxContainer> {
  @override
  void initState() {
    super.initState();
    widget.dropboxBloc.initState.add('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
          stream: widget.dropboxBloc.isClientAuthorized,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data ?
              widget.makeDropboxItemsList('') :
                MessageWidget(message: 'Please link your dropbox account', buttonTapped: () {
                widget.dropboxBloc.authenticateUser.add('');
              });
            } else if(snapshot.hasError) {
              return Center(child: Text('Error occurred'));
            } else {
              return _loaderWidget();
            }
          }),
    );
  }

  Widget _loaderWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

//  StreamBuilder<bool> _buildDropboxMessageViewStreamBuilder() {
//    return StreamBuilder<bool>(
//      stream: widget.bloc.showDropboxMessageView,
//      builder: (context, snapshot) {
//        if (snapshot.hasData && snapshot.data) {
//          return
//        } else {
//          return
//        }
//      },
//    );
//  }

  @override
  void dispose() {
    widget.dropboxBloc.close();
    super.dispose();
  }

}
