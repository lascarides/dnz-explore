///////////////////////////
//
// INITIALIZATION
//


$(document).ready(function() {

	loadMasonryGutterResets();

	// Start isotope
	$('#playground').isotope({
		itemSelector : '.item',
		layoutMode : 'fitRows',
		getSortData : {
			org : function ( $elem ) {
				return $elem.attr('data-org');
			},
			count : function ( $elem ) {
				return parseInt($elem.attr('data-coll-size'));
			},
			coll : function ( $elem ) {
				return $elem.attr('data-coll-name');
			}
		}
	});
	$('#histo').isotope({
		itemSelector : '.tiny-item',
		layoutMode : 'fitRows',
		getSortData : {
			org : function ( $elem ) {
				return $elem.attr('data-org');
			},
			count : function ( $elem ) {
				return parseInt($elem.attr('data-coll-size'));
			},
			coll : function ( $elem ) {
				return $elem.attr('data-coll-name');
			}
		}
	});

	// Sort buttons 
	$('#sort_org').click(function() {
		$('.iso-canvas').isotope({ sortBy : 'org' });
		return false;
	});
	$('#sort_collection').click(function() {
		$('.iso-canvas').isotope({ sortBy : 'coll' });
		return false;
	});
	$('#sort_size').click(function() {
		$('.iso-canvas').isotope({ sortBy : 'count' });
		return false;
	});

	// Item highlight
	$('.item, .tiny-item').click(function(){
		$(this).toggleClass('item-highlight');
		$('.iso-canvas').isotope('reLayout');
	});

});

///////////////////////////
//
// ISOTOPE/MASONRY ADD-ONS
//

function loadMasonryGutterResets() {
// modified Isotope methods for gutters in masonry
  $.Isotope.prototype._getMasonryGutterColumns = function() {
    var gutter = this.options.masonry && this.options.masonry.gutterWidth || 0;
        containerWidth = this.element.width();
  
    this.masonry.columnWidth = this.options.masonry && this.options.masonry.columnWidth ||
                  // or use the size of the first item
                  this.$filteredAtoms.outerWidth(true) ||
                  // if there's no items, use size of container
                  containerWidth;

    this.masonry.columnWidth += gutter;

    this.masonry.cols = Math.floor( ( containerWidth + gutter ) / this.masonry.columnWidth );
    this.masonry.cols = Math.max( this.masonry.cols, 1 );
  };

  $.Isotope.prototype._masonryReset = function() {
    // layout-specific props
    this.masonry = {};
    // FIXME shouldn't have to call this again
    this._getMasonryGutterColumns();
    var i = this.masonry.cols;
    this.masonry.colYs = [];
    while (i--) {
      this.masonry.colYs.push( 0 );
    }
  };

  $.Isotope.prototype._masonryResizeChanged = function() {
    var prevSegments = this.masonry.cols;
    // update cols/rows
    this._getMasonryGutterColumns();
    // return if updated cols/rows is not equal to previous
    return ( this.masonry.cols !== prevSegments );
  };
 }
