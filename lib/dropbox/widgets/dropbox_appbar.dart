import 'package:dropbox_clients_manager/dropbox/bloc/dropbox_appbar_bloc.dart';
import 'package:flutter/material.dart';

class DropboxAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final DropboxAppBarBloc bloc;

  const DropboxAppBar({Key key, this.title, this.appBar, this.bloc})
      : super(key: key);

  @override
  _DropboxAppBarState createState() => _DropboxAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class _DropboxAppBarState extends State<DropboxAppBar>  {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.more_vert), onPressed: () => _onMoreButtonPressed())
      ],
    );
  }

  void _onMoreButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 30),
                  child: ListTile(
                    title: new Text('Logout'),
                     onTap: () => { widget.bloc.logoutDropbox.add(true) }
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}