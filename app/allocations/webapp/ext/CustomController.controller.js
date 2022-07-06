sap.ui.define([
    'sap/ui/core/mvc/ControllerExtension',
    'sap/ui/core/Fragment',
    'sap/ui/model/json/JSONModel',
    'sap/m/MessageBox',
    'sap/ui/core/message/Message',
    'sap/ui/core/MessageType'
    // ,'sap/ui/core/mvc/OverrideExecution'
],
    function (
        ControllerExtension,
        Fragment,
        JSONModel,
        MessageBox,
        Message,
        MessageType
        // ,OverrideExecution
    ) {
        "use strict";
        return ControllerExtension.extend("allocations.ext.CustomController", {
            override: {
                onAfterRendering: function () {
                    //allocations::AllocationsObjectPage--fe::table::inputFields::LineItem::View::StandardAction::Create
                    const createBtn = this.base.byId(this.getView().getId() + "--fe::table::inputFields::LineItem::View::StandardAction::Create");
                    createBtn.unbindProperty("visible");
                    createBtn.setVisible(false);
                }
            }
        });
    });