sap.ui.define(["sap/m/MessageToast"], function (MessageToast) {
  "use strict";

  return {
    onPress: function (event) {
      // this.routing.navigateToRoute()
      // MessageToast.show("Custom handler invoked.");
      // this.routing.navigateToRoute("EnvironmentsList", { parent_ID: 3 });
      this.intentBasedNavigation.navigateOutbound("environments-outbound", {
        parent_ID: "3",
      });
    },
  };
});
