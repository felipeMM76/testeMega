import 'package:flutter/material.dart';
import 'package:mega_test/model/user.dart';
import 'package:mega_test/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mega_test/view/newContact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: AppColors.myWhite,
      appBar: new AppBar(
        title: new Text('Contatos', style: TextStyle( fontSize: 22.0, fontWeight: FontWeight.w600,),),
        elevation: 0.0,
        centerTitle: true,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
            new MaterialPageRoute(
              builder: (context) => new NewContactPage(myUser: null)));
        },
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: StreamBuilder(
        stream: Firestore.instance.collection('user').orderBy('name').snapshots(),
        builder: (context, snapshot){

          //Se nao carregou os dados, loading...
          if (!snapshot.hasData) {
            return Center(
              child: new Container(
                height: 100.0,
                width: 100.0,
                child: new CircularProgressIndicator(
                  strokeWidth: 5.0,
                ),
              ),
            );
          }

        return new ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return Slidable(
              delegate: new SlidableDrawerDelegate(),
              actionExtentRatio: 0.2,
              child: Item(index, document),
              secondaryActions: <Widget>[
                new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: IconSlideAction(
                    caption: 'Editar',
                    color: AppColors.colorSecondary,
                    icon: Icons.edit,
                    foregroundColor: Colors.white,
                    onTap: () {
                      User _user = new User();
                      _user.id = snapshot.data.documents[index].documentID;
                      _user.name = snapshot.data.documents[index]['name'];
                      _user.phone = snapshot.data.documents[index]['phone'];
                      _user.address = snapshot.data.documents[index]['address'];
                      _user.photo = snapshot.data.documents[index]['photo'];

                      Navigator.push(context,
                        new MaterialPageRoute(
                          builder: (context) => new NewContactPage(myUser: _user)));
                    },
                  ),
                ),

                new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: IconSlideAction(
                    caption: 'Excluir',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      deleteData(snapshot.data.documents[index].documentID);
                    },
                  ),
                ),
              ],
            );
          });
        }
      ),
    );
  }
}



Widget Item (int index, DocumentSnapshot _document) {

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: FlatButton(
      onPressed: null,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 0.2)),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            // Coluna 1
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 60.0,

                  //Coluna Interna
                  child: new Container(
                    width: 60.0,
                    height: 60.0,
                    child: new CircleAvatar(
//                      backgroundImage: new AssetImage('assets/images/user.png'),
                      backgroundImage: _document['photo'] != null ? new NetworkImage(_document['photo']) : new AssetImage('assets/images/user.png'),
                    ),
                  ),

                ),
              ],
            ),

            // Coluna 2
            new Flexible(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
//                  width: 280.0,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    //Coluna Interna
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       new Row(
                          children: <Widget>[
                            SizedBox(width: 25.0),
                            Flexible(child: new Text( _document['name'] != null ? _document['name'] : 'Rafa', style: TextStyle(color: AppColors.colorPrimary, fontSize: 16.0, fontWeight: FontWeight.bold,))),
                          ],
                        ),
                        SizedBox(height: 6.0),

                        new Row(
                          children: <Widget>[
                            new Icon(Icons.phone, size: 20.0, color: AppColors.colorPrimary,),
                            SizedBox(width: 5.0),
                            new Text(_document['phone'] != null ? _document['phone'] : '(11) 998877-6655', style: TextStyle(color: AppColors.myBlack, fontSize: 16.0)),
                          ],
                        ),
                        SizedBox(height: 6.0),

                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Icon(Icons.location_on, size: 20.0, color: AppColors.colorPrimary,),
                            SizedBox(width: 5.0),
                            Flexible(child: new Text(_document['address'] != null ? _document['address'] : 'Rua: Benedita de Souza, 123 - São Paulo', style: TextStyle(color: AppColors.myBlack, fontSize: 16.0))),
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),


            // Coluna 3
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(right: 4.0),
                  child: new Icon(Icons.chevron_left, size: 30.0, color: AppColors.colorPrimary,)

                )
              ],
            ),

          ],
        ),

      )),
  );
}




deleteData(String id){
  Firestore.instance.collection('user').document(id).delete().catchError((e) {
    print(e);
  });
}
