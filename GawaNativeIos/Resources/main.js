function addTextNode(text) {
  document.body.appendChild(document.createTextNode(text));
}

(function() {
  addTextNode('Hello, from JS');

  var touch = document.getElementById('touch');
  touch.addEventListener('touchstart', function(event) {
    touch.style.backgroundColor = 'red';
    event.stopPropagation();
    location.href = 'native://touchstart';
  });
  touch.addEventListener('touchend', function(event) {
    touch.style.backgroundColor = '';
    event.stopPropagation();
    location.href = 'native://touchend';
  });
})();
