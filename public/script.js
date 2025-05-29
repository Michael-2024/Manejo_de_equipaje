fetch('/api/pasajeros')
  .then(res => res.json())
  .then(pasajeros => {
    const lista = document.getElementById('lista');
    lista.innerHTML = '';
    pasajeros.forEach(p => {
      const li = document.createElement('li');
      li.textContent = `${p.nombre} ${p.apellido} - ${p.email}`;
      lista.appendChild(li);
    });
  })
  .catch(err => {
    console.error('Error al obtener pasajeros:', err);
  });
