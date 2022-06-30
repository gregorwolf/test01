/* eslint-disable no-undef */
sap.ui.define(["sap/m/library"], function ({ URLHelper }) {
  return {
    onPress: function (oEvent) {
        const oContext = oEvent.getSource().getBindingContext();        
        const url = oContext.getObject().url;
        URLHelper.redirect(url);
        location.reload();
    },
  };
});
