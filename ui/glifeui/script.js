$(function(){
    window.addEventListener("message", function(event){
        if (event.data.showGlife == true) {
            $(".glife-ui").fadeIn();
            var health = event.data.health;
            var armor = event.data.armor;
            $("#glife-health-percent").html(Math.round(health) + "%");
            $("#glife-health-level").css("width", health + "%");
            if (armor <= 0) {
                $('.glife-armor').fadeOut(250);
            }else {
                $('.glife-armor').fadeIn(250);
            }
            $("#glife-armor-percent").html(Math.round(armor) + "%");
            $("#glife-armor-level").css("width", armor + "%");
        }
        if (event.data.showGlife == false) {
            $(".glife-ui").fadeOut();
        } 
    })
})