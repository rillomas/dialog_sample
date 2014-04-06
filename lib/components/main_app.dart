library main_app;

import 'dart:html';
import 'dart:js';
import 'package:polymer/polymer.dart';

@CustomTag("main-app")
class MainApp extends PolymerElement {
  MainApp.created(): super.created() {
  }

  @override
  void enteredView() {
    super.enteredView();

    // Apply style from parent in order to use bootstrap
    shadowRoot.applyAuthorStyles = true;

    _dialog = shadowRoot.querySelector("#sampleDialog");
    if (_dialog is UnknownElement) {
      print("<dialog> not supported on this browser. Applying polyfill");
      var pf = context['dialogPolyfill'];
      pf.callMethod('registerDialog',[_dialog]);
    }
    _dialog.on["close"].listen((data) {
      print("Dialog closed");
    });
    _dialog.on["cancel"].listen((data) {
      print("Dialog cancelled");
    });
  }

  void openDialog(Event e, var detail, Node target) {
    if (_dialog is DialogElement) {
      var dlg = _dialog as DialogElement;
      dlg.showModal();
    } else {
      // Native dialog not available.
      // Call polyfilled function
      var obj = new JsObject.fromBrowserObject(_dialog);
      obj.callMethod("showModal",[]);
    }
  }

  void closeDialog(Event e, var detail, Node target) {
    if (_dialog is DialogElement) {
      var dlg = _dialog as DialogElement;
      dlg.close(null);
    } else {
      // Native dialog not available.
      // Call polyfilled function
      var obj = new JsObject.fromBrowserObject(_dialog);
      obj.callMethod("close",[]);
    }
  }

  HtmlElement _dialog;
}
