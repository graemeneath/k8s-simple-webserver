$(function() {
  refreshFinance();
  window.setInterval(refreshFinance, 60000);
});

console.log("Getting finance data");
var refreshFinance= function() {
  $('#finance').empty();

  $.getJSON("../../dashboard/finance.json",
    function(data) {
      if (typeof data === 'undefined' || data.length<10) {
        addFinanceRow("Getting data...", 'finance');
        setTimeout(() => { refreshFinance() }, 1000);
      } else {
        rate=data.rate;
        price=data.price;
        total=data.total;
        rateDiff=data.rateDiff;
        priceDiff=data.priceDiff;
        totalDiff=data.totalDiff;
        message=data.message;
        daysLeft=data.daysLeft;

        addFinanceRow('Rate: '+rate+' ('+rateDiff+')', 'finance');
        addFinanceRow('Price: $'+price+' ($'+priceDiff+')', 'finance');
        addFinanceRow("Total: "+currencyFormat(total)+' ('+currencyFormat(totalDiff)+')', 'finance');
        addFinanceRow("Days Left: "+daysLeft, 'finance');
        if (message != "") addFinanceRow(message, 'finance').className = "finance_data_message";
      }
    }
  );
}

function currencyFormat(num) {
  return "£" + num.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
}

var addFinanceRow = function (info, elementId) {
  var container = document.createElement("div");
  container.className = "finance_data";

  data = document.getElementById(elementId)

  var newLabel = document.createElement('label');
  newLabel.appendChild(document.createTextNode(info));
  container.appendChild(newLabel);
  container.appendChild(document.createElement("br"));
  
  document.getElementById(elementId).appendChild(container);

  return container
}
