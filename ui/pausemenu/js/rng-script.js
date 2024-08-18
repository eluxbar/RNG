window.addEventListener('message', function(event) {
    var data = event.data;
    let date = new Date();
    let day = String(date.getDate()).padStart(2, '0');
    let month = String(date.getMonth() + 1).padStart(2, '0');
    let year = date.getFullYear();
    let hours = String(date.getHours()).padStart(2, '0');
    let minutes = String(date.getMinutes()).padStart(2, '0');
    let seconds = String(date.getSeconds()).padStart(2, '0');
    let currentTime = hours + ':' + minutes;
    let currentDate = day + '/' + month + '/' + year + ' ' + currentTime;

    if (data.type === 'rngTogglePauseMenu') {
        if (data.toggle === true) {
            document.getElementById('rngRoot').style.display = "block";
            document.getElementById('todaysDate').innerText = currentDate;
            document.getElementById('rngDLastName').innerText = data.rngDLastName;
            document.getElementById('rngDBirthdate').innerText = data.rngDBirthdate;
            document.getElementById('rngDGender').innerText = data.rngDGender;
            document.getElementById('rngPlrName').innerText = data.rngPlrName;
            document.getElementById('totalPlayers').innerText = data.totalPlayers;
        }  else if (data.toggle === false) {
            document.getElementById('rngRoot').style.display = "none";
        }
    }
});

var elements = document.querySelectorAll("#rngCuBbox, #rngconnect, #rngPmRow, #rngPmBox3, #rngPmBox2, #rngCsettings, #rngCsButtons, #rngComRules, #Store, #joinDiscord, #disupte, #rngCdisconnect, #rngCmap, .rngPmNavCont, .rngNavRow, .rngPmBox2, .rngPmBox3");

elements.forEach(function(element) {
    element.addEventListener('mouseenter', function() {
        var audio = new Audio('./sounds/hover.mp3');
        audio.volume = 0.3;
        audio.play();
    });
});

$('#rngCsettings').click(function(){
    $.post('https://rng/Settings', JSON.stringify({}), function(data) {
    });
});

$('#Store').click(function(){
    $.post('https://rng/Store', JSON.stringify({}), function(data) {
    });
});

$('#rngCuBbox').click(function(){
    $.post('https://rng/Guide', JSON.stringify({}), function(data) {
    });
});

$('#twitter').click(function(){
    $.post('https://rng/Twitter', JSON.stringify({}), function(data) {
    });
});

$('#dispute').click(function(){
    $.post('https://rng/Dispute', JSON.stringify({}), function(data) {
    });
});

$('#rngconnect').click(function(){
    $.post('https://rng/DeathMatchF8', JSON.stringify({}), function(data) {
    });
});

$('#joinDiscord').click(function(){
    $.post('https://rng/DeathMatchDiscord', JSON.stringify({}), function(data) {
    });
});

$('#website').click(function(){
    $.post('https://rng/Website', JSON.stringify({}), function(data) {
    });
});

$('#rngCuBbox').click(function(){
    $.post('https://rng/Guide', JSON.stringify({}), function(data) {
    });
});

$('#rngPmBox3').click(function(){
    $.post('https://rng/ComRules', JSON.stringify({}), function(data) {
    });
});

$('#rngPmBox2').click(function(){
    $.post('https://rng/Rules', JSON.stringify({}), function(data) {
    });
});
$('#rngCmap').click(function(){
    $.post('https://rng/Map', JSON.stringify({}), function(data) {
    });
});
$('#rngCdisconnect').click(function(){
    $.post('https://rng/Disconnect', JSON.stringify({}), function(data) {
    });
});

window.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        $.post('https://rng/Close', JSON.stringify({}), function(data) {});
        document.getElementById('rngRoot').style.display = "none";
    }
});