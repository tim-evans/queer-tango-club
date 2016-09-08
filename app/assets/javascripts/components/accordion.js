$(function () {
  var $element = $('.accordion');
  if (!$element.length) { return; }

  function Accordion(element) {
    this.id = $(element).data('accordion');
    this.$ = $(element);
    $('#' + this.id).css('overflow', 'hidden');
    this.isLastChild = $('#' + this.id).index() === $(element).parent().children().length - 1;

    this.expanded = !this.$.hasClass('collapsed');
    if (!this.expanded) {
      this.isLastChild = false;
      $('#' + this.id).css({ height: 0, opacity: 0, marginBottom: 0 });
    }

    var self = this;
    if (this.$.find('input[type="checkbox"]').length) {
      this.$.on('change', function () {
        self.toggle();
      });
    } else {
      this.$.on('click', function () {
        self.toggle();
      });
    }
  }

  Accordion.prototype = {
    expand: function () {
      this.expanded = true;
      updateExpandAll();
      this.$.removeClass('collapsed');

      var style = $('#' + this.id).attr('style');
      $('#' + this.id).removeAttr('style');
      height = $('#' + this.id).height();
      $('#' + this.id).attr('style', style);
      $('#' + this.id).animate({ height: height, opacity: 1, marginBottom: 0 }, 200);
    },

    collapse: function () {
      this.expanded = false;
      updateExpandAll();
      this.$.addClass('collapsed');

      var margin = this.isLastChild ? 50 : 0;
      $('#' + this.id).animate({ height: 0, opacity: 0, marginBottom: margin }, 200);
    },

    toggle: function () {
      if (this.expanded) {
        this.collapse();
      } else {
        this.expand();
      }
    }
  };

  var accordions = [];
  $element.each(function () {
    accordions.push(new Accordion(this));
  });

  $('.accordion-expand-all').on('click', function (evt) {
    var areAnyCollapsed = accordions.some(function (accordion) {
      return !accordion.expanded;
    });

    if (areAnyCollapsed) {
      accordions.forEach(function (accordion) {
        accordion.expand();
      });
    } else {
      accordions.forEach(function (accordion) {
        accordion.collapse();
      });
    }
    evt.stopPropagation();
    evt.preventDefault();
  });

  function updateExpandAll() {
    if ($('.accordion-expand-all').length === 0) { return; }
    var areAnyCollapsed = accordions.some(function (accordion) {
      return !accordion.expanded;
    });

    if (areAnyCollapsed) {
      icon('.accordion-expand-all', 'add-solid');
      $('.accordion-expand-all span').html('Expand all');
    } else {
      icon('.accordion-expand-all', 'cancel-solid');
      $('.accordion-expand-all span').html('Collapse all');
    }
  }
});
