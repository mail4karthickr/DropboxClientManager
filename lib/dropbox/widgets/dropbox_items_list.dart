import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/model/files/list_folder.dart';
import 'package:dropbox_clients_manager/dropbox/bloc/dropbox_items_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'db_entry_extenstion.dart';

class DropboxItemsList extends StatefulWidget {
  final String path;
  final String title;
  final Function makeDropboxItemsListBloc;
  DropboxItemsListBloc bloc;

  DropboxItemsList({@required this.path,
    this.title,
    @required this.makeDropboxItemsListBloc}) {
    this.bloc = makeDropboxItemsListBloc();
  }

  @override
  _DropboxItemsListState createState() => _DropboxItemsListState();
}

class _DropboxItemsListState extends State<DropboxItemsList> {

  @override
  void initState() {
    super.initState();
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    widget.bloc.initState.add(widget.path);
    widget.bloc.showProgressDialog.listen((data){
      data ? pr.show() : pr.hide();
    });
    widget.bloc.errorMessage.listen((message){
      _showDialog(title: 'Error Occurred', message: message);
    });
//    widget.bloc.dismissBottomSheet.listen((data) {
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => _onMoreButtonPressed())
        ],
      ),
      body: StreamBuilder<List<Entry>>(
        stream: widget.bloc.dropboxItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length > 0 ? _buildDropboxEntriesList(snapshot.data) :
            Center(child: Text('No items found'));
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  ListView _buildDropboxEntriesList(List<Entry> entries) {
    return ListView.separated(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return entry.isFile ? _buildFileItem(entry) : _buildFolderItem(entry);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  void _showDialog({String title, String message}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title ?? ''),
          content: new Text(message ?? ''),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
                      onTap: () => {
                        Navigator.pop(context),
                        widget.bloc.logoutDropbox.add(true)
                      }
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  onDropboxItemTapped(Entry entry) {
    Navigator.push(context,
      MaterialPageRoute(
          builder: (context) {
            if (entry.isFolder) {
              return DropboxItemsList(
                  path: entry.pathLower,
                  title: entry.name,
                  makeDropboxItemsListBloc: widget.makeDropboxItemsListBloc);
            } else {
              return Scaffold(
                  appBar: AppBar(), body: Center(child: Text("isFile"))
              );
            }
          }, fullscreenDialog: false),
    );
  }

  Widget _buildFileItem(Entry entry) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () { onDropboxItemTapped(entry); },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
        child: Row(
          children: <Widget>[
            Image.asset(entry.imageName, height: 25, width: 25),
            Padding(padding: EdgeInsets.only(left: 15)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(entry.name),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text('${entry.fileSize}, ${entry.lastModified}')
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderItem(Entry entry) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () { onDropboxItemTapped(entry); },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
        child: Row(
          children: <Widget>[
            Image.asset(entry.imageName, height: 25, width: 25),
            Padding(padding: EdgeInsets.only(left: 15)),
            Text(entry.name),
          ],
        ),
      ),
    );
  }
}