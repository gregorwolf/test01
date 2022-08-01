sap.ui.define(
    ["sap/ui/core/mvc/ControllerExtension", "functions/modules/Diagram"],
    function (ControllerExtension, Diagram) {
      "use strict";
      return ControllerExtension.extend("functions.ext.controller.LRExtend", {
        override: {
          onInit: function () {
          
          },
          onViewNeedsRefresh: function () {  
            // const holder = document.getElementById("functions::FunctionsList--fe::CustomTab::tableView1--holder");
            const holderControl = this.base.byId(this.getView().getId() + "--fe::CustomTab::tableView1--holder");
            const router = null; //this.base.getRouter();
            // if (!this._diagram) {
              this._diagram = new Diagram(router);
              this._diagram.createDiagram(holderControl.getDomRef());
            // }
          },
        },
      });
    }
  );
  