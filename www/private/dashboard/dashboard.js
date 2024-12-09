$(function() {
  refreshAll();
  window.setInterval(checkState, 10000);
  window.setInterval(checkTracks, 600000);
});

var state = "";
var tracks = "";

var refreshAll= function() {
  $.get('/info/store?name=checked', function(data) {
    state = data;    
  
    $('#tracks').empty();

    $.getJSON("/info/track",
      function(data) {
        addCheckbox('Is Full', 'tracks');
        addCheckbox('Is Weekend', 'tracks');
        addCheckbox('30 days', 'tracks');
        addCheckbox('60 days', 'tracks');
        addGap('tracks')
        tracks = data.tracks;
        tracks.forEach(function(t) { 
          addCheckbox(t, 'tracks');
        });
        populateData();
      }
    );
  })
}

var updateFilters = function() {
  saveState();
  checkState();
}

var populateData = function() {
    $('#data').empty();

    var isFull = false;
    var isWeekend = false;
    var nextThirtyDays = false;
    var nextSixtyDays = false;
    var tracks = [];
    var filters=$('#tracks').find('input')
    if (filters.length > 0) {
      filters.each(function(f) {
          if (this.id == "Is Full") {
              isFull = this.checked;
          } else if (this.id == "Is Weekend") {
              isWeekend = this.checked;
          } else if (this.id == "30 days") {
              nextThirtyDays = this.checked;
          } else if (this.id == "60 days") {
              nextSixtyDays = this.checked;
          } else {
              if (this.checked) {
                  tracks.push(this.value);
              }
          }
      })

      $.getJSON("/info/track",
      function(data) {
        var rows = data.rows;
        rows.forEach(function(r) {
          if (!isFull && r.isFull == "True") return;
          if (tracks.length > 0 && !tracks.includes(r.track)) return;
          if (isWeekend && !isDateWeekend(r.date)) return;
          if (nextThirtyDays && !dateInRange(r.date, 30)) return;
          if (nextSixtyDays && !dateInRange(r.date, 60)) return;

          addRow(r, 'data')
        });
      }
    )
  }    
}

var addCheckbox = function (value, elementId) {
    var container = document.createElement("div");
    container.className = "track_filter";

    var newCheckbox = document.createElement("input");
    newCheckbox.type = "checkbox";
    newCheckbox.value = value;
    newCheckbox.id = value;
    newCheckbox.onclick = function() { updateFilters() };
    newCheckbox.checked = getState(value);
    container.appendChild(newCheckbox);

    var label = document.createElement('label');
    label.htmlFor = value;
    label.appendChild(document.createTextNode(value));
    container.appendChild(label);

    document.getElementById(elementId).appendChild(container);
}

var addRow = function (row, elementId) {
    var container = document.createElement("div");
    container.className = "track_data";

    data = document.getElementById(elementId)

    info = (row.isFull == "True"?"FULL ":"")+row.track+" "+getDayName(row.date)+" "+row.date+" ";

    var trackLabel = document.createElement('label');
    trackLabel.appendChild(document.createTextNode(info));

    container.appendChild(trackLabel);
    if (row.booking != "") $('<a href="'+row.booking+'" target="_blank">Booking Link</a>').appendTo(container);
    container.appendChild(document.createElement("br"));
    
    document.getElementById(elementId).appendChild(container);
}

var addGap = function (elementId) {
    document.getElementById(elementId).appendChild(document.createElement("br"));
}

var getDayName = function (dateString) {
    var date = new Date(dateString);
    return date.toLocaleDateString('en-UK', { weekday: 'long' });
}

var dateInRange = function (dateString, delta) {
    var date = new Date(dateString);
    date.setDate(date.getDate() - delta);
    var todayDate = new Date(); 
    return (date<todayDate);
}

var isDateWeekend = function (dateString) {
    var date = new Date(dateString);
    var day = date.getDay();
    return (day == 0 || day == 6);
}

var getState = function(id) {
    if (state == undefined) return false;

    var checked = state.split(",");
    return checked.includes(id);
}

var saveState = function() {
  var state="";

  var filters=$('#tracks').find('input')
  if (filters != null) {
    filters.each(function(f) {
        if (this.checked) state = state + this.id + ",";
    })
    $.post("/info/store", "name=checked&info="+state);
  }
}

var checkState = function() {
  
  var lastState = state;

  return function() {
    $.get('/info/store?name=checked', function(currentState) {
      if (currentState != lastState) {
        lastState = currentState;
        refreshAll();
      }
    })
  };
}();

var checkTracks = function() {
  
  var lastTracks = tracks;

  return function() {
    $.getJSON("/info/track", function(data) {
      currentTracks = data.tracks;
      if (currentTracks != lastTracks) {
        lastTracks = currentTracks;
        refreshAll();
      }
    })
  };
}();
