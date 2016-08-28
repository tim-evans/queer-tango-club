$(function () {
  if ($('#itemizations').length == 0) { return; }
  $('input').on('change', function () {
    var simultaneousEvent = $('input:checked[data-starts-at="' + $(this).data('starts-at') + '"]:not(#' + $(this).attr('id') + ')');

    if (simultaneousEvent) {
      simultaneousEvent.attr('checked', null);
    }
    calculate();
  });

  function Session(json) {
    for (var key in json) {
      if (json.hasOwnProperty(key)) {
        var value = json[key];
        if (key === 'starts_at' || key === 'ends_at') {
          value = new Date(Date.parse(json[key]));
        }
        this[key] = value;
      }
    }
  }

  function Discount(json) {
    for (var key in json) {
      if (json.hasOwnProperty(key)) {
        var value = json[key];
        if (key === 'valid_until') {
          value = new Date(Date.parse(json[key]));
        }
        this[key] = value;
      }
    }
  }

  Discount.prototype = {
    isExpired: function () {
      return new Date() > this.valid_until;
    },

    appliesTo: function (sessions) {
      if (this.isExpired()) { return []; }

      if (this.active_when.ids) {
        var ids = this.active_when.ids;
        sessions = sessions.filter(function (session) {
          return ids.indexOf(session.id) !== -1;
        });
      }

      if (this.active_when.count &&
          sessions.length !== this.active_when.count) {
        return [];
      }
      return sessions;
    }
  };

  var eventId = location.pathname.match(/\/events\/(\d+)/)[1];
  var store = {
    sessions: [],
    discounts: []
  };

  $.get('/events/' + eventId + '/sessions').then(function (result) {
    store.sessions = result.sessions;
    calculate();
  });

  $.get('/events/' + eventId + '/discounts').then(function (result) {
    store.discounts = result.discounts.map(function (json) {
      return new Discount(json);
    });
    calculate();
  });

  function calculate() {
    var items = $('form').serializeArray();

    var sessions = [];
    for (var i = 0, len = items.length; i < len; i++) {
      if (items[i].name.indexOf("sessions") === 0) {
        var id = items[i].name.match(/sessions\[(\d+)\]/)[1];
        sessions.push(store.sessions.find(function (session) {
          return session.id == id;
        }));
      }
    }

    var subtotal = sessions.reduce(function (price, session) {
      return price + session.cost.fractional;
    }, 0) / 100;

    var discount = store.discounts.reduce(function (savings, discount) {
      var discountedSessions = discount.appliesTo(sessions);
      if (discountedSessions.length > 0) {
        savings += discount.amount.fractional;
      }
      return savings;
    }, 0) / 100;

    console.log(discount);

    $('#subtotal').html('$' + subtotal);
    $('#discounts').html('-$' + Math.abs(discount));
    $('#total').html('$' + (subtotal + discount));
  }

  calculate();
});
