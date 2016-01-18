// Create based on the template of my mentor - P' Boat

function init() {
    apid = ['1001905'];
    ite = 0;
    out = [];
}

function ui() {
    $("<div/>", {id: 'mock-up-outer', style:"position: absolute; top: 0; width: 100%; height: 100%; z-index: 1000"}).appendTo("body");
    $("#mock-up-outer").append(
        $("<div/>", { id: "mock-up-inner", style: "position: relative; width: 70%; height: 700px; margin: 100px auto; background-color: white; border: 1px solid black;" })
    );
    $("#mock-up-inner").append(
        $("<div/>", { id: "mock-up-box1", style: "width: 34%; margin: 0 auto;" }).append( 
            $("<div/>",{ style: "height: 90%;" }).append('<textarea id="txt1" rows="10" cols="70" style="margin: 50px auto; height: 550px;"></textarea><button id="run" style="margin: 0px 10px">run</button><button id="res" style="margin: 0px 10px">result</button><button id="store" style="margin: 0px 10px">export</button>')
        )
    );    
    $("#run").unbind().click(function(){
        get_user_info(true);
        if(out.length) {
            $("#txt1").val("done");
        }
    });    
    $("#res").unbind().click(function(){
        if(out.length) {
            display();
        } else {
            $("#txt1").val("no result");
        }
    });
    $("#store").unbind().click(function(){
        if(out.length) {
            download();
        } else {
            $("#txt1").val("no result");
        }
    });
}

Array.prototype.clean = function(deleteValue) {
        for(var i = 0; i < this.length; i++) {
            if (this[i] == deleteValue) {         
                this.splice(i, 1);
                i--;
            }
        }
        return this;
};

function get_user_info(state) {
    if(typeof ite == "undefined" || state) {
        init();
        if($("#txt1").val().split("\n").clean("").length && $("#txt1").val().split("\n")[0] != "done") {
            apid = $("#txt1").val().split("\n").clean("");
        }
        console.log("Fetching ...");
    }
    out[ite] = {ap: '', phone: ''};
    $.ajax({ url: "https://admin.airpay.in.th/manager/user_info/?user_phone=" + apid[ite], 
             success: function(res) {
                 var phone = /value="(66.........)"/.exec(res); //console.log(phone);
                 out[ite].ap = apid[ite];
                 out[ite].phone = phone[1];
                 ite++;
                if(ite < apid.length) { 
                     setTimeout(function() {
                        get_user_info(false); 
                     }, 100);
                } //console.log("Done ...");                  
             }
           });
}

function display() {
    var tmp = "";
    for (i = 0; i < out.length; i++) { 
        tmp += out[i].phone + "\n";
    }
    $("#txt1").val(tmp);   
}

ui();