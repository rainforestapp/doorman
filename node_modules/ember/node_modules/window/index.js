if ('undefined' === typeof window) {
  // extend the global namespace so that 
  window = require('jsdom').jsdom().createWindow(this);
  //window.XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest;
}

if ('undefined' === typeof document) {
  document = window.document;
}

module.exports = window;
