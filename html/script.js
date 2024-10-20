window.addEventListener('message', function(event) {
    if (event.data.type === 'ui') {
        if (event.data.display) {
            document.getElementById('container').style.display = 'block';
            document.getElementById('model').innerText = "Model: " + event.data.model;  
            document.getElementById('plate').innerText = "Plaka: " + event.data.plate;  
        } else {
            document.getElementById('container').style.display = 'none';
        }
    }
});
