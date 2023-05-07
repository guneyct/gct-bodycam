$(document).ready(function(){
    
    $(".bodycam").hide();
    $(".odz").hide();
    window.addEventListener("message", function(event){
        if(event.data.open == true)
        {
            $(".odz").fadeIn();
            $(".bodycam").fadeIn();
            document.getElementById("dane").innerHTML = event.data.date;
            document.getElementById("data").innerHTML = event.data.ranga;
            document.getElementById("stopien").innerHTML = event.data.daneosoby;
        }
        else if(event.data.open == false) 
        {
            $(".odz").fadeOut();
            $(".bodycam").fadeOut();
        }
    })
});

//
//document.getElementById("data").innerHTML = event.data.date;
//document.getElementById("stopien").innerHTML = event.data.ranga;
//document.getElementById("dane").innerHTML = event.data.daneosoby;