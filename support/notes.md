## Custom Elements

### matrix-card

### matrix-drawer

### matrix-list
OPTIONAL: title (`[any].title`)
CONTENT: any number of `matrix-list-item` elements.  No other content will be displayed.

### matrix-list-item
OPTIONAL: `core-icon`
OPTIONAL: title (`[any].title`)
CONTENT: any additional content 

### matrix-scaffold
A single-page application scaffold


### matrix-square
OPTIONAL: `side` (integer; default 100) - side length in pixels
CONTENT: unrestricted
PURPOSE: A square element


### matrix-toolbar
CONTENT: `core-icon`, `img` - toolbar icon
CONTENT: Any additional content, e.g., title


### matrix-shadow
ATTRIBUTE: `z` (integer; 1-5) - element elevation
ATTRIBUTE: `animated` (NO VALUE) - should the element animate elevation changes
METHOD: `setZ(zValue)`
Provides paper-shadow-like properties to an element.  Place this inside any other block element to apply shadow.


### matrix-style-utilities
METHOD: `mirrorStyle: (model, target, [blacklist], [whitelist])`


### matrix-grid-utilities
METHOD: `rowOffset: (element, direction)`
METHOD: `leftOffset: (element)` - alias for `rowOffset(element, 'previous')`
METHOD: `rightOffset: (element)` - alias for `rowOffset(element, 'next')`


### matrix-ghost


### Utility Components

#### matrix-floating-transform


#### matrix-element-utilities


#### matrix-grid-utilities


#### matrix-string-utilities


#### matrix-style-utilities


#### matrix-type-utilities